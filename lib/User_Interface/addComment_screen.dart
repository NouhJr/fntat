import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class AddComment extends StatefulWidget {
  final postID;
  AddComment({this.postID});
  @override
  _AddCommentState createState() => _AddCommentState(pID: postID);
}

class _AddCommentState extends State<AddComment> {
  final pID;
  _AddCommentState({required this.pID});
  TextEditingController _comment = TextEditingController();
  bool hasImage = false;
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
                width: 110.0,
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
                    onTap: addComment,
                    child: Text(
                      "Comment",
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
                  image = '$ImageServerPrefix/${state.image}';
                  useAsset = false;
                });
              }
            });
          } else if (state is AddCommentSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
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
                  postTextField(_comment, "Write a new comment..."),
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

  addComment() async {
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
      userProfileBloc
          .add(AddCommentButtonPressed(postID: pID, comment: _comment.text));
    }
  }
}
