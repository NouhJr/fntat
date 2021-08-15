import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _post = TextEditingController();

  File? _image;
  bool hasImage = false;

  String image = "assets/images/nouserimagehandler.jpg";
  bool useAsset = true;

  String userName = "";

  @override
  void dispose() {
    super.dispose();
    _post.dispose();
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
                    onTap: addPost,
                    child: Text(
                      "Post",
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
          } else if (state is AddPostSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          } else if (state is SharePostSuccessState) {
            Navigator.pop(context);
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
                  postTextField(_post, "Write a new post..."),
                  SizedBox(
                    height: 25.0,
                  ),
                  hasImage
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: 190.0,
                                  height: 190.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    image: DecorationImage(
                                      image: FileImage(_image!),
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
                                        hasImage = false;
                                        _image = null;
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(),
                          ],
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  stateWidget,
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 100.0,
            height: 100.0,
            child: Card(
              elevation: 1.0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  color: KPrimaryColor,
                  size: 40.0,
                ),
                onPressed: takeImage,
              ),
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Container(
            width: 100.0,
            height: 100.0,
            child: Card(
              elevation: 1.0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: IconButton(
                icon: Icon(
                  Icons.add_photo_alternate,
                  color: KPrimaryColor,
                  size: 40.0,
                ),
                onPressed: chooseImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future chooseImage() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _image = File(pickedFile!.path);
      hasImage = true;
    });
  }

  Future takeImage() async {
    final source = ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _image = File(pickedFile!.path);
      hasImage = true;
    });
  }

  addPost() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_post.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Post can't be empty !",
        message: 'Please type a post.',
        icons: Icons.warning,
      );
    } else if (_image != null) {
      userProfileBloc
          .add(AddNewPostWithImageFired(post: _post.text, image: _image));
    } else {
      userProfileBloc.add(AddNewPostButtonPressed(post: _post.text));
    }
  }
}
