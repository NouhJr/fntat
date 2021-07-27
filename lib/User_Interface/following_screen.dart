import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final ScrollController _scrollController = ScrollController();

  bool loading = false;

  var dio = Dio();
  List<dynamic> following = [];

  gettingFollowing() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else {
      try {
        final res = await dio.post(
            "http://164.160.104.125:9090/fntat/api/all-followers-followings",
            data: formData);
        final List<dynamic> body = res.data['user_following'];
        setState(() {
          following = body;
        });
      } on Exception catch (error) {
        print(error.toString());
        setState(() {
          following = [];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    gettingFollowing();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //           _scrollController.position.maxScrollExtent &&
    //       followers.isNotEmpty) {
    //     setState(() {
    //       loading = true;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
          "Your Followers",
          style: AppNameStyle,
        ),
      ),
      body: following.isNotEmpty
          ? LayoutBuilder(
              builder: (context, size) => Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    itemCount: following.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Container(
                          height: 80.0,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5.0,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'http://164.160.104.125:9090/fntat/${following[index]?['user']['image'] ?? "public/pages/profiles/1626088458.PNG"}'),
                                radius: 25.0,
                              ),
                              title: Text(
                                '${following[index]['user']['name']}',
                                style: KNameStyle,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherUsersProfile(
                                              userID: following[index]['user']
                                                  ['id'],
                                            )));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (loading) ...[
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: size.maxWidth,
                        height: 80.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: KSubPrimaryColor,
                            color: KPrimaryColor,
                            strokeWidth: 5.0,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: KSubPrimaryColor,
                color: KPrimaryColor,
                strokeWidth: 5.0,
              ),
            ),
    );
  }
}
