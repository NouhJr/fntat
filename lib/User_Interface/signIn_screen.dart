import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _phone = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _obsecure = true;

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
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.pushNamed(context, '/SignUp'),
            },
            child: Text(
              "Sign up",
              style: KSignUpButtonInAppBarStyle,
            ),
          )
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) => {
          if (state is SignInSuccessState)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Home', (route) => false),
            }
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Sign in to " + APPNAME + ".",
                  style: KPrimaryFontStyle,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: basicTextField(_phone, "Phone"),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: passwordTextField(
                  _password,
                  "Password",
                  _obsecure,
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _obsecure = !_obsecure;
                      });
                    },
                    icon: Icon(
                        _obsecure ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: Center(
                  child: TextButton(
                      onPressed: () => {
                            Navigator.pushNamed(context, '/ResetPassword'),
                          },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: KSubSecondryFontsColor,
                          fontSize: 16.0,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              error,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Sign in",
          style: KPrimaryButtonsFontStyle,
        ),
        isExtended: true,
        onPressed: signIn,
      ),
    );
  }

  Future signIn() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
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
    } else {
      authBloc.add(
          SignInButtonPressed(phone: _phone.text, password: _password.text));
    }
  }
}
