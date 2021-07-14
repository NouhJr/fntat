import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _confirmNewPassword = new TextEditingController();

  bool _obsecureNewPassword = true;
  bool _obsecureConfirmNewPassword = true;

  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  final error = BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    if (state is ResetPasswordSuccessState) {
      return Center(
        child: Text(
          state.message,
          style: KErrorStyle,
        ),
      );
    } else if (state is LodingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubSecondryFontsColor,
          color: KPrimaryColor,
        ),
      );
    } else if (state is ResetPasswordErrorState) {
      return Center(
        child: Text(
          state.message,
          style: KErrorStyle,
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
        listener: (context, state) => {},
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Reset Password",
                  style: KPrimaryFontStyle,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: passwordTextField(
                  _newPassword,
                  "New password",
                  _obsecureNewPassword,
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _obsecureNewPassword = !_obsecureNewPassword;
                      });
                    },
                    icon: Icon(_obsecureNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: passwordTextField(
                  _confirmNewPassword,
                  "Confirm password",
                  _obsecureConfirmNewPassword,
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _obsecureConfirmNewPassword =
                            !_obsecureConfirmNewPassword;
                      });
                    },
                    icon: Icon(_obsecureConfirmNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              error,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Reset password",
          style: KPrimaryButtonsFontStyle,
        ),
        isExtended: true,
        onPressed: resetPassword,
      ),
    );
  }

  Future resetPassword() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_newPassword.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "New password field can't be empty !",
        message: 'Please enter your new password.',
        icons: Icons.warning,
      );
    } else if (_confirmNewPassword.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Confirm password field can't be empty !",
        message: 'Please confirm your password.',
        icons: Icons.warning,
      );
    } else if (_newPassword.text != _confirmNewPassword.text) {
      Warning().errorMessage(
        context,
        title: "Password values doesn't match !",
        message: 'Please confirm your password.',
        icons: Icons.warning,
      );
    } else {
      authBloc.add(
        ResetPasswordButtonPressed(
            newPassword: _newPassword.text,
            confirmPassword: _confirmNewPassword.text),
      );
    }
  }
}
