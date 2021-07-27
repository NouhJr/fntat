import 'package:flutter/material.dart';
import 'package:fntat/User_Interface/otherUsersPosts_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Components/constants.dart';

class OtherUsersProfile extends StatefulWidget {
  final userID;
  OtherUsersProfile({this.userID});
  @override
  _OtherUsersProfileState createState() => _OtherUsersProfileState(id: userID);
}

class _OtherUsersProfileState extends State<OtherUsersProfile> {
  final id;
  _OtherUsersProfileState({required this.id});

  bool isFriend = false;

  // checkFriend() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ids = prefs.getStringList("FollowingIDs");
  //   print(ids);
  //   if (ids!.contains(id.toString())) {
  //     setState(() {
  //       isFriend = true;
  //     });
  //   }
  // }

  late UserProfileBloc userProfileBloc;
  @override
  void initState() {
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingOtherUsersProfileData(userID: id));
    userProfileBloc
        .add(GettingOtherUsersFollowingAndFollowersAndPostsCount(userID: id));
    // checkFriend();
    super.initState();
  }

  var userName = '';
  var userEmail = '';
  var userPhone = '';
  var userImage = "assets/images/nouserimagehandler.jpg";

  bool useAsset = true;

  var followersCount = 0;
  var followingCount = 0;
  var postsCount = 0;

  final states =
      BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
    if (state is GettingUserProfileDataErrorState) {
      return Text(
        state.msg,
        style: KErrorStyle,
      );
    } else if (state is UserProfileLoadingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 5.0,
        ),
      );
    } else {
      return Container();
    }
  });

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
          !isFriend
              ? IconButton(
                  icon: Icon(
                    FontAwesomeIcons.userPlus,
                    color: KPrimaryColor,
                    size: 25.0,
                  ),
                  onPressed: () => {},
                )
              : Container(),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: KPrimaryColor,
              size: 25.0,
            ),
            onPressed: () => {},
          ),
        ],
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingOtherUserProfileDataSuccessState) {
            setState(() {
              userName = state.name ?? "";
              userEmail = state.email ?? "";
              userPhone = state.phone ?? "";
            });
            if (state.image != null) {
              setState(() {
                userImage = 'http://164.160.104.125:9090/fntat/${state.image}';
                useAsset = false;
              });
            }
          } else if (state
              is GettingOtherFollowingAndFollowersCountSuccessState) {
            setState(() {
              followersCount = state.followersCount ?? 0;
              followingCount = state.followingCount ?? 0;
              postsCount = state.postsCount ?? 0;
            });
          }
        },
        child: Padding(
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
                          backgroundImage: NetworkImage(userImage),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherUsersPosts(
                            userID: id,
                          ),
                        ),
                      );
                    },
                    child: Row(
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
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text("Followers", style: KFollowing_FollowersStyle),
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
                    onTap: () {},
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
              states,
            ],
          ),
        ),
      ),
    );
  }
}
