import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/User_Interface/editPost_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/User_Interface/postDetails_screen.dart';
import 'package:fntat/User_Interface/sharePost_screen.dart';
import 'package:fntat/User_Interface/addComment_screen.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';
import 'package:fntat/Components/carousel.dart';

class UserFeed extends StatefulWidget {
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  ScrollController _scrollController = ScrollController();

  bool loading = false;
  bool shrinked = false;
  bool visible = true;
  bool useAsset = true;

  String noPostImage = "assets/images/nopostimagehandler.jpg";
  String noUserImage = "assets/images/nouserimagehandler.jpg";

  var dio = Dio();
  List<dynamic> posts = [];
  List<dynamic> comments = [];
   bool showLoadingComments = true;
  var nextPageUrl;
  var userId = 0;

  gettingUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    setState(() {
      userId = id!;
    });
  }

  Future gettingPosts() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.followRedirects = false;
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
    } on DioError catch (e) {
      print(e.response!.statusCode);
    } on Exception catch (error) {
      print(error.toString());
    }
    gettingLikes();
  }

  getPostComments(var pID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio
          .get("http://164.160.104.125:9090/fntat/api/show-post-comments/$pID");
      final List<dynamic> commentsBody = res.data['data'];
      setState(() {
        comments.addAll(commentsBody);
      });
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  commentsStateIndicator() {
    if (showLoadingComments) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoadingComments = false;
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
          "There's no comments for this post yet",
          style: KErrorStyle,
        ),
      );
    }
  }

      checkCommentsLength() {
    Future.delayed(Duration(seconds: 3));
    if (comments.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  
  Future getMorePosts() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.followRedirects = false;
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
        // gettingLikes();
      } on Exception catch (error) {
        print(error.toString());
      }
      gettingLikes();
    }
  }

  List<dynamic> userLikes = [];
  List<dynamic> tempLikesBody = [];
  gettingLikes() {
    Future.delayed(Duration(seconds: 3));
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

  List<dynamic> post = [];
  List<dynamic> singlePostLikes = [];
  List<dynamic> singlePostTempLikes = [];
  bool singlePostLikeState = false;
  // ignore: avoid_init_to_null
  var singlePostLikeID = null;
  var user;

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
    try {
      final postRes = await dio.post(
        "http://164.160.104.125:9090/fntat/api/get-post-by-id?post_id=$postID",
      );
      final List<dynamic> postsBody = postRes.data['data']['data'];
      final List<dynamic> postLikes = postRes.data['data']['data'][0]['like'];
      final userData = postRes.data['data']['data'][0]['user'];
      setState(() {
        post = postsBody;
        singlePostLikes = postLikes;
        user = userData;
      });
    } on Exception catch (error) {
      print(error.toString());
    }
    gettingSinglePostLikes(singlePostLikes);
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

  late UserProfileBloc userProfileBloc;

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
        child: Column(
          children: [
            imagecarousel,
            SizedBox(
              height: 30.0,
            ),
            Text(
              "There's no posts yet",
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
                      gettingPosts();
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

  @override
  void initState() {
    super.initState();
    checkConnection();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    gettingUserId();

    if (posts.isEmpty) {
      Future.delayed(Duration(seconds: 5));
      gettingPosts();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          nextPageUrl != null &&
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
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (shrinked == false) {
          setState(() {
            shrinked = true;
          });
        }
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
          setState(() {
            visible = false;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          _scrollController.position.pixels <
              _scrollController.position.maxScrollExtent) {
        setState(() {
          visible = true;
        });
        if (_scrollController.position.pixels <=
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

  final _snackBar = SnackBar(
    content: Text(
      "Post Added successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final _editPostsnackBar = SnackBar(
    content: Text(
      "Post Edited successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final deletePostSuccessSnackBar = SnackBar(
    content: Text(
      "Post deleted successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final deletePostErrorSnackBar = SnackBar(
    content: Text(
      "Failed to delete post",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final sharePostSuccessSnackBar = SnackBar(
    content: Text(
      "Post shared successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final sharePostErrorSnackBar = SnackBar(
    content: Text(
      "Failed to share post",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editEmailSuccessSnackBar = SnackBar(
    content: Text(
      "Email updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editNameSuccessSnackBar = SnackBar(
    content: Text(
      "Name updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editPhoneSuccessSnackBar = SnackBar(
    content: Text(
      "Phone updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editPictureSuccessSnackBar = SnackBar(
    content: Text(
      "Profile picture updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final addCommentSuccessSnackBar = SnackBar(
    content: Text(
      "Comment posted successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final addCommentErrorSnackBar = SnackBar(
    content: Text(
      "Failed to post comment",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final deleteCommentSuccessSnackBar = SnackBar(
    content: Text(
      "Comment deleted successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final deleteCommentErrorSnackBar = SnackBar(
    content: Text(
      "Failed to delete comment",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editCommentSuccessSnackBar = SnackBar(
    content: Text(
      "Comment updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editCommentErrorSnackBar = SnackBar(
    content: Text(
      "Failed to update comment",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final addReplySuccessSnackBar = SnackBar(
    content: Text(
      "Reply posted successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final addReplyErrorSnackBar = SnackBar(
    content: Text(
      "Failed to post reply",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      body: hasConnection
          ? BlocListener<UserProfileBloc, UserProfileState>(
              listener: (context, state) {
                if (state is AddPostSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                } else if (state is EditPostSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(_editPostsnackBar);
                } else if (state is DeletePostSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(deletePostSuccessSnackBar);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                } else if (state is DeletePostErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(deletePostErrorSnackBar);
                } else if (state is SharePostSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(sharePostSuccessSnackBar);
                } else if (state is SharePostErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(sharePostErrorSnackBar);
                } else if (state is UpdateEmailSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(editEmailSuccessSnackBar);
                } else if (state is UpdateNameSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(editNameSuccessSnackBar);
                } else if (state is UpdatePhoneSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(editPhoneSuccessSnackBar);
                } else if (state is UpdatePictureSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(editPictureSuccessSnackBar);
                } else if (state is AddCommentSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(addCommentSuccessSnackBar);
                } else if (state is AddCommentErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(addCommentErrorSnackBar);
                } else if (state is DeleteCommentSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(deleteCommentSuccessSnackBar);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                } else if (state is DeleteCommentErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(deleteCommentErrorSnackBar);
                } else if (state is EditCommentSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(editCommentSuccessSnackBar);
                } else if (state is EditCommentSuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(editCommentErrorSnackBar);
                } else if (state is AddReplySuccessState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(addReplySuccessSnackBar);
                } else if (state is AddReplyErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(addReplyErrorSnackBar);
                }
              },
              child: RefreshIndicator(
                backgroundColor: KSubPrimaryColor,
                color: KPrimaryColor,
                strokeWidth: 3.0,
                child: posts.isNotEmpty
                    ? LayoutBuilder(
                        builder: (context, size) => Stack(
                          children: [
                            ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  index == 5
                                      ? imagecarousel
                                      : index == 10
                                          ? Container(
                                              height: 120.0,
                                              margin: EdgeInsets.only(
                                                right: 10.0,
                                                left: 10.0,
                                              ),
                                              child: Image.asset(
                                                "assets/images/ad_image_1.png",
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Card(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              elevation: 2.0,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 8.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () => {
                                                        if (userId ==
                                                            posts[index]
                                                                ['user_id'])
                                                          {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/Profile'),
                                                          }
                                                        else
                                                          {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OtherUsersProfile(
                                                                  userID: posts[
                                                                          index]
                                                                      [
                                                                      'user_id'],
                                                                ),
                                                              ),
                                                            ),
                                                          }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          posts[index]['user'][
                                                                      'image'] !=
                                                                  null
                                                              ? CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          'http://164.160.104.125:9090/fntat/${posts[index]['user']['image']}'),
                                                                  radius: 30.0,
                                                                )
                                                              : CircleAvatar(
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          noUserImage),
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
                                                                  '${posts[index]['user']['name']}',
                                                                  style:
                                                                      KNameStyle,
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
                                                                        posts[index]['updated_at']
                                                                            .toString()
                                                                            .substring(11,
                                                                                13)
                                                                            .contains(
                                                                                '07') ||
                                                                        posts[index]['updated_at']
                                                                            .toString()
                                                                            .substring(11, 13)
                                                                            .contains('08') ||
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
                                                                                style: KPostTimeStyle,
                                                                              )
                                                                            : posts[index]['updated_at'].toString().substring(11, 13).contains('14')
                                                                                ? Text(
                                                                                    '2:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                    style: KPostTimeStyle,
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
                                                                                                                            '12:${posts[index]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                                            style: KPostTimeStyle,
                                                                                                                          )
                                                                                                                        : Text(''),
                                                              ],
                                                            ),
                                                          ),
                                                          userId ==
                                                                  posts[index][
                                                                      'user_id']
                                                              ? PopupMenuButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .more_vert,
                                                                    size: 25.0,
                                                                  ),
                                                                  onSelected:
                                                                      (e) => {
                                                                    postOptions(
                                                                      e
                                                                          .toString()
                                                                          .substring(
                                                                              0,
                                                                              9),
                                                                      posts[index]
                                                                          [
                                                                          'id'],
                                                                    ),
                                                                  },
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return options
                                                                        .map(
                                                                            (choice) {
                                                                      return PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            choice,
                                                                        child:
                                                                            Text(
                                                                          choice,
                                                                          style:
                                                                              KPostOptionsStyle,
                                                                        ),
                                                                      );
                                                                    }).toList();
                                                                  },
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color:
                                                          KSubSecondryFontsColor,
                                                      thickness: 0.5,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        var connectivityResult =
                                                            await (Connectivity()
                                                                .checkConnectivity());
                                                        if (connectivityResult ==
                                                            ConnectivityResult
                                                                .none) {
                                                          Warning()
                                                              .errorMessage(
                                                            context,
                                                            title:
                                                                "No internet connection !",
                                                            message:
                                                                "Pleas turn on wifi or mobile data",
                                                            icons: Icons
                                                                .signal_wifi_off,
                                                          );
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PostDetailsScreen(
                                                                postID:
                                                                    posts[index]
                                                                        ['id'],
                                                                likeState: userLikes[
                                                                        index][
                                                                    'likeState'],
                                                                likeID: userLikes[
                                                                        index]
                                                                    ['likeID'],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  '${posts[index]['post']}',
                                                                  style:
                                                                      KPostStyle,
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
                                                    posts[index][
                                                                'image_flag'] ==
                                                            1
                                                        ? Container(
                                                            width:
                                                                double.infinity,
                                                            child: displayPostImage(
                                                                posts[index][
                                                                        'images']
                                                                    [
                                                                    0]['image']),
                                                          )
                                                        : SizedBox(
                                                            height: 5.0,
                                                          ),
                                                    posts[index][
                                                                'post_shared_id'] !=
                                                            null
                                                        ? displayPost(
                                                            posts[index][
                                                                'post_shared_id'],
                                                          )
                                                        : Container(),
                                                    Divider(
                                                      color:
                                                          KSubSecondryFontsColor,
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
                                                                  InkWell(
                                                                    onTap: () async {
                                                        var connectivityResult =
                                                            await (Connectivity()
                                                                .checkConnectivity());
                                                        if (connectivityResult ==
                                                            ConnectivityResult
                                                                .none) {
                                                          Warning()
                                                              .errorMessage(
                                                            context,
                                                            title:
                                                                "No internet connection !",
                                                            message:
                                                                "Pleas turn on wifi or mobile data",
                                                            icons: Icons
                                                                .signal_wifi_off,
                                                          );
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PostDetailsScreen(
                                                                postID:
                                                                    posts[index]
                                                                        ['id'],
                                                                likeState: userLikes[
                                                                        index][
                                                                    'likeState'],
                                                                likeID: userLikes[
                                                                        index]
                                                                    ['likeID'],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                                    child:  
                                                                      Text(
                                                                        '${posts[index]['comments_count'] ?? "0"} Comments',
                                                                        style:
                                                                            KLikesCommentsAndSharesCount,
                                                                      ),
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
                                                      color:
                                                          KSubSecondryFontsColor,
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
                                                                    Icons
                                                                        .favorite,
                                                                    color:
                                                                        KWarningColor,
                                                                  ),
                                                                  iconSize:
                                                                      21.0,
                                                                  onPressed:
                                                                      () {
                                                                    unLike(
                                                                        posts[index]
                                                                            [
                                                                            'id'],
                                                                        userLikes[index]
                                                                            [
                                                                            'likeID']);
                                                                    setState(
                                                                        () {
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
                                                                  iconSize:
                                                                      20.0,
                                                                  onPressed:
                                                                      () {
                                                                    like(posts[
                                                                            index]
                                                                        ['id']);
                                                                    setState(
                                                                        () {
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
                                                                    postID: posts[
                                                                            index]
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
                                                                    postID: posts[
                                                                            index]
                                                                        ['id'],
                                                                    userID: posts[
                                                                            index]
                                                                        [
                                                                        'user_id'],
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
                onRefresh: gettingPosts,
              ),
            )
          : internetConnection(),
      floatingActionButton: shrinked
          ? Visibility(
              visible: visible,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/AddPost');
                },
                child: Icon(
                  Icons.add,
                  color: KPrimaryFontsColor,
                  size: 30.0,
                ),
                backgroundColor: KPrimaryColor,
              ),
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

  like(int postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
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
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
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

  String e = "Edit post,Delete post";
  List<String> options = ['Edit post', 'Delete post'];

  postOptions(String option, var postID) {
    if (option == options[0]) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPost(
            postID: postID,
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: KPrimaryFontsColor,
              elevation: 1.0,
              title: Text(
                "Delete Post",
                style: TextStyle(
                  color: KSubPrimaryFontsColor,
                  fontFamily: KPrimaryFontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0,
                  height: 1.3,
                ),
              ),
              content: Text(
                "Are you sure? deleting post will remove this post from your posts",
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
                    userProfileBloc
                        .add(DeletePostButtonPressed(postID: postID));
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
