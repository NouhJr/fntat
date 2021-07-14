import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditEmail extends StatefulWidget {
  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  TextEditingController _newEmail = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KSubPrimaryColor,
        title: Text(
          "Edit Email",
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
                "Update your email",
                style: KPrimaryFontStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: basicTextField(_newEmail, "Update Email"),
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
          "Update Name",
          style: KPrimaryButtonsFontStyle,
        ),
        isExtended: true,
        onPressed: updateEmail,
      ),
    );
  }

  updateEmail() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_newEmail.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.',
        icons: Icons.warning,
      );
    } else if (!_newEmail.text.contains('@')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '@' ",
        icons: Icons.warning,
      );
    } else if (!_newEmail.text.contains('.com')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must end with '.com' ",
        icons: Icons.warning,
      );
    }
  }
}
