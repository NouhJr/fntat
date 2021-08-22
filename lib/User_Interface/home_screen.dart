import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/postsFeed_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Blocs/States/postsFeed_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Data/userProfile_data.dart';
import 'package:fntat/Data/authentication_data.dart';
import 'package:fntat/Data/search_data.dart';
import 'package:fntat/Data/postsFeed_data.dart';
import 'package:fntat/User_Interface/account_screen.dart';
import 'package:fntat/User_Interface/settings_screen.dart';
import 'package:fntat/User_Interface/search_screen.dart';
import 'package:fntat/User_Interface/notifications_screen.dart';
import 'package:fntat/User_Interface/messages_screen.dart';
// import 'package:fntat/User_Interface/newsFeed_screen.dart';
import 'package:fntat/User_Interface/editPhone_screen.dart';
import 'package:fntat/User_Interface/editName_screen.dart';
import 'package:fntat/User_Interface/editEmail_screen.dart';
import 'package:fntat/User_Interface/editProfilePicture_screen.dart';
import 'package:fntat/User_Interface/changePassword_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/User_Interface/addPost_screen.dart';
import 'package:fntat/User_Interface/addComment_screen.dart';
import 'package:fntat/User_Interface/followers_screen.dart';
import 'package:fntat/User_Interface/following_screen.dart';
import 'package:fntat/User_Interface/postDetails_screen.dart';
import 'package:fntat/User_Interface/chat_screen.dart';
import 'package:fntat/User_Interface/editPost_screen.dart';
import 'package:fntat/User_Interface/sharePost_screen.dart';
// import 'package:fntat/User_Interface/category_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';
import 'package:fntat/main.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(InitialState(), AuthApi())),
        BlocProvider(
            create: (context) =>
                UserProfileBloc(UserProfileInitialState(), UserProfileApi())),
        BlocProvider(
            create: (context) =>
                PostsFeedBloc(PostsFeedInitialState(), PostsData())),
      ],
      child: MaterialApp(
        routes: {
          '/HomeScreen': (context) => HomeScreen(),
          '/Profile': (context) => Account(),
          '/Initial': (context) => Initial(),
          '/Search': (context) => Search(),
          '/Notifications': (context) => Notifications(),
          '/Messages': (context) => Messages(),
          '/EditPhone': (context) => EditPhone(),
          '/EditName': (context) => EditName(),
          '/EditEmail': (context) => EditEmail(),
          '/EditPicture': (context) => EditProfilePicture(),
          '/ChangePassword': (context) => ChangePassword(),
          '/Others': (context) => OtherUsersProfile(),
          '/AddPost': (context) => AddPost(),
          '/MyFollowers': (context) => FollowersScreen(),
          '/MyFollowing': (context) => FollowingScreen(),
        },
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final toNotifications;
  final toMessages;
  HomeScreen({this.toNotifications, this.toMessages});
  @override
  _HomeScreenState createState() => _HomeScreenState(
      toNotifications: toNotifications, toMessages: toMessages);
}

class _HomeScreenState extends State<HomeScreen> {
  final toNotifications;
  final toMessages;
  _HomeScreenState({this.toNotifications, this.toMessages});

