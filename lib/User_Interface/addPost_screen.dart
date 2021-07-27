import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _post = TextEditingController();

  late File? _image;
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
    if (state is AddPostSuccessState) {
      return Text(
        "Post add successfully",
        style: KErrorStyle,
      );
    } else if (state is AddPostErrorState) {
      return Text(
        "Faild to add post",
        style: KErrorStyle,
      );
    } else if (state is UserProfileLoadingState) {
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
            Icons.arrow_back_ios_new,
            color: KPrimaryColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        title: Text(
          "Add new post",
          style: AppNameStyle,
        ),
        actions: [
          Row(
            children: [
              Container(
                width: 100.0,
                child: ButtonTheme(
                  minWidth: double.infinity,
                  height: 10.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(KPrimaryColor),
                      elevation: MaterialStateProperty.all(
                        1.0,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Post",
                      style: KPrimaryButtonsFontStyle,
                    ),
                    onPressed: addPost,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
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
          }
        },
        child: Padding(
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
              postTextField(_post),
              SizedBox(
                height: 25.0,
              ),
              hasImage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          width: 240.0,
                          height: 240.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Image.file(_image!),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(),
                      ],
                    ),
              stateWidget,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: chooseFile,
        child: Icon(
          Icons.add_photo_alternate,
          size: 30.0,
          color: KSubPrimaryColor,
        ),
        backgroundColor: KPrimaryColor,
      ),
    );
  }

  Future chooseFile() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = File(pickedFile.path);
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
