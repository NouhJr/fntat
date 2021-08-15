import 'dart:ffi';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';
import 'package:image_picker/image_picker.dart';

class ContinueSignUp extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final int type;
  final int category;
  ContinueSignUp(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.passwordConfirmation,
      required this.type,
      required this.category});
  @override
  _ContinueSignUpState createState() => _ContinueSignUpState(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        type: type,
        category: category,
      );
}

class _ContinueSignUpState extends State<ContinueSignUp> {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final int type;
  final int category;
  _ContinueSignUpState(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.passwordConfirmation,
      required this.type,
      required this.category});

  TextEditingController _description = TextEditingController();

  bool hasImage = false;
  late File _image;

  late AuthBloc authBloc;

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  final error = BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    if (state is AuthenticationErrorState) {
      return Text(
        state.message,
        style: KErrorStyle,
      );
    } else if (state is LodingState) {
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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
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
        backgroundColor: KSubPrimaryColor,
        title: Text(
          APPNAME,
          style: AppNameStyle,
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) => {
          if (state is SignUpsuccessState)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Home', (route) => false),
            }
        },
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Finish your account",
                      style: KPrimaryFontStyleLarge,
                    ),
                  ),
                  // SizedBox(
                  //   height: 5.0,
                  // ),
                  // Container(
                  //   child: descriptionTextField(_description),
                  // ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Image:",
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
                                  width: 190.0,
                                  height: 190.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
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
                  Center(
                    child: Container(
                      width: 150.0,
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
                          onTap: signUp,
                          child: Text(
                            "Sign up",
                            style: KPrimaryButtonsFontStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  error
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
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

  void signUp() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (hasImage != true) {
      Warning().errorMessage(
        context,
        title: "Image can't be empty !",
        message: 'Please take or choose image',
        icons: Icons.warning,
      );
    } else {
      authBloc.add(SignUpButtonPressed(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        type: type,
        category: category,
        image: _image,
      ));
    }
  }
}
