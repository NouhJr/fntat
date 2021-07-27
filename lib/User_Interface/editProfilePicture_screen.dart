import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditProfilePicture extends StatefulWidget {
  @override
  _EditProfilePictureState createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  late File _image;

  late UserProfileBloc userbloc;

  @override
  void initState() {
    super.initState();
    userbloc = BlocProvider.of<UserProfileBloc>(context);
  }

  final stateWidget =
      BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
    if (state is UpdatePictureSuccessState) {
      return Text(
        state.message,
        style: KErrorStyle,
      );
    } else if (state is UpdatePictureErrorState) {
      return Text(
        state.message,
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
          "Edit Picture",
          style: KScreenTitlesStyle,
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
                      "Save",
                      style: KPrimaryButtonsFontStyle,
                    ),
                    onPressed: updatePicture,
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
        listener: (context, state) {},
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              Container(
                child: Text(
                  "Update your picture",
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
                    width: 20.0,
                  ),
                  Container(
                    width: 150.0,
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 20.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(KPrimaryColor),
                          elevation: MaterialStateProperty.all(
                            1.0,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Pick image",
                          style: KPrimaryButtonsFontStyle,
                        ),
                        onPressed: chooseFile,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              stateWidget,
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text(
      //     "Update picture",
      //     style: KPrimaryButtonsFontStyle,
      //   ),
      //   backgroundColor: KPrimaryColor,
      //   isExtended: true,
      //   onPressed: updatePicture,
      // ),
    );
  }

  Future chooseFile() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  updatePicture() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_image == null) {
      Warning().errorMessage(
        context,
        title: "Picture can't be empty !",
        message: 'Please choose picture.',
        icons: Icons.warning,
      );
    } else {
      userbloc.add(EditPictureButtonPressed(newPicture: _image));
    }
  }
}
