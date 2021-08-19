import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fntat/User_Interface/postDetails_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';
import 'package:fntat/Components/carousel.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ScrollController _scrollController = ScrollController();
  var dio = Dio();
  List<dynamic> notifications = [];
  var nextPageUrl;
  bool showLoading = true;
  bool hasConnection = false;
  bool loading = false;
  bool _showBackToTopButton = false;

  Future gettingNotifications() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.get(
          "http://164.160.104.125:9090/fntat/api/my-notifications?user_id=$id");
      final List<dynamic> notificationsBody = res.data['data']['data'];
      final nextPageUrlBody = res.data['data']['next_page_url'];
      setState(() {
        notifications = notificationsBody;
        nextPageUrl = nextPageUrlBody;
      });
    } on Exception catch (error) {
      print(error);
    }
  }

  gettingMoreNotifications() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    if (nextPageUrl == null) {
      setState(() {
        loading = false;
      });
    } else {
      try {
        final res = await dio.get(nextPageUrl);
        final List<dynamic> notificationsBody = res.data['data']['data'];
        final nextPageUrlBody = res.data['data']['next_page_url'];
        setState(() {
          notifications.addAll(notificationsBody);
          nextPageUrl = nextPageUrlBody;
        });
      } on Exception catch (error) {
        print(error);
      }
    }
  }

  checkIfNotificationsLoaded() {
    Future.delayed(Duration(seconds: 3));
    if (notifications.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

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
        child: Column(
          children: [
            imagecarousel,
            SizedBox(
              height: 30.0,
            ),
            Text(
              "There's no notifications yet",
              style: KErrorStyle,
            ),
          ],
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
                      gettingNotifications();
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

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
    if (notifications.isEmpty) {
      gettingNotifications();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          notifications.isNotEmpty) {
        setState(() {
          loading = true;
        });
        gettingMoreNotifications();
      } else if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent) {
        setState(() {
          loading = false;
        });
      }
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      body: hasConnection
          ? RefreshIndicator(
              backgroundColor: KSubPrimaryColor,
              color: KPrimaryColor,
              strokeWidth: 3.0,
              child: checkIfNotificationsLoaded()
                  ? ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        imagecarousel,
                        ListView.separated(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                    '${notifications[index]['title']}',
                                    style: KNameStyle,
                                  ),
                                  subtitle: Text(
                                    '${notifications[index]['body']}',
                                    style: KPostStyle,
                                  ),
                                  onTap: notifications[index]['post_id'] != null
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostDetailsScreen(
                                                postID: notifications[index]
                                                    ['post_id'],
                                                likeID: null,
                                                likeState: false,
                                              ),
                                            ),
                                          );
                                        }
                                      : () {},
                                ),
                            separatorBuilder: (context, index) => Divider(
                                  color: KSubSecondryFontsColor,
                                  thickness: 0.5,
                                ),
                            itemCount: notifications.length),
                      ],
                    )
                  : stateIndicator(),
              onRefresh: gettingNotifications,
            )
          : internetConnection(),
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
