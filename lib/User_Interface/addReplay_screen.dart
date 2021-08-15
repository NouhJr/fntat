import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/User_Interface/postDetails_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class AddReplay extends StatefulWidget {
  final postID;
  final commentID;
  AddReplay({this.postID, this.commentID});
  @override
  _AddReplayState createState() => _AddReplayState(pID: postID, cID: commentID);
}

class _AddReplayState extends State<AddReplay> {
  final int pID;
  final int cID;
  _AddReplayState({required this.pID, required this.cID});
  TextEditingController _replay = TextEditingController();
  bool hasImage = false;
  String image = "assets/images/nouserimagehandler.jpg";
  bool useAsset = true;
  String userName = "";

  @override
  void dispose() {
    super.dispose();
    _replay.dispose();
  }

  late UserProfileBloc userProfileBloc;

  @override
  void initState() {
    super.initState();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
  }

  final stateWidget =
      BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
    if (state is UserProfileLoadingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubSecondryFontsColor,
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
        backgroundColor: KSubPrimaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: KPrimaryColor,
            size: 30.0,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        actions: [
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
                ),
                child: Center(
                  child: InkWell(
                    onTap: addReply,
                    child: Text(
                      "Reply",
                      style: KSubPrimaryButtonsFontStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingUserProfileDataSuccessState) {
            setState(() {
              userName = state.name ?? "";
              if (state.image != null) {
                setState(() {
                  image = 'http://164.160.104.125:9090/fntat/${state.image}';
                  useAsset = false;
                });
              }
            });
          } else if (state is AddReplySuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailsScreen(
                          postID: pID,
                        )),
                (route) => false);
          }
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      useAsset
                          ? CircleAvatar(
                              backgroundImage: AssetImage(image),
                              radius: 25.0,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(image),
                              radius: 25.0,
                            ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Text(
                          userName,
                          style: KNameStyle,
                        ),
                      ),
                    ],
                  ),
                  postTextField(_replay, "Write a new reply..."),
                  SizedBox(
                    height: 25.0,
                  ),
                  stateWidget,
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  addReply() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_replay.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Reply can't be empty !",
        message: 'Please type a reply.',
        icons: Icons.warning,
      );
    } else {
      userProfileBloc.add(AddReplyButtonPressed(
          postID: pID, commentID: cID, reply: _replay.text));
    }
  }
}
