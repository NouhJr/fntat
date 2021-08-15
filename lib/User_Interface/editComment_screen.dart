import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditComment extends StatefulWidget {
  final commentID;
  final comment;
  EditComment({this.commentID, this.comment});
  @override
  _EditCommentState createState() => _EditCommentState(
        commID: commentID,
        comm: comment,
      );
}

class _EditCommentState extends State<EditComment> {
  final commID;
  final comm;
  _EditCommentState({
    required this.commID,
    required this.comm,
  });
  TextEditingController _comment = TextEditingController();

  String image = "assets/images/nouserimagehandler.jpg";
  bool useAsset = true;

  String userName = "";

  @override
  void dispose() {
    super.dispose();
    _comment.dispose();
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
                    onTap: editComment,
                    child: Text(
                      "Save",
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
          } else if (state is EditCommentSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          }
        },
        child: userName != ""
            ? Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Column(
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
                        postTextField(_comment, "Write a new post..."),
                        SizedBox(
                          height: 25.0,
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 1.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    useAsset
                                        ? CircleAvatar(
                                            backgroundImage: AssetImage(
                                              image,
                                            ),
                                            radius: 20.0,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              image,
                                            ),
                                            radius: 20.0,
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
                                            style: KNameInSubPostStyle,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            comm,
                                            style: KSubPostStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        stateWidget,
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: KSubPrimaryColor,
                  color: KPrimaryColor,
                  strokeWidth: 5.0,
                ),
              ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  editComment() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_comment.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Comment can't be empty !",
        message: 'Please type a comment.',
        icons: Icons.warning,
      );
    } else {
      userProfileBloc.add(
        EditCommentButtonPressed(comment: _comment.text, commentID: commID),
      );
    }
  }
}
