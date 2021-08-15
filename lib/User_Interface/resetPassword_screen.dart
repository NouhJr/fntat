import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class ResetPassword extends StatefulWidget {
  final userID;
  ResetPassword({this.userID});
  @override
  _ResetPasswordState createState() => _ResetPasswordState(id: userID);
}

class _ResetPasswordState extends State<ResetPassword> {
  final id;
  _ResetPasswordState({required this.id});

  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _confirmNewPassword = new TextEditingController();

  bool _obsecureNewPassword = true;
  bool _obsecureConfirmNewPassword = true;

  late AuthBloc authBloc;
  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _newPassword.dispose();
    _confirmNewPassword.dispose();
  }

  final error = BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    if (state is LodingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 3.0,
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

  final resetPasswordSuccessSnackBar = SnackBar(
    content: Text(
      "Password reset successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

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
            Navigator.pushNamed(context, '/SignIn'),
          },
        ),
        backgroundColor: KSubPrimaryColor,
        title: Text(
          APPNAME,
          style: AppNameStyle,
        ),
        centerTitle: true,
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
                    onTap: resetPassword,
                    child: Text(
                      "Reset",
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(resetPasswordSuccessSnackBar);
          }
        },
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
                    icon: Icon(
                      _obsecureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: KPrimaryColor,
                    ),
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
                    icon: Icon(
                      _obsecureConfirmNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: KPrimaryColor,
                    ),
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
            confirmPassword: _confirmNewPassword.text,
            userID: id),
      );
    }
  }
}
