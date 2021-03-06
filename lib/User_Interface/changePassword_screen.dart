import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmNewPassword = TextEditingController();

  bool _obsecureOldPassword = true;
  bool _obsecureNewPassword = true;
  bool _obsecureConfirmNewPassword = true;

  late UserProfileBloc userbloc;

  @override
  void initState() {
    userbloc = BlocProvider.of<UserProfileBloc>(context);
    super.initState();
  }

  final stateWidget =
      BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
    if (state is ChangePasswordErrorState) {
      return Text(
        state.message,
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
  });

  final changePasswordSuccessSnackBar = SnackBar(
    content: Text(
      "Password updated successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KSubPrimaryColor,
        title: Text(
          "Edit Password",
          style: KScreenTitlesStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KPrimaryColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
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
                    onTap: updatePassword,
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
          if (state is ChangePasswordSuccessState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(changePasswordSuccessSnackBar);
          }
        },
        child: kIsWeb
            ? Center(
                child: Container(
                  width: 435.0,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Change your password",
                          style: KPrimaryFontStyle,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: passwordTextField(
                          _oldPassword,
                          "Old Password",
                          _obsecureOldPassword,
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obsecureOldPassword = !_obsecureOldPassword;
                              });
                            },
                            icon: Icon(_obsecureOldPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: passwordTextField(
                          _newPassword,
                          "New Password",
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
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: passwordTextField(
                          _confirmNewPassword,
                          "Confirm Password",
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
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      stateWidget,
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Change your password",
                        style: KPrimaryFontStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: passwordTextField(
                        _oldPassword,
                        "Old Password",
                        _obsecureOldPassword,
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _obsecureOldPassword = !_obsecureOldPassword;
                            });
                          },
                          icon: Icon(_obsecureOldPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: KPrimaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: passwordTextField(
                        _newPassword,
                        "New Password",
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
                          color: KPrimaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: passwordTextField(
                        _confirmNewPassword,
                        "Confirm Password",
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
                          color: KPrimaryColor,
                        ),
                      ),
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

  updatePassword() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_oldPassword.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Old password field can't be empty !",
        message: 'Please enter your old password.',
        icons: Icons.warning,
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
        message: 'Please confirm your new password.',
        icons: Icons.warning,
      );
    } else if (_newPassword.text != _confirmNewPassword.text) {
      Warning().errorMessage(
        context,
        title: "Password values doesn't match !",
        message: 'Please confirm your new password.',
        icons: Icons.warning,
      );
    } else {
      userbloc.add(ChangePasswordButtonPressed(
        oldPassword: _oldPassword.text,
        newPassword: _newPassword.text,
        confirmNewPassword: _confirmNewPassword.text,
      ));
    }
  }
}
