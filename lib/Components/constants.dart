//Import necessary packages
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///*************************COLORS**************************/
const KPrimaryColor = Color(0xFF4379e6);
const KSubPrimaryColor = Color(0xFFffffff);
const KPrimaryFontsColor = Color(0xFFffffff);
const KSubPrimaryFontsColor = Color(0xFF000000);
const KSubSecondryFontsColor = Color(0xFF8a8584);
const KWarningColor = Color(0xFFe01709);

///*************************APPNAME**************************/
const APPNAME = "Fntat";

const AppNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KPrimaryColor,
);

///*************************FONTS**************************/
const KPrimaryFontFamily = "Segoe UI";

///*************************FONTSTYLES**************************/
const KPrimaryFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KSubPrimaryFontsColor,
);

const KPrimaryButtonsFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryFontsColor,
);

const KSignUpButtonInAppBarStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryColor,
);

const KErrorStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KSubPrimaryFontsColor,
);

const KPrimaryFontStyleLarge = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 28.0,
  color: KSubPrimaryFontsColor,
);

const KDropdownButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
);

const KTextFieldStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

const KUserNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: KPrimaryFontsColor,
);

const KUserEmailStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
);

const KFollowing_FollowersStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w700,
  color: KPrimaryFontsColor,
);

const KScreenTitlesStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: KPrimaryColor,
);

const KEditButtonsStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KSubPrimaryFontsColor,
);

const KSignOutButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KWarningColor,
);

///*************************TEXTFIELDS**************************/
TextField basicTextField(TextEditingController controller, String label) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: KPrimaryFontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 25.0,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

TextField passwordTextField(TextEditingController controller, String label,
    bool obscure, IconButton showPassword) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: KPrimaryFontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 25.0,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: showPassword,
    ),
    obscureText: obscure,
  );
}

TextField descriptionTextField(TextEditingController controller) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    maxLines: 3,
    decoration: InputDecoration(
      labelText: "Description",
      labelStyle: TextStyle(
        fontFamily: KPrimaryFontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 25.0,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

///*************************DRAWER**************************/

var drawerBoxDecoration = BoxDecoration(
    color: KPrimaryColor,
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(40.0)),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.10),
        blurRadius: 4.0,
        spreadRadius: 1.0,
        offset: Offset(
          0,
          4.0,
        ),
      )
    ]);

class ReuseableInkwell extends StatelessWidget {
  ReuseableInkwell(
      {required this.inkTitle,
      required this.onPress,
      required this.icon,
      required this.iconColor});

  final String inkTitle;
  final dynamic onPress;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: ListTile(
        title: Text(
          inkTitle,
          style: TextStyle(
            fontFamily: KPrimaryFontFamily,
            fontSize: 20,
            color: KSubPrimaryFontsColor,
          ),
        ),
        leading: Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }
}
