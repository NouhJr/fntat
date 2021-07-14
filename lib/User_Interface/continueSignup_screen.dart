import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
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

  late File _image;

  late AuthBloc authBloc;

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
                      "Create your account",
                      style: KPrimaryFontStyleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: descriptionTextField(_description),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Image",
                        style: KTextFieldStyle,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        width: 150.0,
                        child: ButtonTheme(
                          minWidth: double.infinity,
                          height: 30.0,
                          buttonColor: KPrimaryColor,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(
                                1.0,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
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
                    height: 20.0,
                  ),
                  Container(
                    width: 150.0,
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 70.0,
                      buttonColor: KPrimaryColor,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(
                            1.0,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Sign up",
                          style: KPrimaryButtonsFontStyle,
                        ),
                        onPressed: signUp,
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

  Future chooseFile() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile == null) {
      return null;
    } else {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void signUp() {
    authBloc.add(SignUpButtonPressed(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
      type: type,
      category: category,
      image: _image,
      description: _description.text,
    ));
  }
}
