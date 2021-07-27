import 'package:flutter/material.dart';
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
  String noUserImage = "assets/images/nouserimagehandler.jpg";
  bool useAsset = true;

  late UserProfileBloc userProfileBloc;
  @override
  void initState() {
    super.initState();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
    userProfileBloc.add(GettingFollowingAndFollowersAndPostsCount());
  }

  Future<void> getDataOnRefresh() async {
    userProfileBloc.add(GettingUserProfileData());
    userProfileBloc.add(GettingFollowingAndFollowersAndPostsCount());
  }

  var userName = '';
  var userEmail = '';
  var userPhone = '';
  var userImage = "assets/images/nouserimagehandler.jpg";

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
          IconButton(
            icon: Icon(
              Icons.settings,
              color: KPrimaryColor,
              size: 30.0,
            ),
            onPressed: () => {
              Navigator.pushNamed(context, '/Settings'),
            },
          ),
        ],
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingUserProfileDataSuccessState) {
            setState(() {
              userName = state.name ?? "";
              userEmail = state.email ?? "";
              userPhone = state.phone ?? "";
              if (state.image != null) {
                setState(() {
                  userImage =
                      'http://164.160.104.125:9090/fntat/${state.image}';
                  useAsset = false;
                });
              }
            });
          } else if (state is GettingFollowingAndFollowersCountSuccessState) {
            setState(() {
              followersCount = state.followersCount ?? 0;
              followingCount = state.followingCount ?? 0;
              postsCount = state.postsCount ?? 0;
            });
          }
        },
        child: RefreshIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 3.0,
          child: ListView(
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
                            Navigator.pushNamed(context, '/MyPosts');
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
                          onTap: () {
                            Navigator.pushNamed(context, '/MyFollowers');
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
                    states,
                  ],
                ),
              ),
            ],
          ),
          onRefresh: getDataOnRefresh,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
