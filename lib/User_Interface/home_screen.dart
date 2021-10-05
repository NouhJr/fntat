import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Data/userProfile_data.dart';
import 'package:fntat/Data/authentication_data.dart';
import 'package:fntat/Data/search_data.dart';
import 'package:fntat/User_Interface/account_screen.dart';
import 'package:fntat/User_Interface/settings_screen.dart';
import 'package:fntat/User_Interface/editPhone_screen.dart';
import 'package:fntat/User_Interface/editName_screen.dart';
import 'package:fntat/User_Interface/editEmail_screen.dart';
import 'package:fntat/User_Interface/editProfilePicture_screen.dart';
import 'package:fntat/User_Interface/changePassword_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/User_Interface/followers_screen.dart';
import 'package:fntat/User_Interface/following_screen.dart';
import 'package:fntat/User_Interface/postDetails_screen.dart';
import 'package:fntat/User_Interface/chat_screen.dart';
import 'package:fntat/User_Interface/editPost_screen.dart';
import 'package:fntat/User_Interface/sharePost_screen.dart';
import 'package:fntat/User_Interface/editBirthDate_screen.dart';
import 'package:fntat/User_Interface/editCoverPhoto_screen.dart';
import 'package:fntat/User_Interface/playVideo_screen.dart';
import 'package:fntat/User_Interface/playVideoWeb_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';
import 'package:fntat/Components/carousel.dart';
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
      ],
      child: MaterialApp(
        routes: {
          '/HomeScreen': (context) => HomeScreen(),
          '/Profile': (context) => Account(),
          '/Initial': (context) => Initial(),
          '/EditPhone': (context) => EditPhone(),
          '/EditName': (context) => EditName(),
          '/EditEmail': (context) => EditEmail(),
          '/EditPicture': (context) => EditProfilePicture(),
          '/EditCoverPhoto': (context) => EditCoverPhoto(),
          '/EditBirthDate': (context) => EditBirthDate(),
          '/ChangePassword': (context) => ChangePassword(),
          '/Others': (context) => OtherUsersProfile(),
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
  final toCategories;
  HomeScreen({this.toNotifications, this.toMessages, this.toCategories});
  @override
  _HomeScreenState createState() => _HomeScreenState(
        toNotifications: toNotifications,
        toMessages: toMessages,
        toCategories: toCategories,
      );
}

class _HomeScreenState extends State<HomeScreen> {
  final toNotifications;
  final toMessages;
  final toCategories;
  _HomeScreenState({this.toNotifications, this.toMessages, this.toCategories});

  ///***************************************VARIABLES************************************************/
  TextEditingController postTextController = TextEditingController();
  TextEditingController heightTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();
  final ScrollController messagesScrollController = ScrollController();
  final ScrollController postsScrollController = ScrollController();
  final ScrollController categoriesController = ScrollController();
  bool useAsset = true;
  bool isHome = true;
  bool isSearch = false;
  bool isPost = false;
  bool isCategory = false;
  bool isAddCard = false;
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
  bool moreCategoriesLoading = false;
  bool hasConnection = false;
  bool postHasImage = false;
  bool postHasImageWeb = false;
  bool singlePostLikeState = false;
  bool hasVideo = false;
  bool addPostImageLoadingForWeb = false;
  bool hasVideoWeb = false;
  String userName = "";
  String userImage = "assets/images/nouserimagehandler.jpg";
  String userCountry = "";
  String otherUsersImage = "assets/images/nouserimagehandler.jpg";
  String noPostImage = "assets/images/nopostimagehandler.jpg";
  String noUserImage = "assets/images/nouserimagehandler.jpg";
  String e = "Edit post,Delete post";
  String selectedCountry = "Select your country";
  String _selectedType = "Type";
  String _selectedCategory = "Category";
  String selectedFavotite = "Favotite Leg or Hand";
  String selectedMainFootballPosition = "Select football position";
  String selectedOtherFootballPosition = "Select other football position";
  String selectedMainBasketballPosition = "Select basketball position";
  String selectedOtherBasketballPosition = "Select other basketball position";
  String selectedSkillsVideo = "Add skills video";
  String mainPosition = '';
  String otherPosition = '';
  String postImageNameWeb = '';
  String videoNameWeb = '';
  int typeID = 0;
  int categoryID = 0;
  List<dynamic> categoryResults = [];
  List<dynamic> notificationsResults = [];
  List<dynamic> messagesResults = [];
  List<dynamic> posts = [];
  List<dynamic> userLikes = [];
  List<dynamic> tempLikesBody = [];
  List<dynamic> post = [];
  List<dynamic> singlePostLikes = [];
  List<dynamic> singlePostTempLikes = [];
  List<String> options = ['Edit post', 'Delete post'];
  List<String> _types = [
    'Type',
    'Admin',
    'Amateur',
    'Professional',
    'Agent',
    'Academy',
    'Club'
  ];
  List<String> _category = ['Category', 'Football', 'Basketball'];
  List<String> favorites = ['Favotite Leg or Hand', 'Right', 'Left'];
  List<String> footballPositions = [
    'Select football position',
    'Goalkeeper (GK)',
    'Right Fullback (RF)',
    'Left Fullback (LF)',
    'Center Back (CB)',
    'Defending Midfielder (DM)',
    'Right Winger (RW)',
    'Central Midfielder (CM)',
    'Striker (ST)',
    'Attacking Midfielder (AM)',
    'Left Wingers (LW)',
  ];
  List<String> otherFootballPositions = [
    'Select other football position',
    'Goalkeeper (GK)',
    'Right Fullback (RF)',
    'Left Fullback (LF)',
    'Center Back (CB)',
    'Defending Midfielder (DM)',
    'Right Winger (RW)',
    'Central Midfielder (CM)',
    'Striker (ST)',
    'Attacking Midfielder (AM)',
    'Left Wingers (LW)',
  ];
  List<String> basketballPositions = [
    'Select basketball position',
    'Center (CT)',
    'Power Forward (PF)',
    'Small Forward (SF)',
    'Point Guard (PG)',
    'Shooting Guard (SG)',
  ];
  List<String> otherBasketballPositions = [
    'Select other basketball position',
    'Center (CT)',
    'Power Forward (PF)',
    'Small Forward (SF)',
    'Point Guard (PG)',
    'Shooting Guard (SG)',
  ];
  List<String> skillsVideo = [
    'Add skills video',
    'Take video',
    'Choose existing video',
  ];
  late List<int> postImageWebBytes;
  late List<int> videoWebBytes;
  late Uint8List postImageWebBytesData;
  late Uint8List videoWebBytesData;
  File? postImage;
  File? userVideo;
  var notificationsNextPageUrl;
  var messagessNextPageUrl;
  var postsNextPageUrl;
  var categoriesNextPageUrl;
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

  final editBirthDateSuccessSnackBar = SnackBar(
    content: Text(
      "BirthDate updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editBirthDateErrorSnackBar = SnackBar(
    content: Text(
      "Failed to update birth date",
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

  final addCardSuccessSnackBar = SnackBar(
    content: Text(
      "Card created successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final addCardErrorSnackBar = SnackBar(
    content: Text(
      "Failed to add card",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editCoverSuccessSnackBar = SnackBar(
    content: Text(
      "Cover photo updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final editCoverErrorSnackBar = SnackBar(
    content: Text(
      "Failed to update cover photo",
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
      });
    } else if (toMessages == true) {
      setState(() {
        isMessages = true;
        isHome = false;
      });
    } else if (toCategories == true) {
      setState(() {
        isCategory = true;
        isHome = false;
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
          posts.isNotEmpty &&
          postsNextPageUrl != null) {
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

    ///**************************CATEGORIES PAGINATION****************************/
    categoriesController.addListener(() {
      if (categoriesController.position.pixels >=
              categoriesController.position.maxScrollExtent &&
          categoryResults.isNotEmpty &&
          categoriesNextPageUrl != null) {
        setState(() {
          moreCategoriesLoading = true;
        });
        gettingMoreCategories();
      } else if (categoriesController.position.pixels <=
          categoriesController.position.maxScrollExtent) {
        setState(() {
          moreCategoriesLoading = false;
        });
      }
    });

    // videoController = VideoPlayerController.network(
    //     "http://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")
    //   ..addListener(() {
    //     setState(() {});
    //   })
    //   ..setLooping(true)
    //   ..initialize().then((_) => videoController.play());
    // videoController.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        body: hasConnection
            ? BlocListener<UserProfileBloc, UserProfileState>(
                listener: (context, state) {
                  if (state is GettingUserProfileDataSuccessState) {
                    setState(() {
                      userName = state.name;
                      useAsset = false;
                      userImage = '$ImageServerPrefix/${state.image}';
                      userCountry = state.country;
                    });
                  } else if (state is AddPostSuccessState) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (state is EditPostSuccessState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(editPostsnackBar);
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
                  } else if (state is UpdateBirthDateSuccessState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(editBirthDateSuccessSnackBar);
                  } else if (state is UpdateBirthDateErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(editBirthDateErrorSnackBar);
                  } else if (state is AddCardSuccessState) {
                    setState(() {
                      isHome = true;
                      isAddCard = false;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(addCardSuccessSnackBar);
                  } else if (state is AddCardErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(addCardErrorSnackBar);
                  } else if (state is UpdateCoverPhotoSuccessState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(editCoverSuccessSnackBar);
                  } else if (state is UpdateCoverPhotoErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(editCoverErrorSnackBar);
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      color: KPrimaryColor,
                    ),
                    Positioned(
                      top: 20.0,
                      left: -30.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Account(),
                            ),
                          );
                        },
                        child: HomeProfileCard(
                          useAsset: useAsset,
                          userImage: userImage,
                          userName: userName,
                          countryName: userCountry,
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
                      top: 170.0,
                      right: 0.0,
                      left: 0.0,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        height: screenSize.height - 150,
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
                                            : isCategory
                                                ? category()
                                                : isAddCard
                                                    ? addCard()
                                                    : null,
                      ),
                    ),
                    Positioned(
                      top: 130.0,
                      right: 40.0,
                      left: 60.0,
                      child: kIsWeb
                          ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    height: isSearch ? 80.0 : 70.0,
                                    width: isSearch ? 60.0 : 50.0,
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
                                          isCategory = false;
                                          isNotifications = false;
                                          isMessages = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: isSearch
                                            ? KPrimaryColor
                                            : KSubSecondryFontsColor,
                                        size: isSearch ? 30.0 : 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    height: isHome ? 80.0 : 70.0,
                                    width: isHome ? 60.0 : 50.0,
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
                                          postsFeedShowLoading = true;
                                          isSearch = false;
                                          isPost = false;
                                          isCategory = false;
                                          isNotifications = false;
                                          isMessages = false;
                                          isAddCard = false;
                                        });
                                        gettingPosts();
                                      },
                                      icon: Icon(
                                        Icons.home,
                                        color: isHome
                                            ? KPrimaryColor
                                            : KSubSecondryFontsColor,
                                        size: isHome ? 30.0 : 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    height: isCategory ? 80.0 : 70.0,
                                    width: isCategory ? 60.0 : 50.0,
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
                                          isCategory = true;
                                          isPost = false;
                                          isHome = false;
                                          isSearch = false;
                                          isNotifications = false;
                                          isMessages = false;
                                          isAddCard = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.groups,
                                        color: isCategory
                                            ? KPrimaryColor
                                            : KSubSecondryFontsColor,
                                        size: isCategory ? 30.0 : 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    height: isAddCard ? 80.0 : 70.0,
                                    width: isAddCard ? 60.0 : 50.0,
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
                                          isAddCard = true;
                                          isPost = false;
                                          isHome = false;
                                          isSearch = false;
                                          isCategory = false;
                                          isNotifications = false;
                                          isMessages = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.post_add,
                                        color: isAddCard
                                            ? KPrimaryColor
                                            : KSubSecondryFontsColor,
                                        size: isAddCard ? 30.0 : 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    height: isPost ? 80.0 : 70.0,
                                    width: isPost ? 60.0 : 50.0,
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
                                          isCategory = false;
                                          isNotifications = false;
                                          isMessages = false;
                                          isAddCard = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: isPost
                                            ? KPrimaryColor
                                            : KSubSecondryFontsColor,
                                        size: isPost ? 30.0 : 20.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: isSearch ? 80.0 : 70.0,
                                  width: isSearch ? 60.0 : 50.0,
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
                                        isCategory = false;
                                        isNotifications = false;
                                        isMessages = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color: isSearch
                                          ? KPrimaryColor
                                          : KSubSecondryFontsColor,
                                      size: isSearch ? 30.0 : 20.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: isHome ? 80.0 : 70.0,
                                  width: isHome ? 60.0 : 50.0,
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
                                        postsFeedShowLoading = true;
                                        isSearch = false;
                                        isPost = false;
                                        isCategory = false;
                                        isNotifications = false;
                                        isMessages = false;
                                        isAddCard = false;
                                      });
                                      gettingPosts();
                                    },
                                    icon: Icon(
                                      Icons.home,
                                      color: isHome
                                          ? KPrimaryColor
                                          : KSubSecondryFontsColor,
                                      size: isHome ? 30.0 : 20.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: isCategory ? 80.0 : 70.0,
                                  width: isCategory ? 60.0 : 50.0,
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
                                        isCategory = true;
                                        isPost = false;
                                        isHome = false;
                                        isSearch = false;
                                        isNotifications = false;
                                        isMessages = false;
                                        isAddCard = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.groups,
                                      color: isCategory
                                          ? KPrimaryColor
                                          : KSubSecondryFontsColor,
                                      size: isCategory ? 30.0 : 20.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: isAddCard ? 80.0 : 70.0,
                                  width: isAddCard ? 60.0 : 50.0,
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
                                        isAddCard = true;
                                        isPost = false;
                                        isHome = false;
                                        isSearch = false;
                                        isCategory = false;
                                        isNotifications = false;
                                        isMessages = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.post_add,
                                      color: isAddCard
                                          ? KPrimaryColor
                                          : KSubSecondryFontsColor,
                                      size: isAddCard ? 30.0 : 20.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: isPost ? 80.0 : 70.0,
                                  width: isPost ? 60.0 : 50.0,
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
                                        isCategory = false;
                                        isNotifications = false;
                                        isMessages = false;
                                        isAddCard = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: isPost
                                          ? KPrimaryColor
                                          : KSubSecondryFontsColor,
                                      size: isPost ? 30.0 : 20.0,
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
                child: kIsWeb
                    ? Row(
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
                              onPressed: pickPostImageForWeb,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
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
                      )
                    : Row(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
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
        resizeToAvoidBottomInset: true,
      ),
      onWillPop: () => exitApp(),
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
      ],
    );
  }

  ///***************************************CATEGORIES UI*************************************************************/
  category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 35.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Categories",
                style: KSearchLabelStyle,
              ),
            ],
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
                      categoryResults.clear();
                      footballFilter = !footballFilter;
                    });
                    if (footballFilter == true) {
                      setState(() {
                        categoryShowLoading = true;
                      });
                      gettingCategory();
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
                      categoryResults.clear();
                      basketballFilter = !basketballFilter;
                    });
                    if (basketballFilter == true) {
                      setState(() {
                        categoryShowLoading = true;
                      });
                      gettingCategory();
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
                ? ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 35.0,
                      maxHeight: kIsWeb ? 400.0 : 500.0,
                    ),
                    child: LayoutBuilder(
                      builder: (context, size) => Stack(
                        children: [
                          ListView.separated(
                            controller: categoriesController,
                            separatorBuilder: (context, index) => Divider(
                              color: KSubSecondryFontsColor,
                              indent: 20.0,
                              endIndent: 20.0,
                              thickness: 0.5,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemCount: categoryResults.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                categoryResults[index]['user']['image'] != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      categoryResults[index]
                                                                      ['user']
                                                                  ['id'] ==
                                                              userID
                                                          ? (context) =>
                                                              Account()
                                                          : (context) =>
                                                              OtherUsersProfile(
                                                                userID: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    ['id'],
                                                              ),
                                                ),
                                              );
                                            },
                                            child: ProfileCard(
                                              useAsset: false,
                                              name: getFirstName(
                                                  categoryResults[index]['user']
                                                      ['name']),
                                              image:
                                                  '$ImageServerPrefix/${categoryResults[index]['user']['image']}',
                                              countryName:
                                                  categoryResults[index]['user']
                                                          ['country'] ??
                                                      "",
                                              legOrHand: categoryResults[index]
                                                      ['user']['favorite'] ??
                                                  "",
                                              category: 1,
                                              type: categoryResults[index]
                                                  ['user']['type'],
                                              age: age(
                                                categoryResults[index]['user']
                                                        ['birth_date'] ??
                                                    DateTime.now().toString(),
                                              ),
                                              height: categoryResults[index]
                                                      ['user']['length'] ??
                                                  '0',
                                              weight: categoryResults[index]
                                                      ['user']['weight'] ??
                                                  '0',
                                              mainPosition:
                                                  categoryResults[index]['user']
                                                          ['main_position'] ??
                                                      '',
                                              otherPosition:
                                                  categoryResults[index]['user']
                                                          ['other_position'] ??
                                                      '',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Container(
                                            height: 200.0,
                                            width: 150.0,
                                            child: kIsWeb
                                                ? Stack(
                                                    children: [
                                                      Container(
                                                        child: Image(
                                                          image: AssetImage(
                                                              "assets/images/footballplayground.jpg"),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: KPrimaryColor
                                                              .withOpacity(0.5),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(5.0),
                                                        child: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    [
                                                                    'user_vedio'] !=
                                                                null
                                                            ? Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        30.0,
                                                                  ),
                                                                  Text(
                                                                    "Play Skills Video",
                                                                    style:
                                                                        KPostStyle,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                VideoApp(
                                                                              userName: categoryResults[index]['user']['name'],
                                                                              videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .play_arrow,
                                                                      ),
                                                                      iconSize:
                                                                          70.0,
                                                                      color:
                                                                          KSubPrimaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      "No video available",
                                                                      style:
                                                                          KSubPostStyle,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    ],
                                                  )
                                                : Stack(
                                                    children: [
                                                      Container(
                                                        child: Image(
                                                          image: AssetImage(
                                                              "assets/images/footballplayground.jpg"),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: KPrimaryColor
                                                              .withOpacity(0.5),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(5.0),
                                                        child: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    [
                                                                    'user_vedio'] !=
                                                                null
                                                            ? Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        30.0,
                                                                  ),
                                                                  Text(
                                                                    "Play Skills Video",
                                                                    style:
                                                                        KPostStyle,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SkillsVideo(
                                                                              userName: categoryResults[index]['user']['name'],
                                                                              videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .play_arrow,
                                                                      ),
                                                                      iconSize:
                                                                          70.0,
                                                                      color:
                                                                          KSubPrimaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      "No video available",
                                                                      style:
                                                                          KSubPostStyle,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                            color: KPrimaryColor,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      categoryResults[index]
                                                                      ['user']
                                                                  ['id'] ==
                                                              userID
                                                          ? (context) =>
                                                              Account()
                                                          : (context) =>
                                                              OtherUsersProfile(
                                                                userID: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    ['id'],
                                                              ),
                                                ),
                                              );
                                            },
                                            child: ProfileCard(
                                              useAsset: true,
                                              image:
                                                  "assets/images/nouserimagehandler.jpg",
                                              name: getFirstName(
                                                  categoryResults[index]['user']
                                                      ['name']),
                                              countryName:
                                                  categoryResults[index]['user']
                                                          ['country'] ??
                                                      "",
                                              legOrHand: categoryResults[index]
                                                      ['user']['favorite'] ??
                                                  "",
                                              category: 1,
                                              type: categoryResults[index]
                                                  ['user']['type'],
                                              age: age(
                                                categoryResults[index]['user']
                                                        ['birth_date'] ??
                                                    DateTime.now().toString(),
                                              ),
                                              height: categoryResults[index]
                                                      ['user']['length'] ??
                                                  '0',
                                              weight: categoryResults[index]
                                                      ['user']['weight'] ??
                                                  '0',
                                              mainPosition:
                                                  categoryResults[index]['user']
                                                          ['main_position'] ??
                                                      '',
                                              otherPosition:
                                                  categoryResults[index]['user']
                                                          ['other_position'] ??
                                                      '',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Container(
                                            height: 200.0,
                                            width: 150.0,
                                            child: kIsWeb
                                                ? Stack(
                                                    children: [
                                                      Container(
                                                        child: Image(
                                                          image: AssetImage(
                                                              "assets/images/footballplayground.jpg"),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: KPrimaryColor
                                                              .withOpacity(0.5),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(5.0),
                                                        child: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    [
                                                                    'user_vedio'] !=
                                                                null
                                                            ? Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        30.0,
                                                                  ),
                                                                  Text(
                                                                    "Play Skills Video",
                                                                    style:
                                                                        KPostStyle,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => VideoApp(
                                                                                      userName: categoryResults[index]['user']['name'],
                                                                                      videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                                    )));
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .play_arrow,
                                                                      ),
                                                                      iconSize:
                                                                          70.0,
                                                                      color:
                                                                          KSubPrimaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      "No video available",
                                                                      style:
                                                                          KSubPostStyle,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    ],
                                                  )
                                                : Stack(
                                                    children: [
                                                      Container(
                                                        child: Image(
                                                          image: AssetImage(
                                                              "assets/images/footballplayground.jpg"),
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: KPrimaryColor
                                                              .withOpacity(0.5),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(5.0),
                                                        child: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    [
                                                                    'user_vedio'] !=
                                                                null
                                                            ? Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        30.0,
                                                                  ),
                                                                  Text(
                                                                    "Play Skills Video",
                                                                    style:
                                                                        KPostStyle,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => SkillsVideo(
                                                                                      userName: categoryResults[index]['user']['name'],
                                                                                      videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                                    )));
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .play_arrow,
                                                                      ),
                                                                      iconSize:
                                                                          70.0,
                                                                      color:
                                                                          KSubPrimaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      "No video available",
                                                                      style:
                                                                          KSubPostStyle,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                            color: KPrimaryColor,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          if (moreCategoriesLoading) ...[
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
                          ],
                        ],
                      ),
                    ),
                  )
                : categoryStateIndicator()
            : basketballFilter
                ? categoryResults.isNotEmpty
                    ? ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: 35.0,
                          maxHeight: kIsWeb ? 400.0 : 500.0,
                        ),
                        child: LayoutBuilder(
                          builder: (context, size) => Stack(
                            children: [
                              ListView.separated(
                                controller: categoriesController,
                                separatorBuilder: (context, index) => Divider(
                                  color: KSubSecondryFontsColor,
                                  indent: 20.0,
                                  endIndent: 20.0,
                                  thickness: 0.5,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: ScrollPhysics(),
                                itemCount: categoryResults.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    categoryResults[index]['user']['image'] !=
                                            null
                                        ? Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: categoryResults[
                                                                          index]
                                                                      ['user']
                                                                  ['id'] ==
                                                              userID
                                                          ? (context) =>
                                                              Account()
                                                          : (context) =>
                                                              OtherUsersProfile(
                                                                userID: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    ['id'],
                                                              ),
                                                    ),
                                                  );
                                                },
                                                child: ProfileCard(
                                                  useAsset: false,
                                                  name: getFirstName(
                                                      categoryResults[index]
                                                          ['user']['name']),
                                                  image:
                                                      '$ImageServerPrefix/${categoryResults[index]['user']['image']}',
                                                  countryName:
                                                      categoryResults[index]
                                                                  ['user']
                                                              ['country'] ??
                                                          "",
                                                  legOrHand:
                                                      categoryResults[index]
                                                                  ['user']
                                                              ['favorite'] ??
                                                          "",
                                                  category: 2,
                                                  type: categoryResults[index]
                                                      ['user']['type'],
                                                  age: age(
                                                    categoryResults[index]
                                                                ['user']
                                                            ['birth_date'] ??
                                                        DateTime.now()
                                                            .toString(),
                                                  ),
                                                  height: categoryResults[index]
                                                          ['user']['length'] ??
                                                      '0',
                                                  weight: categoryResults[index]
                                                          ['user']['weight'] ??
                                                      '0',
                                                  mainPosition: categoryResults[
                                                              index]['user']
                                                          ['main_position'] ??
                                                      '',
                                                  otherPosition: categoryResults[
                                                              index]['user']
                                                          ['other_position'] ??
                                                      '',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Container(
                                                height: 200.0,
                                                width: 150.0,
                                                child: kIsWeb
                                                    ? Stack(
                                                        children: [
                                                          Container(
                                                            child: Image(
                                                              image: AssetImage(
                                                                  "assets/images/basketballplayground.jpg"),
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: KPrimaryColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: categoryResults[index]
                                                                            [
                                                                            'user']
                                                                        [
                                                                        'user_vedio'] !=
                                                                    null
                                                                ? Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            30.0,
                                                                      ),
                                                                      Text(
                                                                        "Play Skills Video",
                                                                        style:
                                                                            KPostStyle,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => VideoApp(
                                                                                          userName: categoryResults[index]['user']['name'],
                                                                                          videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                                        )));
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.play_arrow,
                                                                          ),
                                                                          iconSize:
                                                                              70.0,
                                                                          color:
                                                                              KSubPrimaryColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "No video available",
                                                                          style:
                                                                              KSubPostStyle,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ],
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Container(
                                                            child: Image(
                                                              image: AssetImage(
                                                                  "assets/images/basketballplayground.jpg"),
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: KPrimaryColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: categoryResults[index]
                                                                            [
                                                                            'user']
                                                                        [
                                                                        'user_vedio'] !=
                                                                    null
                                                                ? Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            30.0,
                                                                      ),
                                                                      Text(
                                                                        "Play Skills Video",
                                                                        style:
                                                                            KPostStyle,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => SkillsVideo(
                                                                                          userName: categoryResults[index]['user']['name'],
                                                                                          videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                                        )));
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.play_arrow,
                                                                          ),
                                                                          iconSize:
                                                                              70.0,
                                                                          color:
                                                                              KSubPrimaryColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "No video available",
                                                                          style:
                                                                              KSubPostStyle,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                color: KPrimaryColor,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: categoryResults[
                                                                          index]
                                                                      ['user']
                                                                  ['id'] ==
                                                              userID
                                                          ? (context) =>
                                                              Account()
                                                          : (context) =>
                                                              OtherUsersProfile(
                                                                userID: categoryResults[
                                                                            index]
                                                                        ['user']
                                                                    ['id'],
                                                              ),
                                                    ),
                                                  );
                                                },
                                                child: ProfileCard(
                                                  useAsset: true,
                                                  image:
                                                      "assets/images/nouserimagehandler.jpg",
                                                  name: getFirstName(
                                                      categoryResults[index]
                                                          ['user']['name']),
                                                  countryName:
                                                      categoryResults[index]
                                                                  ['user']
                                                              ['country'] ??
                                                          "",
                                                  legOrHand:
                                                      categoryResults[index]
                                                                  ['user']
                                                              ['favorite'] ??
                                                          "",
                                                  category: 2,
                                                  type: categoryResults[index]
                                                      ['user']['type'],
                                                  age: age(
                                                    categoryResults[index]
                                                                ['user']
                                                            ['birth_date'] ??
                                                        DateTime.now()
                                                            .toString(),
                                                  ),
                                                  height: categoryResults[index]
                                                          ['user']['length'] ??
                                                      '0',
                                                  weight: categoryResults[index]
                                                          ['user']['weight'] ??
                                                      '0',
                                                  mainPosition: categoryResults[
                                                              index]['user']
                                                          ['main_position'] ??
                                                      '',
                                                  otherPosition: categoryResults[
                                                              index]['user']
                                                          ['other_position'] ??
                                                      '',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Container(
                                                height: 200.0,
                                                width: 150.0,
                                                child: kIsWeb
                                                    ? Stack(
                                                        children: [
                                                          Container(
                                                            child: Image(
                                                              image: AssetImage(
                                                                  "assets/images/basketballplayground.jpg"),
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: KPrimaryColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: categoryResults[index]
                                                                            [
                                                                            'user']
                                                                        [
                                                                        'user_vedio'] !=
                                                                    null
                                                                ? Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            30.0,
                                                                      ),
                                                                      Text(
                                                                        "Play Skills Video",
                                                                        style:
                                                                            KPostStyle,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => VideoApp(
                                                                                          userName: categoryResults[index]['user']['name'],
                                                                                          videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                                        )));
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.play_arrow,
                                                                          ),
                                                                          iconSize:
                                                                              70.0,
                                                                          color:
                                                                              KSubPrimaryColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "No video available",
                                                                          style:
                                                                              KSubPostStyle,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ],
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Container(
                                                            child: Image(
                                                              image: AssetImage(
                                                                  "assets/images/basketballplayground.jpg"),
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: KPrimaryColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: categoryResults[index]
                                                                            [
                                                                            'user']
                                                                        [
                                                                        'user_vedio'] !=
                                                                    null
                                                                ? Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            30.0,
                                                                      ),
                                                                      Text(
                                                                        "Play Skills Video",
                                                                        style:
                                                                            KPostStyle,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => SkillsVideo(
                                                                                          userName: categoryResults[index]['user']['name'],
                                                                                          videoUrl: '$ImageServerPrefix/${categoryResults[index]['user']['user_vedio']}',
                                                                                        )));
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.play_arrow,
                                                                          ),
                                                                          iconSize:
                                                                              70.0,
                                                                          color:
                                                                              KSubPrimaryColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "No video available",
                                                                          style:
                                                                              KSubPostStyle,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                color: KPrimaryColor,
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              if (moreCategoriesLoading) ...[
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
                              ],
                            ],
                          ),
                        ),
                      )
                    : categoryStateIndicator()
                : Container(),
      ],
    );
  }

  ///***************************************ADD CARD UI*************************************************************/
  addCard() {
    return kIsWeb
        ? Stack(
            children: [
              Container(
                child: Image(
                  image: AssetImage("assets/images/10839772.jpg"),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Container(
                  width: 435.0,
                  height: double.infinity,
                  child: ListView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: KPrimaryColor.withOpacity(0.5),
                        ),
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Add card information",
                                style: KSubPrimaryFontStyleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: KSubPrimaryColor,
                                border: Border.all(
                                  width: 1.0,
                                  color: KSubPrimaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  selectCountry(context);
                                },
                                child: DropdownButton<dynamic>(
                                  icon: Icon(
                                    Icons.public,
                                    color: KPrimaryColor,
                                  ),
                                  iconSize: 25.0,
                                  style: KDropdownButtonStyle,
                                  underline: Container(
                                    width: 0.0,
                                  ),
                                  isExpanded: true,
                                  hint: Text(selectedCountry),
                                  onChanged: (newValuex) {},
                                  items: [],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: KSubPrimaryColor,
                                border: Border.all(
                                  width: 1.0,
                                  color: KSubPrimaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: DropdownButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: KPrimaryColor,
                                ),
                                iconSize: 25.0,
                                style: KDropdownButtonStyle,
                                underline: Container(
                                  width: 0.0,
                                ),
                                isExpanded: true,
                                hint: Text('Type'),
                                value: _selectedType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedType = newValue.toString();
                                  });
                                },
                                items: _types.map((type) {
                                  return DropdownMenuItem(
                                    child: Text(type),
                                    value: type,
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: KSubPrimaryColor,
                                border: Border.all(
                                  width: 1.0,
                                  color: KSubPrimaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: DropdownButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: KPrimaryColor,
                                ),
                                iconSize: 25.0,
                                style: KDropdownButtonStyle,
                                underline: Container(
                                  width: 0.0,
                                ),
                                isExpanded: true,
                                hint: Text('Category'),
                                value: _selectedCategory,
                                onChanged: (newValuex) {
                                  setState(() {
                                    _selectedCategory = newValuex.toString();
                                  });
                                },
                                items: _category.map((category) {
                                  return DropdownMenuItem(
                                    child: Text(category),
                                    value: category,
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: KSubPrimaryColor,
                                border: Border.all(
                                  width: 1.0,
                                  color: KSubPrimaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: DropdownButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: KPrimaryColor,
                                ),
                                iconSize: 25.0,
                                style: KDropdownButtonStyle,
                                underline: Container(
                                  width: 0.0,
                                ),
                                isExpanded: true,
                                hint: Text('Favotite Leg or Hand'),
                                value: selectedFavotite,
                                onChanged: (newValuex) {
                                  setState(() {
                                    selectedFavotite = newValuex.toString();
                                  });
                                },
                                items: favorites.map((favorite) {
                                  return DropdownMenuItem(
                                    child: Text(favorite),
                                    value: favorite,
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            _selectedCategory == 'Category'
                                ? Container()
                                : _selectedCategory == 'Football'
                                    ? Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 45.0,
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: KSubPrimaryColor,
                                              border: Border.all(
                                                width: 1.0,
                                                color: KSubPrimaryColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                            ),
                                            child: DropdownButton(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: KPrimaryColor,
                                              ),
                                              iconSize: 25.0,
                                              style: KDropdownButtonStyle,
                                              underline: Container(
                                                width: 0.0,
                                              ),
                                              isExpanded: true,
                                              hint:
                                                  Text('Select main position'),
                                              value:
                                                  selectedMainFootballPosition,
                                              onChanged: (newValuex) {
                                                setState(() {
                                                  selectedMainFootballPosition =
                                                      newValuex.toString();
                                                });
                                              },
                                              items: footballPositions
                                                  .map((position) {
                                                return DropdownMenuItem(
                                                  child: Text(position),
                                                  value: position,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 45.0,
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: KSubPrimaryColor,
                                              border: Border.all(
                                                width: 1.0,
                                                color: KSubPrimaryColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                            ),
                                            child: DropdownButton(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: KPrimaryColor,
                                              ),
                                              iconSize: 25.0,
                                              style: KDropdownButtonStyle,
                                              underline: Container(
                                                width: 0.0,
                                              ),
                                              isExpanded: true,
                                              hint:
                                                  Text('Select other position'),
                                              value:
                                                  selectedOtherFootballPosition,
                                              onChanged: (newValuex) {
                                                setState(() {
                                                  selectedOtherFootballPosition =
                                                      newValuex.toString();
                                                });
                                              },
                                              items: otherFootballPositions
                                                  .map((position) {
                                                return DropdownMenuItem(
                                                  child: Text(position),
                                                  value: position,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      )
                                    : _selectedCategory == 'Basketball'
                                        ? Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 45.0,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  color: KSubPrimaryColor,
                                                  border: Border.all(
                                                    width: 1.0,
                                                    color: KSubPrimaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              40.0)),
                                                ),
                                                child: DropdownButton(
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: KPrimaryColor,
                                                  ),
                                                  iconSize: 25.0,
                                                  style: KDropdownButtonStyle,
                                                  underline: Container(
                                                    width: 0.0,
                                                  ),
                                                  isExpanded: true,
                                                  hint: Text(
                                                      'Select main position'),
                                                  value:
                                                      selectedMainBasketballPosition,
                                                  onChanged: (newValuex) {
                                                    setState(() {
                                                      selectedMainBasketballPosition =
                                                          newValuex.toString();
                                                    });
                                                  },
                                                  items: basketballPositions
                                                      .map((position) {
                                                    return DropdownMenuItem(
                                                      child: Text(position),
                                                      value: position,
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 45.0,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  color: KSubPrimaryColor,
                                                  border: Border.all(
                                                    width: 1.0,
                                                    color: KSubPrimaryColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              40.0)),
                                                ),
                                                child: DropdownButton(
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: KPrimaryColor,
                                                  ),
                                                  iconSize: 25.0,
                                                  style: KDropdownButtonStyle,
                                                  underline: Container(
                                                    width: 0.0,
                                                  ),
                                                  isExpanded: true,
                                                  hint: Text(
                                                      'Select other position'),
                                                  value:
                                                      selectedOtherBasketballPosition,
                                                  onChanged: (newValuex) {
                                                    setState(() {
                                                      selectedOtherBasketballPosition =
                                                          newValuex.toString();
                                                    });
                                                  },
                                                  items:
                                                      otherBasketballPositions
                                                          .map((position) {
                                                    return DropdownMenuItem(
                                                      child: Text(position),
                                                      value: position,
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.0,
                              child: heightAndWeightTextField(
                                  heightTextController,
                                  "Enter your height in cm"),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.0,
                              child: heightAndWeightTextField(
                                  weightTextController,
                                  "Enter your weight in kg"),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: KSubPrimaryColor,
                                border: Border.all(
                                  width: 1.0,
                                  color: KSubPrimaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  pickVideoForWeb();
                                },
                                child: DropdownButton<dynamic>(
                                  icon: Icon(
                                    Icons.movie,
                                    color: KPrimaryColor,
                                  ),
                                  iconSize: 25.0,
                                  style: KDropdownButtonStyle,
                                  underline: Container(
                                    width: 0.0,
                                  ),
                                  isExpanded: true,
                                  hint: Text('Add skills video'),
                                  onChanged: (value) {},
                                  items: [],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Container(
                              width: 150.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3.0,
                                  color: KSubPrimaryColor,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35.0)),
                              ),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    addCardEvent();
                                  },
                                  child: Text(
                                    "Add Card",
                                    style: KSubSubPrimaryButtonsFontStyle,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            indicator,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              Container(
                child: Image(
                  image: AssetImage("assets/images/10839772.jpg"),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: KPrimaryColor.withOpacity(0.5),
                    ),
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "Add card information",
                            style: KSubPrimaryFontStyleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 45.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: KSubPrimaryColor,
                            border: Border.all(
                              width: 1.0,
                              color: KSubPrimaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: InkWell(
                            onTap: () {
                              selectCountry(context);
                            },
                            child: DropdownButton<dynamic>(
                              icon: Icon(
                                Icons.public,
                                color: KPrimaryColor,
                              ),
                              iconSize: 25.0,
                              style: KDropdownButtonStyle,
                              underline: Container(
                                width: 0.0,
                              ),
                              isExpanded: true,
                              hint: Text(selectedCountry),
                              onChanged: (newValuex) {},
                              items: [],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: KSubPrimaryColor,
                            border: Border.all(
                              width: 1.0,
                              color: KSubPrimaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: DropdownButton(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: KPrimaryColor,
                            ),
                            iconSize: 25.0,
                            style: KDropdownButtonStyle,
                            underline: Container(
                              width: 0.0,
                            ),
                            isExpanded: true,
                            hint: Text('Type'),
                            value: _selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedType = newValue.toString();
                              });
                            },
                            items: _types.map((type) {
                              return DropdownMenuItem(
                                child: Text(type),
                                value: type,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: KSubPrimaryColor,
                            border: Border.all(
                              width: 1.0,
                              color: KSubPrimaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: DropdownButton(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: KPrimaryColor,
                            ),
                            iconSize: 25.0,
                            style: KDropdownButtonStyle,
                            underline: Container(
                              width: 0.0,
                            ),
                            isExpanded: true,
                            hint: Text('Category'),
                            value: _selectedCategory,
                            onChanged: (newValuex) {
                              setState(() {
                                _selectedCategory = newValuex.toString();
                              });
                            },
                            items: _category.map((category) {
                              return DropdownMenuItem(
                                child: Text(category),
                                value: category,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: KSubPrimaryColor,
                            border: Border.all(
                              width: 1.0,
                              color: KSubPrimaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: DropdownButton(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: KPrimaryColor,
                            ),
                            iconSize: 25.0,
                            style: KDropdownButtonStyle,
                            underline: Container(
                              width: 0.0,
                            ),
                            isExpanded: true,
                            hint: Text('Favotite Leg or Hand'),
                            value: selectedFavotite,
                            onChanged: (newValuex) {
                              setState(() {
                                selectedFavotite = newValuex.toString();
                              });
                            },
                            items: favorites.map((favorite) {
                              return DropdownMenuItem(
                                child: Text(favorite),
                                value: favorite,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        _selectedCategory == 'Category'
                            ? Container()
                            : _selectedCategory == 'Football'
                                ? Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 45.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: KSubPrimaryColor,
                                          border: Border.all(
                                            width: 1.0,
                                            color: KSubPrimaryColor,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)),
                                        ),
                                        child: DropdownButton(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: KPrimaryColor,
                                          ),
                                          iconSize: 25.0,
                                          style: KDropdownButtonStyle,
                                          underline: Container(
                                            width: 0.0,
                                          ),
                                          isExpanded: true,
                                          hint: Text('Select main position'),
                                          value: selectedMainFootballPosition,
                                          onChanged: (newValuex) {
                                            setState(() {
                                              selectedMainFootballPosition =
                                                  newValuex.toString();
                                            });
                                          },
                                          items:
                                              footballPositions.map((position) {
                                            return DropdownMenuItem(
                                              child: Text(position),
                                              value: position,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 45.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: KSubPrimaryColor,
                                          border: Border.all(
                                            width: 1.0,
                                            color: KSubPrimaryColor,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)),
                                        ),
                                        child: DropdownButton(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: KPrimaryColor,
                                          ),
                                          iconSize: 25.0,
                                          style: KDropdownButtonStyle,
                                          underline: Container(
                                            width: 0.0,
                                          ),
                                          isExpanded: true,
                                          hint: Text('Select other position'),
                                          value: selectedOtherFootballPosition,
                                          onChanged: (newValuex) {
                                            setState(() {
                                              selectedOtherFootballPosition =
                                                  newValuex.toString();
                                            });
                                          },
                                          items: otherFootballPositions
                                              .map((position) {
                                            return DropdownMenuItem(
                                              child: Text(position),
                                              value: position,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  )
                                : _selectedCategory == 'Basketball'
                                    ? Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 45.0,
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: KSubPrimaryColor,
                                              border: Border.all(
                                                width: 1.0,
                                                color: KSubPrimaryColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                            ),
                                            child: DropdownButton(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: KPrimaryColor,
                                              ),
                                              iconSize: 25.0,
                                              style: KDropdownButtonStyle,
                                              underline: Container(
                                                width: 0.0,
                                              ),
                                              isExpanded: true,
                                              hint:
                                                  Text('Select main position'),
                                              value:
                                                  selectedMainBasketballPosition,
                                              onChanged: (newValuex) {
                                                setState(() {
                                                  selectedMainBasketballPosition =
                                                      newValuex.toString();
                                                });
                                              },
                                              items: basketballPositions
                                                  .map((position) {
                                                return DropdownMenuItem(
                                                  child: Text(position),
                                                  value: position,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 45.0,
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: KSubPrimaryColor,
                                              border: Border.all(
                                                width: 1.0,
                                                color: KSubPrimaryColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40.0)),
                                            ),
                                            child: DropdownButton(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: KPrimaryColor,
                                              ),
                                              iconSize: 25.0,
                                              style: KDropdownButtonStyle,
                                              underline: Container(
                                                width: 0.0,
                                              ),
                                              isExpanded: true,
                                              hint:
                                                  Text('Select other position'),
                                              value:
                                                  selectedOtherBasketballPosition,
                                              onChanged: (newValuex) {
                                                setState(() {
                                                  selectedOtherBasketballPosition =
                                                      newValuex.toString();
                                                });
                                              },
                                              items: otherBasketballPositions
                                                  .map((position) {
                                                return DropdownMenuItem(
                                                  child: Text(position),
                                                  value: position,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45.0,
                          child: heightAndWeightTextField(
                              heightTextController, "Enter your height in cm"),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45.0,
                          child: heightAndWeightTextField(
                              weightTextController, "Enter your weight in kg"),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: KSubPrimaryColor,
                            border: Border.all(
                              width: 1.0,
                              color: KSubPrimaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: DropdownButton(
                            icon: Icon(
                              Icons.movie,
                              color: KPrimaryColor,
                            ),
                            iconSize: 25.0,
                            style: KDropdownButtonStyle,
                            underline: Container(
                              width: 0.0,
                            ),
                            isExpanded: true,
                            hint: Text('Add skills video'),
                            value: selectedSkillsVideo,
                            onChanged: (newValueOne) {
                              setState(() {
                                selectedSkillsVideo = newValueOne.toString();
                              });
                              check();
                            },
                            items: skillsVideo.map((videoOption) {
                              return DropdownMenuItem(
                                child: Text(videoOption),
                                value: videoOption,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          width: 150.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3.0,
                              color: KSubPrimaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                addCardEvent();
                              },
                              child: Text(
                                "Add Card",
                                style: KSubSubPrimaryButtonsFontStyle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        indicator,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  ///***************************************ADD POST UI*************************************************************/
  addPost() {
    return ListView(
      shrinkWrap: true,
      children: [
        kIsWeb
            ? Padding(
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
                    postHasImageWeb
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      image: DecorationImage(
                                        image: MemoryImage(
                                          postImageWebBytesData,
                                        ),
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
                                          postHasImageWeb = false;
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
              )
            : Padding(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
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
                  ListView.separated(
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
                        index % 10 == 0 ? imagecarousel : Container(),
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
                                                        likeID: userLikes[index]
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
                                        child: displayPostImage(
                                            posts[index]['images'][0]['image']),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      userLikes[index]['likeState']
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: KWarningColor,
                                              ),
                                              iconSize: 17.0,
                                              onPressed: () {
                                                unLike(posts[index]['id'],
                                                    userLikes[index]['likeID']);
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
                                              title: "No internet connection !",
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
                                                userID: posts[index]['user_id'],
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

  String getFirstName(String name) {
    if (name.indexOf(' ') == -1) {
      return name;
    } else {
      String newName = name.substring(0, name.indexOf(' '));
      return newName;
    }
  }

  String age(String date) {
    var parseToDate = DateTime.parse(date);
    var age = DateTime.now().year - parseToDate.year;
    return age.toString();
  }

  exitApp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: KPrimaryFontsColor,
            elevation: 1.0,
            title: Text(
              "Exit Fntat",
              style: TextStyle(
                color: KSubPrimaryFontsColor,
                fontFamily: KPrimaryFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
                height: 1.3,
              ),
            ),
            content: Text(
              "Do you want to exit ?",
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
                  'Yes',
                  style: TextStyle(
                    color: KSubPrimaryFontsColor,
                    fontFamily: KPrimaryFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    height: 1.3,
                  ),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
              TextButton(
                child: Text(
                  'No',
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
            ],
          );
        });
  }

  ///***************************************CATEGORIES LOGIC*************************************************************/
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
      final nextPage = res.data['data']['next_page_url'];
      setState(() {
        categoryResults = resBody;
        categoriesNextPageUrl = nextPage;
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  gettingMoreCategories() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    if (categoriesNextPageUrl != null) {
      try {
        final res = await dio.post(categoriesNextPageUrl);
        final List<dynamic> resBody = res.data['data']['data'];
        final nextPageBody = res.data['data']['next_page_url'];
        setState(() {
          categoryResults.addAll(resBody);
          categoriesNextPageUrl = nextPageBody;
        });
      } on Exception catch (error) {
        print(error.toString());
      }
    }
  }

  ///***************************************ADD CARD LOGIC*************************************************************/
  final indicator =
      BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
    if (state is UserProfileLoadingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KPrimaryColor,
          color: KSubPrimaryColor,
          strokeWidth: 3.0,
        ),
      );
    } else {
      return Container();
    }
  });
  selectCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country.displayName
              .substring(country.displayName.indexOf('(') + 1,
                  country.displayName.indexOf(')'))
              .toLowerCase();
        });
      },
    );
  }

  check() {
    if (selectedSkillsVideo == 'Take video') {
      takeVideo();
    } else if (selectedSkillsVideo == 'Choose existing video') {
      chooseVideo();
    }
  }

  Future chooseVideo() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().pickVideo(source: source);
    setState(() {
      userVideo = File(pickedFile!.path);
      hasVideo = true;
    });
  }

  Future takeVideo() async {
    final source = ImageSource.camera;
    final pickedFile = await ImagePicker().pickVideo(source: source);
    setState(() {
      userVideo = File(pickedFile!.path);
      hasVideo = true;
    });
  }

  void pickVideoForWeb() async {
    FilePickerResult? videoWeb;
    videoWeb = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (videoWeb != null) {
      setState(() {
        videoNameWeb = videoWeb!.files.single.name;
        videoWebBytesData = videoWeb.files.single.bytes!;
        hasVideoWeb = true;
        videoWebBytes = videoWebBytesData.cast();
      });
    }
  }

  addCardEvent() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Please turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (selectedCountry == "Select your country") {
      Warning().errorMessage(context,
          title: "Country field can't be empty !",
          message: "Please select a country",
          icons: Icons.warning);
    } else if (_selectedType == "Type") {
      Warning().errorMessage(context,
          title: "Type field can't be empty !",
          message: "Please select a type",
          icons: Icons.warning);
    } else if (_selectedCategory == "Category") {
      Warning().errorMessage(context,
          title: "Category field can't be empty !",
          message: "Please select a category",
          icons: Icons.warning);
    } else if (selectedFavotite == "Favotite Leg or Hand") {
      Warning().errorMessage(context,
          title: "Favotite field can't be empty !",
          message: "Please select a favotite leg or hand",
          icons: Icons.warning);
    } else if (heightTextController.text.isEmpty) {
      Warning().errorMessage(context,
          title: "Height field can't be empty !",
          message: "Please enter your height",
          icons: Icons.warning);
    } else if (weightTextController.text.isEmpty) {
      Warning().errorMessage(context,
          title: "Weight field can't be empty !",
          message: "Please enter your weight",
          icons: Icons.warning);
    } else {
      if (_selectedType == 'Admin') {
        setState(() {
          typeID = 1;
        });
      } else if (_selectedType == 'Amateur') {
        setState(() {
          typeID = 2;
        });
      } else if (_selectedType == 'Professional') {
        setState(() {
          typeID = 3;
        });
      } else if (_selectedType == 'Agent') {
        setState(() {
          typeID = 4;
        });
      } else if (_selectedType == 'Academy') {
        setState(() {
          typeID = 5;
        });
      } else if (_selectedType == 'Club') {
        setState(() {
          typeID = 6;
        });
      }
      if (_selectedCategory == 'Football') {
        setState(() {
          categoryID = 1;
        });
        if (selectedMainFootballPosition == "Select football position") {
          Warning().errorMessage(context,
              title: "Main Position field can't be empty !",
              message: "Please select a main position",
              icons: Icons.warning);
        } else if (selectedOtherFootballPosition ==
            "Select other football position") {
          Warning().errorMessage(context,
              title: "Other Position field can't be empty !",
              message: "Please select other position",
              icons: Icons.warning);
        } else {
          setState(() {
            mainPosition =
                selectedMainFootballPosition.split('(')[1].substring(0, 2);
          });
          setState(() {
            otherPosition =
                selectedOtherFootballPosition.split('(')[1].substring(0, 2);
          });
        }
      } else if (_selectedCategory == 'Basketball') {
        setState(() {
          categoryID = 2;
        });
        if (selectedMainBasketballPosition == "Select basketball position") {
          Warning().errorMessage(context,
              title: "Main Position field can't be empty !",
              message: "Please select a main position",
              icons: Icons.warning);
        } else if (selectedOtherBasketballPosition ==
            "Select other basketball position") {
          Warning().errorMessage(context,
              title: "Other Position field can't be empty !",
              message: "Please select other position",
              icons: Icons.warning);
        } else {
          setState(() {
            mainPosition =
                selectedMainBasketballPosition.split('(')[1].substring(0, 2);
          });
          setState(() {
            otherPosition =
                selectedOtherBasketballPosition.split('(')[1].substring(0, 2);
          });
        }
      }
      if (kIsWeb) {
        if (hasVideoWeb == false) {
          Warning().errorMessage(context,
              title: "Video field can't be empty !",
              message: "Please choose a video",
              icons: Icons.warning);
        } else {
          userProfileBloc.add(AddCardButtonPressedWeb(
            country: selectedCountry,
            type: typeID,
            category: categoryID,
            favorite: selectedFavotite,
            mainPosition: mainPosition,
            otherPosition: otherPosition,
            height: heightTextController.text,
            weight: weightTextController.text,
            video: videoWebBytes,
            videoName: videoNameWeb,
          ));
        }
      } else {
        if (hasVideo == false) {
          Warning().errorMessage(context,
              title: "Video field can't be empty !",
              message: "Please take or choose a video",
              icons: Icons.warning);
        } else {
          userProfileBloc.add(AddCardButtonPressed(
            country: selectedCountry,
            type: typeID,
            category: categoryID,
            favorite: selectedFavotite,
            mainPosition: mainPosition,
            otherPosition: otherPosition,
            height: heightTextController.text,
            weight: weightTextController.text,
            video: userVideo,
          ));
        }
      }
    }
  }

  ///***************************************ADD POST LOGIC*************************************************************/
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

  void pickPostImageForWeb() async {
    FilePickerResult? postImageWeb;
    postImageWeb = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (postImageWeb != null) {
      setState(() {
        postImageNameWeb = postImageWeb!.files.single.name;
        postImageWebBytesData = postImageWeb.files.single.bytes!;
        postHasImageWeb = true;
        postImageWebBytes = postImageWebBytesData.cast();
      });
    }
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
    } else if (kIsWeb && postHasImageWeb == true) {
      userProfileBloc.add(
        AddNewPostWithImageFiredWeb(
          post: postTextController.text,
          image: postImageWebBytes,
          imageName: postImageNameWeb,
        ),
      );
      post.clear();
      setState(() {
        postHasImageWeb = false;
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
    heightTextController.dispose();
    weightTextController.dispose();
    messagesScrollController.dispose();
    postsScrollController.dispose();
    categoriesController.dispose();
  }
}
