import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
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
      ),
      body: Padding(
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
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            //stateWidget,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Update Password",
          style: KPrimaryButtonsFontStyle,
        ),
        isExtended: true,
        onPressed: updatePassword,
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
    }
  }
}
