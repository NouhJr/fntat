import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:fntat/Components/constants.dart';
import 'package:fntat/User_Interface/account_screen.dart';
import 'package:fntat/User_Interface/settings_screen.dart';
import 'package:fntat/User_Interface/search_screen.dart';
import 'package:fntat/User_Interface/notifications_screen.dart';
import 'package:fntat/User_Interface/messages_screen.dart';
import 'package:fntat/User_Interface/newsFeed_screen.dart';
import 'package:fntat/User_Interface/editPhone_screen.dart';
import 'package:fntat/User_Interface/editName_screen.dart';
import 'package:fntat/User_Interface/editEmail_screen.dart';
import 'package:fntat/User_Interface/editProfilePicture_screen.dart';
import 'package:fntat/User_Interface/changePassword_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/User_Interface/addPost_screen.dart';
import 'package:fntat/User_Interface/followers_screen.dart';
import 'package:fntat/User_Interface/following_screen.dart';
import 'package:fntat/User_Interface/category_screen.dart';
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
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  var pages = [
    UserFeed(),
    Notifications(),
    Messages(),
  ];

  bool isHome = true;
  bool isSearch = false;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      setState(() {
        isHome = true;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }
    // else if (_selectedIndex == 1) {
    //   setState(() {
    //     isHome = false;
    //     isSearch = true;
    //   });
    //   showSearch(context: context, delegate: SearchBar());
    // }
    // else {
    //   setState(() {
    //     isHome = false;
    //     isSearch = false;
    //   });
    // }
  }

  late UserProfileBloc userProfileBloc;
  @override
  void initState() {
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
    super.initState();
  }

  var userName = 'User Name';
  var userEmail = 'user@email.com';
  var userImage =
      "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg?itok=PANMBJF-";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isHome
          ? AppBar(
              elevation: 0.0,
              backgroundColor: KSubPrimaryColor,
              title: Text(
                APPNAME,
                style: AppNameStyle,
              ),
              centerTitle: true,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: KPrimaryColor,
                      size: 35.0,
                    ),
                  );
                },
              ),
              actions: [
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      onPressed: () {
                        showSearch(context: context, delegate: SearchBar());
                      },
                      icon: Icon(
                        FontAwesomeIcons.search,
                        color: KPrimaryColor,
                        size: 25.0,
                      ),
                    );
                  },
                ),
              ],
            )
          : isSearch
              ? AppBar(
                  elevation: 0.0,
                  backgroundColor: KSubPrimaryColor,
                  title: Text(
                    "Search in " + APPNAME,
                    style: AppNameStyle,
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: KPrimaryColor,
                    ),
                    onPressed: () => {
                      setState(() {
                        _selectedIndex = 0;
                        isHome = true;
                      }),
                    },
                  ),
                  actions: [
                    IconButton(
                      onPressed: () =>
                          showSearch(context: context, delegate: SearchBar()),
                      icon: Icon(FontAwesomeIcons.search),
                      color: KPrimaryColor,
                    ),
                  ],
                )
              : AppBar(
                  elevation: 0.0,
                  backgroundColor: KSubPrimaryColor,
                  title: Text(
                    APPNAME,
                    style: AppNameStyle,
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: KPrimaryColor,
                    ),
                    onPressed: () => {
                      setState(() {
                        _selectedIndex = 0;
                        isHome = true;
                      }),
                    },
                  ),
                ),
      drawer: Drawer(
        child: Container(
          width: 30.0,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                //Data goes here
                accountName: Text(
                  userName,
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 20,
                    color: KPrimaryFontsColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                accountEmail: Text(
                  userEmail,
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 20,
                    color: KPrimaryFontsColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                  ),
                ),

                //Box holding first section (User Data)
                decoration: drawerBoxDecoration,
              ),
              ReuseableInkwell(
                inkTitle: "Profile",
                icon: Icons.person,
                iconColor: KPrimaryColor,
                onPress: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/Profile');
                },
              ),
              Column(
                children: [
                  ReuseableInkwell(
                    inkTitle: "Categories",
                    icon: Icons.category_rounded,
                    iconColor: KPrimaryColor,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 65.0,
                          ),
                          Icon(
                            Icons.sports_soccer,
                            color: KPrimaryColor,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Category(
                                    categoryID: 1,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Football",
                              style: KCategoryButtonStyle,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 65.0,
                          ),
                          Icon(
                            Icons.sports_baseball,
                            color: KPrimaryColor,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Category(
                                    categoryID: 2,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Basketball",
                              style: KCategoryButtonStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              ReuseableInkwell(
                inkTitle: "Settings",
                icon: Icons.manage_accounts_rounded,
                iconColor: KPrimaryColor,
                onPress: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(fromAccount: false),
                    ),
                  );
                },
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/demo_ad_vertical.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is GettingUserProfileDataSuccessState) {
              setState(() {
                userName = state.name ?? "user name";
                userEmail = state.email ?? "user@email.com";
                userImage = 'http://164.160.104.125:9090/fntat/${state.image}';
              });
            }
          },
          child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: "",
            backgroundColor: KSubSecondryFontsColor,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(FontAwesomeIcons.search),
          //   label: "",
          //   backgroundColor: KSubSecondryFontsColor,
          // ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bell),
            label: "",
            backgroundColor: KSubSecondryFontsColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.envelope),
            label: "",
            backgroundColor: KSubSecondryFontsColor,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: KPrimaryColor,
        iconSize: 30,
        onTap: _onItemTap,
      ),
    );
  }
}
