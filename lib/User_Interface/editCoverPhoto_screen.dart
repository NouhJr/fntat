import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditCoverPhoto extends StatefulWidget {
  @override
  _EditCoverPhotoState createState() => _EditCoverPhotoState();
}

class _EditCoverPhotoState extends State<EditCoverPhoto> {
  bool hasImage = false;
  late File _image;
  late UserProfileBloc userbloc;

  late List<int> coverBytes;
  late Uint8List coverBytesData;
  String coverNameWeb = '';
  bool hasCoverWeb = false;

  @override
  void initState() {
    super.initState();
    userbloc = BlocProvider.of<UserProfileBloc>(context);
  }

  final stateWidget = BlocBuilder<UserProfileBloc, UserProfileState>(
    builder: (context, state) {
      if (state is UpdateCoverPhotoErrorState) {
        return Text(
          'Failed to update cover photo',
          style: KErrorStyle,
        );
      } else if (state is UserProfileLoadingState) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: KSubPrimaryColor,
            color: KPrimaryColor,
            strokeWidth: 3.0,
          ),
        );
      } else {
        return Container();
      }
    },
  );

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
          "Edit Cover Photo",
          style: KScreenTitlesStyle,
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
                    onTap: () {
                      updateCover();
                    },
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
          if (state is UpdateCoverPhotoSuccessState) {
            Navigator.pop(context);
          }
        },
        child: kIsWeb
            ? Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Text(
                        "Update your cover photo",
                        style: KPrimaryFontStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Picture:",
                          style: KTextFieldStyle,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        IconButton(
                          onPressed: () {
                            pickCoverPhotoForWeb();
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: KPrimaryColor,
                          ),
                          iconSize: 30.0,
                        ),
                      ],
                    ),
                    hasCoverWeb
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    width: 350.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      image: DecorationImage(
                                        image: MemoryImage(
                                          coverBytesData,
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
                                          hasCoverWeb = false;
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
                      height: 20.0,
                    ),
                    stateWidget,
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Text(
                        "Update your cover photo",
                        style: KPrimaryFontStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Picture:",
                          style: KTextFieldStyle,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        PopupMenuButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            color: KPrimaryColor,
                          ),
                          iconSize: 30.0,
                          onSelected: imageOptions,
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
                        ),
                      ],
                    ),
                    hasImage
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    width: 350.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      image: DecorationImage(
                                        image: FileImage(_image),
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
                      height: 20.0,
                    ),
                    stateWidget,
                  ],
                ),
              ),
      ),
    );
  }

  List<String> options = ['Take photo', 'Choose existing photo'];
  imageOptions(String option) {
    if (option == options[0]) {
      takeImage();
    } else if (option == options[1]) {
      chooseFile();
    }
  }

  Future chooseFile() async {
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

  void pickCoverPhotoForWeb() async {
    FilePickerResult? coverPhotWeb;
    coverPhotWeb = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (coverPhotWeb != null) {
      setState(() {
        coverNameWeb = coverPhotWeb!.files.single.name;
        coverBytesData = coverPhotWeb.files.single.bytes!;
        hasCoverWeb = true;
        coverBytes = coverBytesData.cast();
      });
    }
  }

  updateCover() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Please turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else {
      if (kIsWeb) {
        if (hasCoverWeb == false) {
          Warning().errorMessage(
            context,
            title: "No photo is selected !",
            message: 'Please choose a photo.',
            icons: Icons.warning,
          );
        } else {
          userbloc.add(
            EditCoverPhotoButtonPressedWeb(
              newPhoto: coverBytes,
              newPhotoName: coverNameWeb,
            ),
          );
        }
      } else {
        if (hasImage == false) {
          Warning().errorMessage(
            context,
            title: "No photo is selected !",
            message: 'Please choose or take a photo.',
            icons: Icons.warning,
          );
        } else {
          userbloc.add(
            EditCoverPhotoButtonPressed(newPhoto: _image),
          );
        }
      }
    }
  }
}
