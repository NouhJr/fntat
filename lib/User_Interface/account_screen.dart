import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Components/constants.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late UserProfileBloc userProfileBloc;
  @override
  void initState() {
    getUserData();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingFollowingAndFollowersCount(id: userID));
    super.initState();
  }

  var userName = '';
  var userEmail = '';
  var userID = 0;
  getUserData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("USERNAME")!;
      userEmail = prefs.getString("EMAIL")!;
      userID = prefs.getInt("USERID")!;
    });
  }

  var followersCount = 0;
  var followingCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingFollowingAndFollowersCountSuccessState) {
            setState(() {
              followingCount = state.followingCount;
              followersCount = state.followersCount;
            });
          }
        },
        child: DefaultTabController(
          length: 2,
          child: CustomScrollView(slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 160.0,
              backgroundColor: KPrimaryColor,
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg?itok=PANMBJF-"),
              ),
              actions: [
                TextButton(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/Settings'),
                  },
                  child: Text("Edit Profile", style: KFollowing_FollowersStyle),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ],
              title: Text(
                userName,
                style: KUserNameStyle,
              ),
              bottom: TabBar(tabs: [
                Tab(
                    child: TextButton(
                  child: Text(
                    "$followingCount Following",
                    style: KFollowing_FollowersStyle,
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () => {},
                )),
                Tab(
                  child: TextButton(
                    child: Text(
                      "$followersCount Followers",
                      style: KFollowing_FollowersStyle,
                    ),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () => {},
                  ),
                )
              ]),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                // return Padding(
                //   padding: EdgeInsets.all(5.0),
                //   child: Column(
                //     children: [
                //       Container(
                //         child: Stack(
                //           children: [
                //             Container(
                //               width: double.infinity,
                //               height: 100.0,
                //               decoration: BoxDecoration(
                //                 color: KPrimaryColor,
                //                 borderRadius:
                //                     BorderRadius.all(Radius.circular(10)),
                //               ),
                //             ),
                //             Container(
                //               margin: EdgeInsets.symmetric(
                //                 horizontal: 150.0,
                //                 vertical: 40.0,
                //               ),
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                   color: KSubPrimaryColor,
                //                   width: 5,
                //                 ),
                //                 shape: BoxShape.circle,
                //               ),
                //               child: CircleAvatar(
                //                 radius: 40,
                //                 backgroundImage: NetworkImage(
                //                     "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg?itok=PANMBJF-"),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         width: double.infinity,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               userName,
                //               style: KUserNameStyle,
                //             ),
                //             Text(
                //               userEmail,
                //               style: KUserEmailStyle,
                //             ),
                //             SizedBox(
                //               height: 10.0,
                //             ),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 TextButton(
                //                   child: Text(
                //                     "$followingCount Following",
                //                     style: KFollowing_FollowersStyle,
                //                   ),
                //                   style: ButtonStyle(
                //                     overlayColor: MaterialStateProperty.all(
                //                         Colors.transparent),
                //                   ),
                //                   onPressed: () => {},
                //                 ),
                //                 SizedBox(
                //                   width: 5.0,
                //                 ),
                //                 TextButton(
                //                   child: Text(
                //                     "$followersCount Followers",
                //                     style: KFollowing_FollowersStyle,
                //                   ),
                //                   style: ButtonStyle(
                //                     overlayColor: MaterialStateProperty.all(
                //                         Colors.transparent),
                //                   ),
                //                   onPressed: () => {},
                //                 ),
                //               ],
                //             ),
                //             Divider(
                //               color: KSubSecondryFontsColor,
                //               thickness: 1.0,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // );
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
