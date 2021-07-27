import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:photo_view/photo_view.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserFeed extends StatefulWidget {
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  final ScrollController _scrollController = ScrollController();

  bool loading = false;

  bool shrinked = false;

  String noPostImage = "assets/images/nopostimagehandler.jpg";
  String noUserImage = "assets/images/nouserimagehandler.jpg";

  var dio = Dio();
  List<dynamic> posts = [];
  var nextPageUrl;

  var userId = 0;
  gettingUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    setState(() {
      userId = id!;
    });
  }

  gettingPosts() async {
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
            "http://164.160.104.125:9090/fntat/api/home-page-posts",
            data: formData);
        final List<dynamic> postsBody = res.data['data']['data'];
        final nextPage = res.data['data']['next_page_url'];
        setState(() {
          posts = postsBody;
          nextPageUrl = nextPage;
        });
      } on Exception catch (error) {
        print(error.toString());
        setState(() {
          posts = [];
        });
      }
    }
  }

  List<dynamic> likes = [];
  List<dynamic> isLiked = [];

  gettingLikes() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    if (posts.isNotEmpty) {
      for (var x = 0; x < posts.length; x++) {
        setState(() {
          isLiked[x] = false;
        });
      }
      for (var i = 0; i < posts.length; i++) {
        likes.addAll(posts[i]['like']);
      }
    }
    for (var j = 0; j < posts.length; j++) {
      for (var y = 0; y < likes.length; y++) {
        if (id == likes[y]['user_id']) {
          setState(() {
            isLiked[j] = true;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    gettingUserId();

    gettingPosts();

    gettingLikes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          posts.isNotEmpty) {
        setState(() {
          loading = true;
        });
        getMorePosts();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (shrinked == false) {
          setState(() {
            shrinked = true;
          });
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
                ScrollDirection.forward &&
            _scrollController.position.pixels <=
                _scrollController.position.minScrollExtent) {
          if (shrinked == true) {
            setState(() {
              shrinked = false;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> getMorePosts() async {
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
    } else if (nextPageUrl == null) {
      setState(() {
        loading = false;
      });
    } else {
      try {
        final res = await dio.post(nextPageUrl, data: formData);
        final postsBody = res.data['data']['data'];
        final nextPage = res.data['data']['next_page_url'];
        setState(() {
          posts.addAll(postsBody);
          nextPageUrl = nextPage;
        });
      } on Exception catch (error) {
        print(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      body: posts.length != 0
          ? LayoutBuilder(
              builder: (context, size) => Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 3.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () => {
                                    if (userId == posts[index]['user_id'])
                                      {
                                        Navigator.pushNamed(
                                            context, '/Profile'),
                                      }
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OtherUsersProfile(
                                              userID: posts[index]['user_id'],
                                            ),
                                          ),
                                        ),
                                      }
                                  },
                                  child: Row(
                                    children: [
                                      posts[index]['user']['image'] != null
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  'http://164.160.104.125:9090/fntat/${posts[index]['user']['image']}'),
                                              radius: 30.0,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(noUserImage),
                                              radius: 30.0,
                                            ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${posts[index]['user']['name']}',
                                              style: KNameStyle,
                                            ),
                                            Text(
                                              '${posts[index]['updated_at'].toString().substring(11, 16)}',
                                              style: KPostTimeStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: KSubSecondryFontsColor,
                                  thickness: 0.5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${posts[index]['post']}',
                                            style: KPostStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.favorite_border,
                                            color: KWarningColor,
                                            size: 25.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            '${posts[index]['likes_count'] ?? "0"}',
                                            style: KLikesCommentsAndSharesCount,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.comment,
                                            size: 23.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            '${posts[index]['comments_count'] ?? "0"}',
                                            style: KLikesCommentsAndSharesCount,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.share,
                                            size: 23.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            '${posts[index]['shares_count'] ?? "0"}',
                                            style: KLikesCommentsAndSharesCount,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                            backgroundColor: Colors.transparent,
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
      floatingActionButton: shrinked
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/AddPost');
              },
              child: Icon(
                Icons.add,
                color: KPrimaryFontsColor,
                size: 30.0,
              ),
              backgroundColor: KPrimaryColor,
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/AddPost');
              },
              label: Text(
                "Add Post",
                style: KAddPostButtonStyle,
              ),
              backgroundColor: KPrimaryColor,
              icon: Icon(
                Icons.add,
                color: KPrimaryFontsColor,
                size: 30.0,
              ),
            ),
    );
  }
}
