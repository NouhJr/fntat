import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class OtherUserFollowersScreen extends StatefulWidget {
  final userID;
  final numberOfFollowers;
  OtherUserFollowersScreen({this.userID, this.numberOfFollowers});
  @override
  _OtherUserFollowersScreenState createState() =>
      _OtherUserFollowersScreenState(
          id: userID, numOfFollowers: numberOfFollowers);
}

class _OtherUserFollowersScreenState extends State<OtherUserFollowersScreen> {
  final id;
  final numOfFollowers;
  _OtherUserFollowersScreenState(
      {required this.id, required this.numOfFollowers});

  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  bool loading = false;
  bool hasConnection = false;
  bool showLoading = true;

  String userImage = "assets/images/nouserimagehandler.jpg";

  int currentUserId = 0;
  getCurrentUserId() async {
    var pref = await SharedPreferences.getInstance();
    var currUserId = pref.getInt("USERID");
    setState(() {
      currentUserId = currUserId!;
    });
  }

  var dio = Dio();
  List<dynamic> followers = [];
  Future<void> gettingFollowers() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    try {
      final res = await dio.post(
          "http://164.160.104.125:9090/fntat/api/all-followers-followings",
          data: formData);
      final List<dynamic> followersList = res.data['user_followers'];
      setState(() {
        followers = followersList;
      });
    } on Exception catch (error) {
      print(error.toString());
      setState(() {
        followers = [];
      });
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

  @override
  void initState() {
    super.initState();
    checkConnection();
    if (numOfFollowers != 0) {
      getCurrentUserId();
      gettingFollowers();
      _scrollController.addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KSubPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KPrimaryColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        title: Text(
          "Followers",
          style: AppNameStyle,
        ),
      ),
      body: condionalWidget(),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(
                Icons.arrow_upward,
                color: KPrimaryFontsColor,
                size: 30.0,
              ),
              backgroundColor: KPrimaryColor,
            ),
    );
  }

  condionalWidget() {
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
                      gettingFollowers();
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
    } else if (numOfFollowers == 0) {
      return Center(
        child: Text(
          "This user has no followers",
          style: KErrorStyle,
        ),
      );
    } else {
      if (followers.isNotEmpty) {
        return RefreshIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 3.0,
          child: LayoutBuilder(
            builder: (context, size) => ListView.separated(
              separatorBuilder: (context, index) => Divider(
                thickness: 1.0,
              ),
              itemCount: followers.length,
              itemBuilder: (context, index) => Column(
                children: [
                  ListTile(
                    leading: followers[index]['user']['image'] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                'http://164.160.104.125:9090/fntat/${followers[index]['user']['image']}'),
                            radius: 25.0,
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage(userImage),
                            radius: 25.0,
                          ),
                    title: Text(
                      '${followers[index]['user']['name']}',
                      style: KNameStyle,
                    ),
                    onTap: () {
                      if (currentUserId == followers[index]['user']['id']) {
                        Navigator.pushNamed(context, '/Profile');
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherUsersProfile(
                              userID: followers[index]['user']['id'],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          onRefresh: gettingFollowers,
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: KSubPrimaryColor,
            color: KPrimaryColor,
            strokeWidth: 5.0,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
