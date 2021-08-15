import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/User_Interface/otherUserFollowers_screen.dart';
import 'package:fntat/User_Interface/otherUserFollowing_screen.dart';
import 'package:fntat/User_Interface/postDetails_screen.dart';
import 'package:fntat/User_Interface/addComment_screen.dart';
import 'package:fntat/User_Interface/sharePost_screen.dart';
import 'package:fntat/User_Interface/chat_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class OtherUsersProfile extends StatefulWidget {
  final userID;
  OtherUsersProfile({this.userID});
  @override
  _OtherUsersProfileState createState() => _OtherUsersProfileState(id: userID);
}

class _OtherUsersProfileState extends State<OtherUsersProfile> {
  final id;
  _OtherUsersProfileState({required this.id});

  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  bool isFriend = false;
  List<String>? followingIds = [];
  var userName = '';
  var userEmail = '';
  var userPhone = '';
  var userImage = "assets/images/nouserimagehandler.jpg";
  var noUserImage = "assets/images/nouserimagehandler.jpg";
  bool useAsset = true;
  var followersCount = 0;
  var followingCount = 0;
  var postsCount = 0;
  var dio = Dio();
  List<dynamic> posts = [];
  var nextPageUrl;
  bool loading = false;

  checkFriend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ids = prefs.getStringList("FollowingIDs");
    setState(() {
      followingIds = ids;
    });
    if (followingIds!.contains(id.toString())) {
      setState(() {
        isFriend = true;
      });
    }
  }

  Future getOtherUserDataOnRefresh() async {
    gettingOtherUsersProfileData();
    getOtherUsersFollowingFollowersCount();
    gettingOtherUserOwnedPosts();
  }

  gettingOtherUsersProfileData() async {
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
        "http://164.160.104.125:9090/fntat/api/profile",
        data: formData,
      );
      final data = res.data;
      setState(() {
        userName = data['data']['name'];
        userEmail = data['data']['email'];
        userPhone = data['data']['phone'];
      });
      if (data['data']['image'] != null) {
        setState(() {
          userImage = data['data']['image'];
          useAsset = false;
        });
      }
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  getOtherUsersFollowingFollowersCount() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    try {
      Future.delayed(Duration(seconds: 3));
      final res = await dio.post(
        "http://164.160.104.125:9090/fntat/api/number-of-followers",
        data: formData,
      );
      final data = res.data;
      setState(() {
        followersCount = data['user_followers'];
        followingCount = data['user_following'];
        postsCount = data['no_of_posts'];
      });
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  gettingOtherUserOwnedPosts() async {
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
    }
    gettingLikes();
  }

  getMorePosts() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    if (nextPageUrl == null) {
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
      gettingLikes();
    }
  }

  var userId = 0;
  gettingUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    setState(() {
      userId = id!;
    });
  }

  List<dynamic> userLikes = [];
  List<dynamic> tempLikesBody = [];
  gettingLikes() {
    if (posts.isNotEmpty) {
      for (var i = 0; i < posts.length; i++) {
        if (userLikes.length < posts.length) {
          setState(() {
            userLikes.add({'id': userId, 'likeState': false, 'likeID': null});
          });
        }
        setState(() {
          tempLikesBody = posts[i]['like'];
        });
        if (tempLikesBody.isNotEmpty) {
          for (var j = 0; j < tempLikesBody.length; j++) {
            if (userId == tempLikesBody[j]['user_id']) {
              setState(() {
                userLikes[i]['likeState'] = true;
                userLikes[i]['likeID'] = tempLikesBody[j]['id'];
              });
            }
          }
        }
      }
    }
  }

  like(int postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    FormData formData = FormData.fromMap({
      "post_id": postID,
    });
    try {
      await dio.post("http://164.160.104.125:9090/fntat/api/add-like",
          data: formData);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  unLike(int postID, int likeID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    FormData formData = FormData.fromMap({
      "post_id": postID,
      "like_id": likeID,
    });
    try {
      await dio.post("http://164.160.104.125:9090/fntat/api/delete-like",
          data: formData);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  displayPostImage(String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350.0,
          height: 230.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
              image: NetworkImage('http://164.160.104.125:9090/fntat/$image'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  makeFriend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ids = prefs.getStringList("FollowingIDs");
    setState(() {
      followingIds = ids;
      followingIds!.add(id.toString());
    });
    prefs.setStringList("FollowingIDs", followingIds!);
  }

  removeFriend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ids = prefs.getStringList("FollowingIDs");
    setState(() {
      followingIds = ids;
    });
    int userIdIndex = followingIds!.indexOf(id.toString());
    setState(() {
      followingIds!.removeAt(userIdIndex);
    });
    prefs.setStringList("FollowingIDs", followingIds!);
  }

  bool showLoading = true;
  bool hasConnection = false;

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
          "There's no posts for this account yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  internetConnection() {
    if (!hasConnection) {
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
                      getOtherUserDataOnRefresh();
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

  List<dynamic> post = [];
  List<dynamic> singlePostLikes = [];
  List<dynamic> singlePostTempLikes = [];
  bool singlePostLikeState = false;
  // ignore: avoid_init_to_null
  var singlePostLikeID = null;
  var user;

  gettingSinglePostLikes(List<dynamic> likes) {
    if (likes.isNotEmpty) {
      for (var i = 0; i < likes.length; i++) {
        if (userId == likes[i]['user_id']) {
          setState(() {
            singlePostLikeState = true;
            singlePostLikeID = likes[i]['id'];
          });
        }
      }
    }
  }

  gettingSharedPostData(var postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    FormData postFormData = FormData.fromMap({
      "post_id": postID,
    });
    try {
      final postRes = await dio.post(
          "http://164.160.104.125:9090/fntat/api/get-post-by-id?post_id=$postID",
          data: postFormData);
      final List<dynamic> postsBody = postRes.data['data']['data'];
      final List<dynamic> postLikes = postRes.data['data']['data'][0]['like'];
      final userData = postRes.data['data']['data'][0]['user'];
      setState(() {
        post = postsBody;
        user = userData;
        singlePostLikes = postLikes;
      });
    } on Exception catch (error) {
      print(error.toString());
    }
    gettingSinglePostLikes(singlePostLikes);
  }

  checkIfPostLoaded() {
    Future.delayed(Duration(seconds: 3));
    if (post.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  singlePostStateIndicator() {
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
          "Error loading post",
          style: KErrorStyle,
        ),
      );
    }
  }

  displayPost(var postID) {
    gettingSharedPostData(postID);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1.0,
      child: checkIfPostLoaded()
          ? Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      userId != user['id']
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtherUsersProfile(
                                  userID: user['id'],
                                ),
                              ),
                            )
                          : Navigator.pushNamed(context, '/Profile');
                    },
                    child: Row(
                      children: [
                        user['image'] == null
                            ? CircleAvatar(
                                backgroundImage: AssetImage(
                                  noUserImage,
                                ),
                                radius: 20.0,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'http://164.160.104.125:9090/fntat/${user['image']}',
                                ),
                                radius: 20.0,
                              ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user['name']}',
                                style: KNameInSubPostStyle,
                              ),
                              post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('00') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('01') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('02') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('03') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('04') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('05') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('06') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('07') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('08') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('09') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('10') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('11')
                                  ? Text(
                                      '${post[0]['updated_at'].toString().substring(11, 16)} AM',
                                      style: KPostTimeStyle,
                                    )
                                  : post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('12')
                                      ? Text(
                                          '12:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                          style: KPostTimeStyle,
                                        )
                                      : post[0]['updated_at']
                                              .toString()
                                              .substring(11, 13)
                                              .contains('13')
                                          ? Text(
                                              '1:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                              style: KPostTimeStyle,
                                            )
                                          : post[0]['updated_at']
                                                  .toString()
                                                  .substring(11, 13)
                                                  .contains('14')
                                              ? Text(
                                                  '2:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                  style: KPostTimeStyle,
                                                )
                                              : post[0]['updated_at']
                                                      .toString()
                                                      .substring(11, 13)
                                                      .contains('15')
                                                  ? Text(
                                                      '3:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                      style: KPostTimeStyle,
                                                    )
                                                  : post[0]['updated_at']
                                                          .toString()
                                                          .substring(11, 13)
                                                          .contains('16')
                                                      ? Text(
                                                          '4:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                          style: KPostTimeStyle,
                                                        )
                                                      : post[0]['updated_at']
                                                              .toString()
                                                              .substring(11, 13)
                                                              .contains('17')
                                                          ? Text(
                                                              '5:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                              style:
                                                                  KPostTimeStyle,
                                                            )
                                                          : post[0]['updated_at'].toString().substring(11, 13).contains('18')
                                                              ? Text(
                                                                  '6:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                  style:
                                                                      KPostTimeStyle,
                                                                )
                                                              : post[0]['updated_at'].toString().substring(11, 13).contains('19')
                                                                  ? Text(
                                                                      '7:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                      style:
                                                                          KPostTimeStyle,
                                                                    )
                                                                  : post[0]['updated_at'].toString().substring(11, 13).contains('20')
                                                                      ? Text(
                                                                          '8:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                          style:
                                                                              KPostTimeStyle,
                                                                        )
                                                                      : post[0]['updated_at'].toString().substring(11, 13).contains('21')
                                                                          ? Text(
                                                                              '9:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                              style: KPostTimeStyle,
                                                                            )
                                                                          : post[0]['updated_at'].toString().substring(11, 13).contains('22')
                                                                              ? Text(
                                                                                  '10:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                  style: KPostTimeStyle,
                                                                                )
                                                                              : post[0]['updated_at'].toString().substring(11, 13).contains('23')
                                                                                  ? Text(
                                                                                      '11:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                      style: KPostTimeStyle,
                                                                                    )
                                                                                  : post[0]['updated_at'].toString().substring(11, 13).contains('00')
                                                                                      ? Text(
                                                                                          '12:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                          style: KPostTimeStyle,
                                                                                        )
                                                                                      : Text(''),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailsScreen(
                                postID: postID,
                                likeState: singlePostLikeState,
                                likeID: singlePostLikeID,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                post[0]['post'],
                                style: KSubPostStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  post[0]['image_flag'] == 1
                      ? displayPostImage(post[0]['images'][0]['image'])
                      : Container(),
                ],
              ),
            )
          : singlePostStateIndicator(),
    );
  }

  late UserProfileBloc userbloc;
  @override
  void initState() {
    super.initState();
    checkConnection();
    userbloc = BlocProvider.of<UserProfileBloc>(context);
    gettingUserId();
    checkFriend();
    gettingOtherUsersProfileData();
    getOtherUsersFollowingFollowersCount();
    if (posts.isEmpty) {
      gettingOtherUserOwnedPosts();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          posts.isNotEmpty) {
        setState(() {
          loading = true;
        });
        getMorePosts();
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
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: KPrimaryColor,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(receiverID: id),
                ),
              );
            },
          ),
          SizedBox(
            width: 10.0,
          ),
          !isFriend
              ? Row(
                  children: [
                    Container(
                      width: 90.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: KPrimaryColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            userbloc.add(
                              FollowButtonPressed(userID: id),
                            );
                          },
                          child: Text(
                            "Follow",
                            style: KSubPrimaryButtonsFontStyle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 125.0,
                      height: 35.0,
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(KPrimaryColor),
                            elevation: MaterialStateProperty.all(
                              1.0,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Following",
                            style: KSubPrimaryButtonsFontStyle2,
                          ),
                          onPressed: unFollow,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
        ],
      ),
      body: hasConnection
          ? BlocListener<UserProfileBloc, UserProfileState>(
              listener: (context, state) {
                if (state is FollowUserSuccessState) {
                  setState(() {
                    isFriend = true;
                  });
                  makeFriend();
                } else if (state is UnFollowUserSuccessState) {
                  setState(() {
                    isFriend = false;
                  });
                  removeFriend();
                }
              },
              child: RefreshIndicator(
                backgroundColor: KSubPrimaryColor,
                color: KPrimaryColor,
                strokeWidth: 3.0,
                child: ListView(
                  controller: _scrollController,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 52.0,
                              backgroundColor: KPrimaryColor,
                              child: useAsset
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(userImage),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          'http://164.160.104.125:9090/fntat/$userImage'),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            userName,
                            style: KUserNameStyle,
                          ),
                          Text(
                            userEmail,
                            style: KUserEmailStyle,
                          ),
                          Text(
                            userPhone,
                            style: KUserEmailStyle,
                          ),
                          Divider(
                            color: KSubPrimaryFontsColor,
                            thickness: 1.0,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Posts",
                                    style: KFollowing_FollowersStyle,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '$postsCount',
                                    style: KFollowing_FollowersStyle,
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OtherUserFollowersScreen(
                                        userID: id,
                                        numberOfFollowers: followersCount,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text("Followers",
                                        style: KFollowing_FollowersStyle),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      '$followersCount',
                                      style: KFollowing_FollowersStyle,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OtherUserFollowingScreen(
                                        userId: id,
                                        numberOfFollowing: followingCount,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Following",
                                      style: KFollowing_FollowersStyle,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      '$followingCount',
                                      style: KFollowing_FollowersStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                    posts.isNotEmpty
                        ? LayoutBuilder(
                            builder: (context, size) => Stack(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 2.0,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  useAsset
                                                      ? CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  userImage),
                                                          radius: 30.0,
                                                        )
                                                      : CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'http://164.160.104.125:9090/fntat/$userImage'),
                                                          radius: 30.0,
                                                        ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userName,
                                                          style: KNameStyle,
                                                        ),
                                                        posts[index]['updated_at'].toString().substring(11, 13).contains('00') ||
                                                                posts[index]['updated_at'].toString().substring(11, 13).contains(
                                                                    '01') ||
                                                                posts[index]['updated_at']
                                                                    .toString()
                                                                    .substring(
                                                                        11, 13)
                                                                    .contains(
                                                                        '02') ||
                                                                posts[index]['updated_at']
                                                                    .toString()
                                                                    .substring(
                                                                        11, 13)
                                                                    .contains(
                                                                        '03') ||
                                                                posts[index]['updated_at']
                                                                    .toString()
                                                                    .substring(
                                                                        11, 13)
                                                                    .contains(
                                                                        '04') ||
                                                                posts[index]['updated_at']
                                                                    .toString()
                                                                    .substring(
                                                                        11, 13)
                                                                    .contains(
                                                                        '05') ||
                                                                posts[index]['updated_at']
                                                                    .toString()
                                                                    .substring(
                                                                        11, 13)
                                                                    .contains(
                                                                        '06') ||
                                                                posts[index]
                                                                        ['updated_at']
                                                                    .toString()
                                                                    .substring(11, 13)
                                                                    .contains('07') ||
                                                                posts[index]['updated_at'].toString().substring(11, 13).contains('08') ||
                                                                posts[index]['updated_at'].toString().substring(11, 13).contains('09') ||
                                                                posts[index]['updated_at'].toString().substring(11, 13).contains('10') ||
                                                                posts[index]['updated_at'].toString().substring(11, 13).contains('11')
                                                            ? Text(
                                                                '${posts[index]['updated_at'].toString().substring(11, 16)} AM',
                                                                style:
                                                                    KPostTimeStyle,
                                                              )
                                                            : posts[index]['updated_at'].toString().substring(11, 13).contains('12')
                                                                ? Text(
                                                                    '12:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                    style:
                                                                        KPostTimeStyle,
                                                                  )
                                                                : posts[index]['updated_at'].toString().substring(11, 13).contains('13')
                                                                    ? Text(
                                                                        '1:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                        style:
                                                                            KPostTimeStyle,
                                                                      )
                                                                    : posts[index]['updated_at'].toString().substring(11, 13).contains('14')
                                                                        ? Text(
                                                                            '2:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                            style:
                                                                                KPostTimeStyle,
                                                                          )
                                                                        : posts[index]['updated_at'].toString().substring(11, 13).contains('15')
                                                                            ? Text(
                                                                                '3:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                style: KPostTimeStyle,
                                                                              )
                                                                            : posts[index]['updated_at'].toString().substring(11, 13).contains('16')
                                                                                ? Text(
                                                                                    '4:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                    style: KPostTimeStyle,
                                                                                  )
                                                                                : posts[index]['updated_at'].toString().substring(11, 13).contains('17')
                                                                                    ? Text(
                                                                                        '5:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                        style: KPostTimeStyle,
                                                                                      )
                                                                                    : posts[index]['updated_at'].toString().substring(11, 13).contains('18')
                                                                                        ? Text(
                                                                                            '6:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                            style: KPostTimeStyle,
                                                                                          )
                                                                                        : posts[index]['updated_at'].toString().substring(11, 13).contains('19')
                                                                                            ? Text(
                                                                                                '7:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                style: KPostTimeStyle,
                                                                                              )
                                                                                            : posts[index]['updated_at'].toString().substring(11, 13).contains('20')
                                                                                                ? Text(
                                                                                                    '8:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                    style: KPostTimeStyle,
                                                                                                  )
                                                                                                : posts[index]['updated_at'].toString().substring(11, 13).contains('21')
                                                                                                    ? Text(
                                                                                                        '9:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                        style: KPostTimeStyle,
                                                                                                      )
                                                                                                    : posts[index]['updated_at'].toString().substring(11, 13).contains('22')
                                                                                                        ? Text(
                                                                                                            '10:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                            style: KPostTimeStyle,
                                                                                                          )
                                                                                                        : posts[index]['updated_at'].toString().substring(11, 13).contains('23')
                                                                                                            ? Text(
                                                                                                                '11:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                                style: KPostTimeStyle,
                                                                                                              )
                                                                                                            : posts[index]['updated_at'].toString().substring(11, 13).contains('00')
                                                                                                                ? Text(
                                                                                                                    '12:${posts[index]['updated_at'].toString().substring(14, 16)} AM',
                                                                                                                    style: KPostTimeStyle,
                                                                                                                  )
                                                                                                                : Text(''),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: KSubSecondryFontsColor,
                                                thickness: 0.5,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  var connectivityResult =
                                                      await (Connectivity()
                                                          .checkConnectivity());
                                                  if (connectivityResult ==
                                                      ConnectivityResult.none) {
                                                    Warning().errorMessage(
                                                      context,
                                                      title:
                                                          "No internet connection !",
                                                      message:
                                                          "Pleas turn on wifi or mobile data",
                                                      icons:
                                                          Icons.signal_wifi_off,
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PostDetailsScreen(
                                                          postID: posts[index]
                                                              ['id'],
                                                          likeState:
                                                              userLikes[index]
                                                                  ['likeState'],
                                                          likeID:
                                                              userLikes[index]
                                                                  ['likeID'],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            '${posts[index]['post'] ?? ""}',
                                                            style: KPostStyle,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              posts[index]['image_flag'] == 1
                                                  ? Container(
                                                      width: double.infinity,
                                                      child: displayPostImage(
                                                          posts[index]['images']
                                                              [0]['image']),
                                                    )
                                                  : SizedBox(
                                                      height: 5.0,
                                                    ),
                                              posts[index]['post_shared_id'] !=
                                                      null
                                                  ? displayPost(
                                                      posts[index]
                                                          ['post_shared_id'],
                                                    )
                                                  : Container(),
                                              Divider(
                                                color: KSubSecondryFontsColor,
                                                thickness: 0.5,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${posts[index]['likes_count'] ?? "0"} Likes',
                                                          style:
                                                              KLikesCommentsAndSharesCount,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              '${posts[index]['comments_count'] ?? "0"} Comments',
                                                              style:
                                                                  KLikesCommentsAndSharesCount,
                                                            ),
                                                            Text(
                                                              ' • ',
                                                              style:
                                                                  KLikesCommentsAndSharesCount,
                                                            ),
                                                            Text(
                                                              '${posts[index]['shares_count'] ?? "0"} Shares',
                                                              style:
                                                                  KLikesCommentsAndSharesCount,
                                                            ),
                                                          ],
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
                                              Container(
                                                height: 25.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    userLikes[index]
                                                            ['likeState']
                                                        ? IconButton(
                                                            icon: Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  KWarningColor,
                                                            ),
                                                            iconSize: 21.0,
                                                            onPressed: () {
                                                              unLike(
                                                                  posts[index]
                                                                      ['id'],
                                                                  userLikes[
                                                                          index]
                                                                      [
                                                                      'likeID']);
                                                              setState(() {
                                                                userLikes[index]
                                                                        [
                                                                        'likeState'] =
                                                                    false;
                                                              });
                                                            },
                                                          )
                                                        : IconButton(
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .heart,
                                                              color:
                                                                  KSubSecondryFontsColor,
                                                            ),
                                                            iconSize: 20.0,
                                                            onPressed: () {
                                                              like(posts[index]
                                                                  ['id']);
                                                              setState(() {
                                                                userLikes[index]
                                                                        [
                                                                        'likeState'] =
                                                                    true;
                                                              });
                                                            },
                                                          ),
                                                    SizedBox(
                                                      width: 20.0,
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .commentAlt,
                                                      ),
                                                      iconSize: 20.0,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddComment(
                                                              postID:
                                                                  posts[index]
                                                                      ['id'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 20.0,
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .shareAlt,
                                                      ),
                                                      iconSize: 20.0,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    SharePost(
                                                              postID:
                                                                  posts[index]
                                                                      ['id'],
                                                              userID: posts[
                                                                      index]
                                                                  ['user_id'],
                                                            ),
                                                          ),
                                                        );
                                                      },
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
                        : stateIndicator(),
                  ],
                ),
                onRefresh: getOtherUserDataOnRefresh,
              ),
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

  unFollow() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: KPrimaryFontsColor,
            elevation: 1.0,
            title: Text(
              "UnFollow",
              style: TextStyle(
                color: KSubPrimaryFontsColor,
                fontFamily: KPrimaryFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
                height: 1.3,
              ),
            ),
            content: Text(
              "Are you sure? un follow will remove this user from your following list",
              style: TextStyle(
                color: KSubPrimaryFontsColor,
                fontFamily: KPrimaryFontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                height: 1.3,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: KSubPrimaryFontsColor,
                    fontFamily: KPrimaryFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    height: 1.3,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: KSubPrimaryFontsColor,
                    fontFamily: KPrimaryFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    height: 1.3,
                  ),
                ),
                onPressed: () {
                  userbloc.add(
                    UnFollowButtonPressed(userID: id),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
