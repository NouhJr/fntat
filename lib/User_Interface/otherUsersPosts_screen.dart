import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class OtherUsersPosts extends StatefulWidget {
  final userID;
  OtherUsersPosts({this.userID});
  @override
  _OtherUsersPostsState createState() => _OtherUsersPostsState(id: userID);
}

class _OtherUsersPostsState extends State<OtherUsersPosts> {
  final id;
  _OtherUsersPostsState({this.id});

  var userName = '';
  var userImage = "assets/images/nouserimagehandler.jpg";

  String noPostImage = "assets/images/nopostimagehandler.jpg";

  bool userAsset = true;

  final ScrollController _scrollController = ScrollController();

  bool loading = false;

  var dio = Dio();
  List<dynamic> posts = [];
  var nextPageUrl;

  gettingOtherUserOwnedPosts() async {
    var prefs = await SharedPreferences.getInstance();
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
            "http://164.160.104.125:9090/fntat/api/user-owned-posts",
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> getMorePosts() async {
    var prefs = await SharedPreferences.getInstance();
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
        setState(() {
          posts = [];
        });
      }
    }
  }

  late UserProfileBloc userProfileBloc;
  @override
  void initState() {
    super.initState();

    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingOtherUsersProfileData(userID: id));

    gettingOtherUserOwnedPosts();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        backgroundColor: KSubPrimaryColor,
        elevation: 0.0,
        title: Text(
          "Posts",
          style: AppNameStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KPrimaryColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingOtherUserProfileDataSuccessState) {
            setState(() {
              userName = state.name ?? "user name";
              if (state.image == null) {
              } else {
                setState(() {
                  userImage =
                      'http://164.160.104.125:9090/fntat/${state.image}';
                  setState(() {
                    userAsset = false;
                  });
                });
              }
            });
          }
        },
        child: posts.length != 0
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
                            elevation: 5.0,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      userAsset
                                          ? CircleAvatar(
                                              backgroundImage: AssetImage(
                                                userImage,
                                              ),
                                              radius: 25.0,
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                userImage,
                                              ),
                                              radius: 25.0,
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
                                              userName,
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
                                  Divider(
                                    color: KSubSecondryFontsColor,
                                    thickness: 0.5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              width: 170.0,
                                              height: 170.0,
                                              child: PhotoView(
                                                loadingBuilder: (context,
                                                        loading) =>
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  color: KPrimaryColor,
                                                  strokeWidth: 5.0,
                                                ),
                                                errorBuilder:
                                                    (context, _, err) =>
                                                        Image.asset(
                                                  noPostImage,
                                                ),
                                                imageProvider: NetworkImage(
                                                    "https://i.picsum.photos/id/851/200/200.jpg?hmac=JVRP-bj1-hofsGmrxkRZ4VaDr699PvCv6i8zcc6n-GQ"),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print("img 2");
                                            },
                                            child: Container(
                                              width: 170.0,
                                              height: 170.0,
                                              child: PhotoView(
                                                loadingBuilder: (context,
                                                        loading) =>
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  color: KPrimaryColor,
                                                  strokeWidth: 5.0,
                                                ),
                                                errorBuilder:
                                                    (context, _, err) =>
                                                        Image.asset(
                                                  noPostImage,
                                                ),
                                                imageProvider: NetworkImage(
                                                    "https://i.picsum.photos/id/851/200/200.jpg?hmac=JVRP-bj1-hofsGmrxkRZ4VaDr699PvCv6i8zcc6n-GQ"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print("img 1");
                                            },
                                            child: Container(
                                              width: 170.0,
                                              height: 170.0,
                                              child: PhotoView(
                                                loadingBuilder: (context,
                                                        loading) =>
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  color: KPrimaryColor,
                                                  strokeWidth: 5.0,
                                                ),
                                                errorBuilder:
                                                    (context, _, err) =>
                                                        Image.asset(
                                                  noPostImage,
                                                ),
                                                imageProvider: NetworkImage(
                                                    "https://i.picsum.photos/id/851/200/200.jpg?hmac=JVRP-bj1-hofsGmrxkRZ4VaDr699PvCv6i8zcc6n-GQ"),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print("img 2");
                                            },
                                            child: Container(
                                              width: 170.0,
                                              height: 170.0,
                                              child: PhotoView(
                                                loadingBuilder: (context,
                                                        loading) =>
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  color: KPrimaryColor,
                                                  strokeWidth: 5.0,
                                                ),
                                                errorBuilder:
                                                    (context, _, err) =>
                                                        Image.asset(
                                                  noPostImage,
                                                ),
                                                imageProvider: NetworkImage(
                                                    "https://i.picsum.photos/id/851/200/200.jpg?hmac=JVRP-bj1-hofsGmrxkRZ4VaDr699PvCv6i8zcc6n-GQ"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite_border,
                                              color: KWarningColor,
                                              size: 30.0,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              '${posts[index]['likes_count'] ?? "0"}',
                                              style: KTextFieldStyle,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.comment,
                                              size: 25.0,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              '${posts[index]['comments_count'] ?? "0"}',
                                              style: KTextFieldStyle,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.share,
                                              size: 25.0,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              '${posts[index]['shares_count'] ?? "0"}',
                                              style: KTextFieldStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }
}
