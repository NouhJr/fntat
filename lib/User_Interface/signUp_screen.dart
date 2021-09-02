import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;
  late File profilePicture;
  late File coverPhoto;
  bool hasProfilePicture = false;
  bool hasCoverPhoto = false;
  late AuthBloc authBloc;
  List<String> profilePictureOptions = [
    'Profile Picture',
    'Take photo',
    'Choose existing photo'
  ];
  String _selectedProfilePictureOption = "Profile Picture";
  List<String> coverPhotoOptions = [
    'Cover Photo',
    'Take photo',
    'Choose existing photo'
  ];
  String _selectedCoverPhotoOption = "Cover Photo";
  String birthDate = 'Select your Birth date';
  var age;
  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
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
        style: KSubErrorStyle,
        textAlign: TextAlign.center,
      );
    } else if (state is LodingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KPrimaryColor,
          color: KSubPrimaryColor,
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) => {
          if (state is SignUpsuccessState)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Home', (route) => false),
            }
        },
        child: Stack(
          children: [
            Container(
              child: Image(
                image: AssetImage("assets/images/10839772.jpg"),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            ListView(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: KPrimaryColor.withOpacity(0.5),
                  ),
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Register now and meet awesome people around the world",
                          style: KSubPrimaryFontStyleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: basicTextField(_name, "Enter name"),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: basicTextField(_email, "Enter email"),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: basicTextField(_phone, "Enter phone"),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: KSubPrimaryColor,
                          border: Border.all(
                            width: 1.0,
                            color: KSubPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            selectDate(context);
                          },
                          child: DropdownButton<dynamic>(
                            items: [],
                            icon: Icon(
                              Icons.date_range,
                              color: KPrimaryColor,
                            ),
                            iconSize: 25.0,
                            style: KDropdownButtonStyle,
                            underline: Container(
                              width: 0.0,
                            ),
                            isExpanded: true,
                            hint: Text(birthDate),
                            onChanged: (newValuex) {},
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: passwordTextField(
                          _password,
                          "Enter password",
                          _obsecurePassword,
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obsecurePassword = !_obsecurePassword;
                              });
                            },
                            icon: Icon(
                              _obsecurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 25.0,
                            ),
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: passwordTextField(
                          _confirmPassword,
                          "Confirm password",
                          _obsecureConfirmPassword,
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obsecureConfirmPassword =
                                    !_obsecureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obsecureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 25.0,
                            ),
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 185.0,
                            height: 45.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: KSubPrimaryColor,
                              border: Border.all(
                                width: 1.0,
                                color: KSubPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            child: DropdownButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                color: KPrimaryColor,
                              ),
                              iconSize: 25.0,
                              style: KDropdownButtonStyle,
                              underline: Container(
                                width: 0.0,
                              ),
                              isExpanded: true,
                              hint: Text('Profile Picture'),
                              value: _selectedProfilePictureOption,
                              onChanged: (newValueOne) {
                                setState(() {
                                  _selectedProfilePictureOption =
                                      newValueOne.toString();
                                });
                                checkForProfile();
                              },
                              items: profilePictureOptions.map((profileOption) {
                                return DropdownMenuItem(
                                  child: Text(profileOption),
                                  value: profileOption,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            width: 170.0,
                            height: 45.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: KSubPrimaryColor,
                              border: Border.all(
                                width: 1.0,
                                color: KSubPrimaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            child: DropdownButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                color: KPrimaryColor,
                              ),
                              iconSize: 25.0,
                              style: KDropdownButtonStyle,
                              underline: Container(
                                width: 0.0,
                              ),
                              isExpanded: true,
                              hint: Text('Cover Photo'),
                              value: _selectedCoverPhotoOption,
                              onChanged: (newValueTwo) {
                                setState(() {
                                  _selectedCoverPhotoOption =
                                      newValueTwo.toString();
                                });
                                checkForCover();
                              },
                              items: coverPhotoOptions.map((coverOption) {
                                return DropdownMenuItem(
                                  child: Text(coverOption),
                                  value: coverOption,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          hasProfilePicture
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          width: 170.0,
                                          height: 170.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            image: DecorationImage(
                                              image: FileImage(profilePicture),
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
                                                hasProfilePicture = false;
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
                              : Container(),
                          SizedBox(
                            width: 20.0,
                          ),
                          hasCoverPhoto
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          width: 170.0,
                                          height: 170.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            image: DecorationImage(
                                              image: FileImage(coverPhoto),
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
                                                hasCoverPhoto = false;
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
                              : Container()
                        ],
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        width: 150.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: KSubPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              signUp();
                            },
                            child: Text(
                              "Register",
                              style: KSubSubPrimaryButtonsFontStyle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      error,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(2021),
      firstDate: DateTime(1980),
      lastDate: DateTime(2080),
      helpText: "Select your birth date",
    );
    if (selected != null) {
      setState(() {
        birthDate = '${selected.year}-${selected.month}-${selected.day}';
      });
    }
  }

  checkForProfile() {
    if (_selectedProfilePictureOption == "Choose existing photo") {
      chooseFileForProfile();
    } else if (_selectedProfilePictureOption == "Take photo") {
      takeImageForProfile();
    }
  }

  Future chooseFileForProfile() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      profilePicture = File(pickedFile!.path);
      hasProfilePicture = true;
    });
  }

  Future takeImageForProfile() async {
    final source = ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      profilePicture = File(pickedFile!.path);
      hasProfilePicture = true;
    });
  }

  checkForCover() {
    if (_selectedProfilePictureOption == "Choose existing photo") {
      chooseFileForCover();
    } else if (_selectedProfilePictureOption == "Take photo") {
      takeImageForCover();
    }
  }

  Future chooseFileForCover() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      coverPhoto = File(pickedFile!.path);
      hasCoverPhoto = true;
    });
  }

  Future takeImageForCover() async {
    final source = ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      coverPhoto = File(pickedFile!.path);
      hasCoverPhoto = true;
    });
  }

  Future signUp() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Please turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_name.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Name field can't be empty !",
        message: "Please enter your name.",
        icons: Icons.warning,
      );
    } else if (_email.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: "Please enter your email.",
        icons: Icons.warning,
      );
    } else if (!_email.text.contains('@')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '@' ",
        icons: Icons.warning,
      );
    } else if (_phone.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Phone field can't be empty !",
        message: "Please enter your phone.",
        icons: Icons.warning,
      );
    } else if (_password.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Password field can't be empty !",
        message: "Please enter your password.",
        icons: Icons.warning,
      );
    } else if (_confirmPassword.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "ConfirmPassword field can't be empty !",
        message: "Please confirm your password.",
        icons: Icons.warning,
      );
    } else if (_password.text != _confirmPassword.text) {
      Warning().errorMessage(
        context,
        title: "Password values doesn't match !",
        message: "Please confirm your password.",
        icons: Icons.warning,
      );
    } else if (hasProfilePicture != true) {
      Warning().errorMessage(
        context,
        title: "Profile picture can't be empty !",
        message: "Please take or choose profile picture",
        icons: Icons.warning,
      );
    } else if (hasCoverPhoto != true) {
      Warning().errorMessage(
        context,
        title: "Cover photo can't be empty !",
        message: "Please take or choose cover photo",
        icons: Icons.warning,
      );
    } else {
      authBloc.add(SignUpButtonPressed(
        name: _name.text,
        email: _email.text,
        phone: _phone.text,
        password: _password.text,
        passwordConfirmation: _confirmPassword.text,
        birthDate: birthDate,
        profilePicture: profilePicture,
        coverPhoto: coverPhoto,
      ));
    }
  }
}