  ///***************************************VARIABLES************************************************/
  TextEditingController postTextController = TextEditingController();
  final ScrollController messagesScrollController = ScrollController();
  final ScrollController postsScrollController = ScrollController();
  bool useAsset = true;
  bool isHome = true;
  bool isSearch = false;
  bool isPost = false;
  bool isNotifications = false;
  bool isMessages = false;
  bool footballFilter = false;
  bool basketballFilter = false;
  bool connectionShowLoading = true;
  bool categoryShowLoading = true;
  bool notificationsShowLoading = true;
  bool messagesShowLoading = true;
  bool postsFeedShowLoading = true;
  bool singlePostShowLoading = true;
  bool moreMessagesLoading = false;
  bool morePostsLoading = false;
  bool hasConnection = false;
  bool postHasImage = false;
  bool singlePostLikeState = false;
  String userName = 'User Name';
  String userImage = "assets/images/nouserimagehandler.jpg";
  String otherUsersImage = "assets/images/nouserimagehandler.jpg";
  String noPostImage = "assets/images/nopostimagehandler.jpg";
  String noUserImage = "assets/images/nouserimagehandler.jpg";
  String e = "Edit post,Delete post";
  List<String> options = ['Edit post', 'Delete post'];
  List<dynamic> categoryResults = [];
  List<dynamic> notificationsResults = [];
  List<dynamic> messagesResults = [];
  List<dynamic> posts = [];
  List<dynamic> userLikes = [];
  List<dynamic> tempLikesBody = [];
  List<dynamic> post = [];
  List<dynamic> singlePostLikes = [];
  List<dynamic> singlePostTempLikes = [];
  File? postImage;
  var notificationsNextPageUrl;
  var messagessNextPageUrl;
  var postsNextPageUrl;
  var userID;
  var singlePostLikeID;
  var user;
  var dio = Dio();
  late UserProfileBloc userProfileBloc;

  ///******************************************************************************************************/

