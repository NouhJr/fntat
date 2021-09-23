import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:fntat/User_Interface/editPost_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/User_Interface/postDetails_screen.dart';
import 'package:fntat/User_Interface/sharePost_screen.dart';
import 'package:fntat/User_Interface/settings_screen.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final ScrollController _scrollController = ScrollController();
  String noPostImage = "assets/images/nopostimagehandler.jpg";
  String noUserImage = "assets/images/nouserimagehandler.jpg";
  bool useAsset = true;
  bool loading = false;
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

  Future gettingUserOwnedPosts() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post('$ServerUrl/user-owned-posts', data: formData);
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
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
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
    FormData formData = FormData.fromMap({
      "post_id": postID,
    });
    try {
      await dio.post('$ServerUrl/add-like', data: formData);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  unLike(int postID, int likeID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    FormData formData = FormData.fromMap({
      "post_id": postID,
      "like_id": likeID,
    });
    try {
      await dio.post('$ServerUrl/delete-like', data: formData);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  displayPostImage(String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 280.0,
          height: 180.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
              image: NetworkImage('$ImageServerPrefix/$image'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  late UserProfileBloc userProfileBloc;

  Future getDataOnRefresh() async {
    userProfileBloc.add(GettingUserProfileData());
    gettingUserOwnedPosts();
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
      return Column(
        children: [
          SizedBox(
            height: 150.0,
          ),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: KSubPrimaryColor,
              color: KPrimaryColor,
              strokeWidth: 5.0,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 150.0,
          ),
          Center(
            child: Text(
              "There's no posts for this account yet",
              style: KErrorStyle,
            ),
          ),
        ],
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
                      getDataOnRefresh();
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
    FormData postFormData = FormData.fromMap({
      "post_id": postID,
    });
    try {
      final postRes = await dio.post(
          '$ServerUrl/get-post-by-id?post_id=$postID',
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
      elevation: 0.0,
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
                                  '$ImageServerPrefix/${user['image']}',
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
                              SizedBox(
                                height: 10.0,
                              ),
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
                        ),
                      ],
                    ),
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

  String age(String date) {
    var parseToDate = DateTime.parse(date);
    var age = DateTime.now().year - parseToDate.year;
    return age.toString();
  }

  var userName = '';
  var userEmail = '';
  var userPhone = '';
  var userImage = "assets/images/nouserimagehandler.jpg";
  var coverPhoto;
  var userType;
  var userCategory;
  var userLegOrHand;
  var userCountry;
  var userAge;
  var userHeight;
  var userWeight;
  var userMainPosition;
  var userOtherPosition;

  @override
  void initState() {
    super.initState();
    checkConnection();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
    gettingUserId();
    gettingUserOwnedPosts();
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
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KPrimaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: KSubPrimaryColor,
            size: 25.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      toNotifications: true,
                    ),
                  ),
                  (route) => false);
            },
            icon: Icon(
              Icons.notifications,
              color: KSubPrimaryColor,
              size: 25.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      toMessages: true,
                    ),
                  ),
                  (route) => false);
            },
            icon: Icon(
              Icons.email,
              color: KSubPrimaryColor,
              size: 25.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(fromAccount: true),
                ),
              );
            },
            icon: Icon(
              Icons.settings,
              color: KSubPrimaryColor,
              size: 25.0,
            ),
          ),
        ],
      ),
      body: hasConnection
          ? BlocListener<UserProfileBloc, UserProfileState>(
              listener: (context, state) {
                if (state is GettingUserProfileDataSuccessState) {
                  setState(() {
                    userName = state.name;
                    userEmail = state.email;
                    userPhone = state.phone;
                    userType = state.type;
                    userCategory = state.category;
                    userCountry = state.country;
                    userLegOrHand = state.legOrHand;
                    userAge = age(state.birthDate ?? DateTime.now().toString());
                    userHeight = state.height;
                    userWeight = state.weight;
                    userMainPosition = state.mainPosition;
                    userOtherPosition = state.otherPosition;
                  });
                  if (state.image != null && state.coverPhoto != null) {
                    setState(() {
                      userImage = '$ImageServerPrefix/${state.image}';
                      coverPhoto = '$ImageServerPrefix/${state.coverPhoto}';
                      useAsset = false;
                    });
                  }
                }
              },
              child: Stack(
                children: [
                  coverPhoto != null
                      ? Positioned(
                          top: 0.0,
                          child: Container(
                            width: screenSize.width,
                            height: 145.0,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: NetworkImage(coverPhoto),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: KPrimaryColor,
                        ),
                  Positioned(
                    top: 120.0,
                    right: 0.0,
                    left: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      height: screenSize.height - 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                        color: KSubPrimaryColor,
                      ),
                      child: account(),
                    ),
                  ),
                  Positioned(
                    top: 20.0,
                    left: 0.0,
                    child: ProfileCard(
                      image: userImage,
                      name: userName,
                      useAsset: useAsset,
                      category: userCategory,
                      type: userType,
                      countryName: userCountry,
                      legOrHand: userLegOrHand,
                      age: userAge ?? '0',
                      height: userHeight ?? '0',
                      weight: userWeight ?? '0',
                      mainPosition: userMainPosition ?? '',
                      otherPosition: userOtherPosition ?? '',
                    ),
                  ),
                  Positioned(
                    top: 130.0,
                    left: 210.0,
                    child: Container(
                      child: Container(
                        width: 140.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: KPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    toCategories: true,
                                  ),
                                ),
                                (route) => false);
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.groups,
                                color: KPrimaryColor,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Categories",
                                style: KSubPrimaryButtonsFontStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : internetConnection(),
    );
  }

  account() {
    return ListView(
      controller: _scrollController,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 120.0,
        ),
        posts.isNotEmpty
            ? LayoutBuilder(
                builder: (context, size) => Stack(
                  children: [
                    ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: KSubSecondryFontsColor,
                        indent: 20.0,
                        endIndent: 20.0,
                        thickness: 0.5,
                      ),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 0.0,
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
                                                  AssetImage(userImage),
                                              radius: 30.0,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(userImage),
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
                                              userName,
                                              style: KNameStyle,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            InkWell(
                                              onTap: () {
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
                                                      likeID: userLikes[index]
                                                          ['likeID'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
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
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          size: 25.0,
                                        ),
                                        onSelected: (e) => {
                                          postOptions(
                                            e.toString().substring(0, 9),
                                            posts[index]['id'],
                                          ),
                                        },
                                        itemBuilder: (context) {
                                          return options.map((choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(
                                                choice,
                                                style: KPostOptionsStyle,
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  posts[index]['image_flag'] == 1
                                      ? Container(
                                          width: double.infinity,
                                          child: displayPostImage(posts[index]
                                              ['images'][0]['image']),
                                        )
                                      : SizedBox(
                                          height: 5.0,
                                        ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  posts[index]['post_shared_id'] != null
                                      ? displayPost(
                                          posts[index]['post_shared_id'],
                                        )
                                      : Container(),
                                  Container(
                                    height: 25.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        userLikes[index]['likeState']
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: KWarningColor,
                                                ),
                                                iconSize: 17.0,
                                                onPressed: () {
                                                  unLike(
                                                      posts[index]['id'],
                                                      userLikes[index]
                                                          ['likeID']);
                                                  setState(() {
                                                    userLikes[index]
                                                        ['likeState'] = false;
                                                  });
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.heart,
                                                  color: KSubSecondryFontsColor,
                                                ),
                                                iconSize: 17.0,
                                                onPressed: () {
                                                  like(posts[index]['id']);
                                                  setState(() {
                                                    userLikes[index]
                                                        ['likeState'] = true;
                                                  });
                                                },
                                              ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.commentAlt,
                                          ),
                                          iconSize: 16.0,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetailsScreen(
                                                  postID: posts[index]['id'],
                                                  likeState: userLikes[index]
                                                      ['likeState'],
                                                  likeID: userLikes[index]
                                                      ['likeID'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.shareAlt,
                                          ),
                                          iconSize: 16.0,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SharePost(
                                                  postID: posts[index]['id'],
                                                  userID: posts[index]
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
    );
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
