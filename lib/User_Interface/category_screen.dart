import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class Category extends StatefulWidget {
  final categoryID;
  Category({this.categoryID});
  @override
  _CategoryState createState() => _CategoryState(catID: categoryID);
}

class _CategoryState extends State<Category> {
  final int catID;
  _CategoryState({required this.catID});

  List<dynamic> catUsers = [];
  String noUserImage = "assets/images/nouserimagehandler.jpg";
  bool showLoading = true;
  bool hasConnection = false;
  var nextPageUrl;
  var dio = Dio();

  @override
  void initState() {
    super.initState();
    checkConnection();
    gettingUsersInCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        backgroundColor: KSubPrimaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: KPrimaryColor,
            size: 30.0,
          ),
          onPressed: () => {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false),
          },
        ),
        title: Text(
          "Category",
          style: KScreenTitlesStyle,
        ),
      ),
      body: hasConnection
          ? catUsers.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    leading: catUsers[index]['user']['image'] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                '$ImageServerPrefix/${catUsers[index]['user']['image']}'),
                            radius: 30.0,
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage(noUserImage),
                            radius: 30.0,
                          ),
                    title: Text(
                      '${catUsers[index]['user']['name']}',
                      style: KNameStyle,
                    ),
                    subtitle: Text(
                      '${catUsers[index]['user']['email']}',
                      style: KUserEmailStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherUsersProfile(
                            userID: catUsers[index]['user']['id'],
                          ),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => Divider(
                    color: KSubSecondryFontsColor,
                    thickness: 0.5,
                  ),
                  itemCount: catUsers.length,
                )
              : stateIndicator()
          : internetConnection(),
    );
  }

  gettingUsersInCategory() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    try {
      final res =
          await dio.post('$ServerUrl/users-same-category?category_id=$catID');
      final List<dynamic> resBody = res.data['data']['data'];
      final nextPage = res.data['data']['next_page_url'];
      setState(() {
        catUsers = resBody;
        nextPageUrl = nextPage;
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  // gettingMoreUsers() async{
  //       var prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString("TOKEN");
  //   dio.options.headers["authorization"] = "Bearer $token";
  //   try {
  //     final res = await dio.post(
  //         "http://164.160.104.125:9090/fntat/api/users-same-category?category_id=$catID");
  //     final List<dynamic> resBody = res.data['data']['data'];
  //     final nextPage = res.data['data']['next_page_url'];
  //     setState(() {
  //       catUsers.addAll(resBody);
  //       nextPageUrl = nextPage;
  //     });
  //   } on Exception catch (e) {
  //     print(e.toString());
  //   }
  // }

  stateIndicator() {
    if (showLoading) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoading = false;
          });
        }
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 5.0,
        ),
      );
    } else {
      return Center(
        child: Text(
          "There's no users in this category yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  internetConnection() {
    if (showLoading) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoading = false;
          });
        }
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 5.0,
        ),
      );
    } else if (!hasConnection) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: 350.0,
              height: 230.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                image: DecorationImage(
                  image: AssetImage("assets/images/Internet-Access-Error.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 120.0,
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3.0,
                  color: KPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
              ),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                      Warning().errorMessage(
                        context,
                        title: "No internet connection !",
                        message: "Pleas turn on wifi or mobile data",
                        icons: Icons.signal_wifi_off,
                      );
                    } else {
                      setState(() {
                        hasConnection = true;
                      });
                      gettingUsersInCategory();
                    }
                  },
                  child: Text(
                    "Refresh",
                    style: KSubPrimaryButtonsFontStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasConnection = false;
      });
    } else {
      setState(() {
        hasConnection = true;
      });
    }
  }
}