  ///**********************************************SNACKBARS********************************************************/
  final snackBar = SnackBar(
    content: Text(
      "Post Added successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editPostsnackBar = SnackBar(
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

  ///******************************************************************************************************/

  @override
  void initState() {
    if (toNotifications == true) {
      setState(() {
        isNotifications = true;
        isHome = false;
        isSearch = false;
        isPost = false;
        isMessages = false;
      });
    } else if (toMessages == true) {
      setState(() {
        isMessages = true;
        isHome = false;
        isSearch = false;
        isPost = false;
        isNotifications = false;
      });
    }
    checkConnection();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
    gettingCurrentUserID();
    gettingPosts();

    ///**************************MESSAGES PAGINATION****************************/
    messagesScrollController.addListener(() {
      if (messagesScrollController.position.pixels >=
              messagesScrollController.position.maxScrollExtent &&
          messagesResults.isNotEmpty) {
        setState(() {
          moreMessagesLoading = true;
        });
        gettingMoreMessages();
      } else if (messagesScrollController.position.pixels <=
          messagesScrollController.position.maxScrollExtent) {
        setState(() {
          moreMessagesLoading = false;
        });
      }
    });

    ///*************************************************************************/

    ///**************************POSTS PAGINATION****************************/
    postsScrollController.addListener(() {
      if (postsScrollController.position.pixels >=
              postsScrollController.position.maxScrollExtent &&
          posts.isNotEmpty) {
        setState(() {
          morePostsLoading = true;
        });
        getMorePosts();
      } else if (postsScrollController.position.pixels <=
          postsScrollController.position.maxScrollExtent) {
        setState(() {
          morePostsLoading = false;
        });
      }
    });

    ///*************************************************************************/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: hasConnection
          ? BlocListener<UserProfileBloc, UserProfileState>(
              listener: (context, state) {
                if (state is GettingUserProfileDataSuccessState) {
                  setState(() {
                    userName = state.name;
                    useAsset = false;
                    userImage = '$ImageServerPrefix/${state.image}';
                  });
                } else if (state is AddPostSuccessState) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (state is EditPostSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(editPostsnackBar);
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
              child: Stack(
                children: [
                  Container(
                    color: KHeaderColor,
                  ),
                  Positioned(
                    top: 20.0,
                    left: 20.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Account(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          useAsset
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(userImage),
                                  radius: 30.0,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(userImage),
                                  radius: 30.0,
                                ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            userName,
                            style: KNameInHeaderStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25.0,
                    right: 10.0,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isNotifications = true;
                              isHome = false;
                              isSearch = false;
                              isPost = false;
                              isMessages = false;
                            });
                            gettingNotification();
                          },
                          icon: Icon(
                            Icons.notifications,
                            color: KSubPrimaryColor,
                            size: 25.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isNotifications = false;
                              isHome = false;
                              isSearch = false;
                              isPost = false;
                              isMessages = true;
                            });
                            gettingMessages();
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
                                builder: (context) =>
                                    Settings(fromAccount: false),
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
                  ),
                  Positioned(
                    top: 200.0,
                    right: 0.0,
                    left: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      height: screenSize.height - 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                        color: KSubPrimaryColor,
                      ),
                      child: isPost
                          ? addPost()
                          : isSearch
                              ? search()
                              : isNotifications
                                  ? notifications()
                                  : isMessages
                                      ? messages()
                                      : isHome
                                          ? postsFeed()
                                          : null,
                    ),
                  ),
                  Positioned(
                    top: 150.0,
                    right: 40.0,
                    left: 100.0,
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: isSearch ? 100.0 : 80.0,
                          width: isSearch ? 80.0 : 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: KPrimaryColor,
                            ),
                            color: KSubPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isSearch = true;
                                isHome = false;
                                isPost = false;
                                isNotifications = false;
                                isMessages = false;
                              });
                            },
                            icon: Icon(
                              Icons.search,
                              color: isSearch
                                  ? KPrimaryColor
                                  : KSubSecondryFontsColor,
                              size: isSearch ? 40.0 : 30.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: isHome ? 100.0 : 80.0,
                          width: isHome ? 80.0 : 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: KPrimaryColor,
                            ),
                            color: KSubPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isHome = true;
                                isSearch = false;
                                isPost = false;
                                isNotifications = false;
                                isMessages = false;
                              });
                            },
                            icon: Icon(
                              Icons.home,
                              color: isHome
                                  ? KPrimaryColor
                                  : KSubSecondryFontsColor,
                              size: isHome ? 40.0 : 30.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: isPost ? 100.0 : 80.0,
                          width: isPost ? 80.0 : 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: KPrimaryColor,
                            ),
                            color: KSubPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isPost = true;
                                isHome = false;
                                isSearch = false;
                                isNotifications = false;
                                isMessages = false;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: isPost
                                  ? KPrimaryColor
                                  : KSubSecondryFontsColor,
                              size: isPost ? 40.0 : 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : internetConnection(),
      bottomSheet: isPost
          ? Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 45.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KPrimaryColor,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: KSubPrimaryColor,
                        size: 25.0,
                      ),
                      onPressed: takeImage,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: 45.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KPrimaryColor,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        color: KSubPrimaryColor,
                        size: 25.0,
                      ),
                      onPressed: chooseImage,
                    ),
                  ),
                  SizedBox(
                    width: 190.0,
                  ),
                  Row(
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
                          color: KPrimaryColor,
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              addPostButton();
                            },
                            child: Text(
                              "Post",
                              style: KSubPrimaryButtonsFontStyle2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }

  ///****************************************************************************************************/

  ///***************************************SEARCH UI*************************************************************/
  search() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 35.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              showSearch(context: context, delegate: SearchBar());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Search Fntat",
                  style: KSearchLabelStyle,
                ),
                SizedBox(
                  width: 40.0,
                ),
                Icon(
                  Icons.search,
                  size: 30.0,
                  color: KPrimaryColor,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 130.0,
                height: 35.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: KPrimaryColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  color: footballFilter ? KPrimaryColor : null,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      basketballFilter = false;
                      footballFilter = !footballFilter;
                    });
                    if (footballFilter == true) {
                      gettingCategory();
                      setState(() {
                        categoryShowLoading = true;
                      });
                    } else {
                      categoryResults.clear();
                      setState(() {
                        categoryShowLoading = true;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.sports_soccer,
                        color:
                            footballFilter ? KSubPrimaryColor : KPrimaryColor,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Football",
                        style: footballFilter
                            ? KSubPrimaryButtonsFontStyle2
                            : KSubPrimaryButtonsFontStyle,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 140.0,
                height: 35.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: KPrimaryColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  color: basketballFilter ? KPrimaryColor : null,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      footballFilter = false;
                      basketballFilter = !basketballFilter;
                    });
                    if (basketballFilter == true) {
                      gettingCategory();
                      setState(() {
                        categoryShowLoading = true;
                      });
                    } else {
                      categoryResults.clear();
                      setState(() {
                        categoryShowLoading = true;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.sports_basketball,
                        color:
                            basketballFilter ? KSubPrimaryColor : KPrimaryColor,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Basketball",
                        style: basketballFilter
                            ? KSubPrimaryButtonsFontStyle2
                            : KSubPrimaryButtonsFontStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        footballFilter
            ? categoryResults.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                          leading: categoryResults[index]['user']['image'] !=
                                  null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '$ImageServerPrefix/${categoryResults[index]['user']['image']}'),
                                  radius: 30.0,
                                )
                              : CircleAvatar(
                                  backgroundImage: AssetImage(otherUsersImage),
                                  radius: 30.0,
                                ),
                          title: Text(
                            '${categoryResults[index]['user']['name']}',
                            style: KNameStyle,
                          ),
                          subtitle: Text(
                            '${categoryResults[index]['user']['email']}',
                            style: KUserEmailStyle,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: categoryResults[index]['user']['id'] ==
                                        userID
                                    ? (context) => Account()
                                    : (context) => OtherUsersProfile(
                                          userID: categoryResults[index]['user']
                                              ['id'],
                                        ),
                              ),
                            );
                          },
                        ),
                    separatorBuilder: (context, index) => Divider(
                          color: KSubSecondryFontsColor,
                          thickness: 0.5,
                        ),
                    itemCount: categoryResults.length)
                : categoryStateIndicator()
            : basketballFilter
                ? categoryResults.isNotEmpty
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                              leading: categoryResults[index]['user']
                                          ['image'] !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          '$ImageServerPrefix/${categoryResults[index]['user']['image']}'),
                                      radius: 30.0,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          AssetImage(otherUsersImage),
                                      radius: 30.0,
                                    ),
                              title: Text(
                                '${categoryResults[index]['user']['name']}',
                                style: KNameStyle,
                              ),
                              subtitle: Text(
                                '${categoryResults[index]['user']['email']}',
                                style: KUserEmailStyle,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: categoryResults[index]['user']
                                                ['id'] ==
                                            userID
                                        ? (context) => Account()
                                        : (context) => OtherUsersProfile(
                                              userID: categoryResults[index]
                                                  ['user']['id'],
                                            ),
                                  ),
                                );
                              },
                            ),
                        separatorBuilder: (context, index) => Divider(
                              color: KSubSecondryFontsColor,
                              thickness: 0.5,
                            ),
                        itemCount: categoryResults.length)
                    : categoryStateIndicator()
                : Container(),
      ],
    );
  }

  ///***************************************ADDPOST UI*************************************************************/
  addPost() {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: 10.0,
              ),
              postTextField(postTextController, "Write a new post..."),
              SizedBox(
                height: 40.0,
              ),
              postHasImage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              width: 350.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                image: DecorationImage(
                                  image: FileImage(postImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    postHasImage = false;
                                    postImage = null;
                                  });
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  size: 25.0,
                                  color: KWarningColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  ///***************************************HOME UI*************************************************************/
  postsFeed() {
    return RefreshIndicator(
      backgroundColor: KSubPrimaryColor,
      color: KPrimaryColor,
      strokeWidth: 3.0,
      child: posts.isNotEmpty
          ? LayoutBuilder(
              builder: (context, size) => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: KSubSecondryFontsColor,
                        thickness: 0.5,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      controller: postsScrollController,
                      shrinkWrap: true,
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
                                  InkWell(
                                    onTap: () => {
                                      if (userID == posts[index]['user_id'])
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
                                                    '$ImageServerPrefix/${posts[index]['user']['image']}'),
                                                radius: 25.0,
                                              )
                                            : CircleAvatar(
                                                backgroundImage:
                                                    AssetImage(noUserImage),
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
                                                '${posts[index]['user']['name']}',
                                                style: KNameStyle,
                                              ),
                                              SizedBox(
                                                height: 10.0,
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
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${posts[index]['post']}',
                                                        style: KPostStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        userID == posts[index]['user_id']
                                            ? PopupMenuButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  size: 25.0,
                                                ),
                                                onSelected: (e) => {
                                                  postOptions(
                                                    e
                                                        .toString()
                                                        .substring(0, 9),
                                                    posts[index]['id'],
                                                  ),
                                                },
                                                itemBuilder: (context) {
                                                  return options.map((choice) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: choice,
                                                      child: Text(
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
                                          onPressed: () async {
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
                                                icons: Icons.signal_wifi_off,
                                              );
                                            } else {
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
                                            }
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
                  ),
                  if (morePostsLoading) ...[
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
          : homeStateIndicator(),
      onRefresh: gettingPosts,
    );
  }

  ///***************************************NOTIFICATIONS UI*************************************************************/
  notifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.0,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Notifications",
              style: KNameStyle,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        notificationsResults.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    '${notificationsResults[index]['title']}',
                    style: KNameStyle,
                  ),
                  subtitle: Text(
                    '${notificationsResults[index]['body']}',
                    style: KPostStyle,
                  ),
                  onTap: notificationsResults[index]['post_id'] != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailsScreen(
                                postID: notificationsResults[index]['post_id'],
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
                itemCount: notificationsResults.length,
              )
            : notificationStateIndicator(),
      ],
    );
  }

  ///***************************************MESSAGES UI*************************************************************/
  messages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.0,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Messages",
              style: KNameStyle,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        messagesResults.isNotEmpty
            ? LayoutBuilder(
                builder: (context, size) => Stack(
                  children: [
                    ListView.separated(
                      controller: messagesScrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListTile(
                        leading: messagesResults[index]['image'] != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '$ImageServerPrefix/${messagesResults[index]['image']}'),
                                radius: 25.0,
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(otherUsersImage),
                                radius: 25.0,
                              ),
                        title: Text(
                          '${messagesResults[index]['name']}',
                          style: KNameStyle,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  receiverID: messagesResults[index]['id']),
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) => Divider(
                        color: KSubSecondryFontsColor,
                        thickness: 0.5,
                      ),
                      itemCount: messagesResults.length,
                    ),
                    if (moreMessagesLoading) ...[
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
            : messagesStateIndicator(),
      ],
    );
  }

  ///****************************************************************************************************/

  ///***************************************GENERAL LOGIC*************************************************************/
  gettingCurrentUserID() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    setState(() {
      userID = id!;
    });
  }

  internetConnection() {
    if (connectionShowLoading) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (this.mounted) {
          setState(() {
            connectionShowLoading = false;
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
              height: 150.0,
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

  ///***************************************SEARCH LOGIC*************************************************************/
  categoryStateIndicator() {
    if (categoryShowLoading) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            categoryShowLoading = false;
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

  gettingCategory() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(footballFilter
          ? '$ServerUrl/users-same-category?category_id=1'
          : '$ServerUrl/users-same-category?category_id=2');
      final List<dynamic> resBody = res.data['data']['data'];
      // final nextPage = res.data['data']['next_page_url'];
      setState(() {
        categoryResults = resBody;
        // nextPageUrl = nextPage;
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  ///***************************************ADDPOST LOGIC*************************************************************/
  Future chooseImage() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      postImage = File(pickedFile!.path);
      postHasImage = true;
    });
  }

  Future takeImage() async {
    final source = ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      postImage = File(pickedFile!.path);
      postHasImage = true;
    });
  }

  addPostButton() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (postTextController.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Post can't be empty !",
        message: 'Please type a post.',
        icons: Icons.warning,
      );
    } else if (postImage != null) {
      userProfileBloc.add(AddNewPostWithImageFired(
          post: postTextController.text, image: postImage));
      post.clear();
      setState(() {
        postHasImage = false;
        postImage = null;
      });
    } else {
      userProfileBloc
          .add(AddNewPostButtonPressed(post: postTextController.text));
      post.clear();
    }
  }

  ///***************************************NOTIFICATIONS LOGIC*************************************************************/
  notificationStateIndicator() {
    if (notificationsShowLoading) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            notificationsShowLoading = false;
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
          "There's no notifications yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  gettingNotification() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.get('$ServerUrl/my-notifications?user_id=$id');
      final List<dynamic> notificationsBody = res.data['data']['data'];
      final nextPageUrlBody = res.data['data']['next_page_url'];
      setState(() {
        notificationsResults = notificationsBody;
        notificationsNextPageUrl = nextPageUrlBody;
      });
    } on Exception catch (error) {
      print(error);
    }
  }

  ///***************************************MESSAGES LOGIC*************************************************************/
  messagesStateIndicator() {
    if (messagesShowLoading) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        if (this.mounted) {
          setState(() {
            messagesShowLoading = false;
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
          "There's no chats yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  gettingMessages() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.get('$ServerUrl/rooms');
      final List<dynamic> resBody = res.data['data']['data'];
      final nextPageBody = res.data['data']['next_page_url'];
      setState(() {
        messagesResults = resBody;
        messagessNextPageUrl = nextPageBody;
      });
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  gettingMoreMessages() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    if (messagessNextPageUrl != null) {
      try {
        final res = await dio.get(messagessNextPageUrl);
        final List<dynamic> resBody = res.data['data']['data'];
        final nextPageBody = res.data['data']['next_page_url'];
        setState(() {
          messagesResults.addAll(resBody);
          messagessNextPageUrl = nextPageBody;
        });
      } on Exception catch (error) {
        print(error.toString());
      }
    }
  }

  ///***************************************HOME LOGIC*************************************************************/
  homeStateIndicator() {
    if (postsFeedShowLoading) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            postsFeedShowLoading = false;
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
          "There's no posts yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  singlePostStateIndicator() {
    if (singlePostShowLoading) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            singlePostShowLoading = false;
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
      final res = await dio.post('$ServerUrl/home-page-posts', data: formData);
      final List<dynamic> postsBody = res.data['data']['data'];
      final nextPage = res.data['data']['next_page_url'];
      setState(() {
        posts = postsBody;
        postsNextPageUrl = nextPage;
      });
    } on Exception catch (error) {
      print(error.toString());
    }
    gettingLikes();
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
    if (postsNextPageUrl != null) {
      try {
        final res = await dio.post(postsNextPageUrl, data: formData);
        final postsBody = res.data['data']['data'];
        final nextPage = res.data['data']['next_page_url'];
        setState(() {
          posts.addAll(postsBody);
          postsNextPageUrl = nextPage;
        });
      } on Exception catch (error) {
        print(error.toString());
      }
      gettingLikes();
    }
  }

  gettingSharedPostData(var postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final postRes = await dio.post(
        '$ServerUrl/get-post-by-id?post_id=$postID',
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

  gettingLikes() {
    Future.delayed(Duration(seconds: 3));
    if (posts.isNotEmpty) {
      for (var i = 0; i < posts.length; i++) {
        if (userLikes.length < posts.length) {
          setState(() {
            userLikes.add({'id': userID, 'likeState': false, 'likeID': null});
          });
        }
        setState(() {
          tempLikesBody = posts[i]['like'];
        });
        if (tempLikesBody.isNotEmpty) {
          for (var j = 0; j < tempLikesBody.length; j++) {
            if (userID == tempLikesBody[j]['user_id']) {
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

  gettingSinglePostLikes(List<dynamic> likes) {
    if (likes.isNotEmpty) {
      for (var i = 0; i < likes.length; i++) {
        if (userID == likes[i]['user_id']) {
          setState(() {
            singlePostLikeState = true;
            singlePostLikeID = likes[i]['id'];
          });
        }
      }
    }
  }

  displayPost(var postID) {
    gettingSharedPostData(postID);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0.0,
      child: post.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      userID != user['id']
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

  ///***************************************DISPOSE*************************************************************/
  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
    messagesScrollController.dispose();
    postsScrollController.dispose();
  }
}
