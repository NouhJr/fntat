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
  late File _image;
  bool hasImage = false;
  late AuthBloc authBloc;

  List<String> _types = [
    'Type',
    'admin',
    'هاوي',
    'محترف',
    'وكيل',
    'اكاديميه',
    'نادي'
  ];
  String _selectedType = "Type";

  List<String> _category = ['Category', 'كره القدم', 'كره السله'];
  String _selectedCategory = "Category";

  List<String> options = ['Image', 'Take photo', 'Choose existing photo'];
  String _selectedOption = "Image";

  int type = 0;
  int category = 0;

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
                width:
                    // 1080.0,
                    double.infinity,
                height:
                    // 2280.0,
                    double.infinity,
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
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Signup now and meet awesome people around the world",
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
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: KSubPrimaryColor,
                          border: Border.all(
                            color: KSubPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                        child: DropdownButton(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: KPrimaryColor,
                          ),
                          iconSize: 25.0,
                          style: KDropdownButtonStyle,
                          underline: Container(
                            width: 0.0,
                          ),
                          isExpanded: true,
                          hint: Text('Type'),
                          value: _selectedType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedType = newValue.toString();
                            });
                          },
                          items: _types.map((type) {
                            return DropdownMenuItem(
                              child: Text(type),
                              value: type,
                            );
                          }).toList(),
                        ),
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
                            color: KSubPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                        child: DropdownButton(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: KPrimaryColor,
                          ),
                          iconSize: 25.0,
                          style: KDropdownButtonStyle,
                          underline: Container(
                            width: 0.0,
                          ),
                          isExpanded: true,
                          hint: Text('Category'),
                          value: _selectedCategory,
                          onChanged: (newValuex) {
                            setState(() {
                              _selectedCategory = newValuex.toString();
                            });
                          },
                          items: _category.map((category) {
                            return DropdownMenuItem(
                              child: Text(category),
                              value: category,
                            );
                          }).toList(),
                        ),
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
                            color: KSubPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
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
                          hint: Text('Image'),
                          value: _selectedOption,
                          onChanged: (newValuex) {
                            setState(() {
                              _selectedOption = newValuex.toString();
                            });
                            check();
                          },
                          items: options.map((option) {
                            return DropdownMenuItem(
                              child: Text(option),
                              value: option,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      hasImage
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      width: 190.0,
                                      height: 190.0,
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

  check() {
    if (_selectedOption == "Choose existing photo") {
      chooseFile();
    } else if (_selectedOption == "Take photo") {
      takeImage();
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

  Future signUp() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_name.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Name field can't be empty !",
        message: 'Please enter your name.',
        icons: Icons.warning,
      );
    } else if (_email.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.',
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
        message: 'Please enter your phone.',
        icons: Icons.warning,
      );
    } else if (_password.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Password field can't be empty !",
        message: 'Please enter your password.',
        icons: Icons.warning,
      );
    } else if (_confirmPassword.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "ConfirmPassword field can't be empty !",
        message: 'Please confirm your password.',
        icons: Icons.warning,
      );
    } else if (_password.text != _confirmPassword.text) {
      Warning().errorMessage(
        context,
        title: "Password values doesn't match !",
        message: 'Please confirm your password.',
        icons: Icons.warning,
      );
    } else if (_selectedType == "Type") {
      Warning().errorMessage(
        context,
        title: "Type can't be empty !",
        message: 'Please choose a type.',
        icons: Icons.warning,
      );
    } else if (_selectedCategory == "Category") {
      Warning().errorMessage(
        context,
        title: "Category can't be empty !",
        message: 'Please choose a category.',
        icons: Icons.warning,
      );
    } else if (hasImage != true) {
      Warning().errorMessage(
        context,
        title: "Image can't be empty !",
        message: 'Please take or choose image',
        icons: Icons.warning,
      );
    } else {
      if (_selectedType == 'admin') {
        setState(() {
          type = 1;
        });
      } else if (_selectedType == 'هاوي') {
        setState(() {
          type = 2;
        });
      } else if (_selectedType == 'محترف') {
        setState(() {
          type = 3;
        });
      } else if (_selectedType == 'وكيل') {
        setState(() {
          type = 4;
        });
      } else if (_selectedType == 'اكاديميه') {
        setState(() {
          type = 5;
        });
      } else if (_selectedType == 'نادي') {
        setState(() {
          type = 6;
        });
      } else if (_selectedCategory == 'كره السله') {
        setState(() {
          category = 2;
        });
      } else if (_selectedCategory == 'كره القدم') {
        setState(() {
          category = 1;
        });
      }
      authBloc.add(SignUpButtonPressed(
        name: _name.text,
        email: _email.text,
        phone: _phone.text,
        password: _password.text,
        passwordConfirmation: _confirmPassword.text,
        type: type,
        category: category,
        image: _image,
      ));
    }
  }
}
