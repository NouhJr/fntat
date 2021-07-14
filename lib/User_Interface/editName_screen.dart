import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditName extends StatefulWidget {
  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  TextEditingController _newName = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KSubPrimaryColor,
        title: Text(
          "Edit Name",
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
                "Update your name",
                style: KPrimaryFontStyle,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: basicTextField(_newName, "Update Name"),
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
        onPressed: updateName,
      ),
    );
  }

  updateName() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_newName.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Name field can't be empty !",
        message: 'Please enter your name.',
        icons: Icons.warning,
      );
    }
  }
}
