//Import necessary packages
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///*************************COLORS**************************/
const KPrimaryColor = Color(0xFF2c9448); //Color(0xFF4379e6);
const KSubPrimaryColor = Color(0xFFffffff);
const KPrimaryFontsColor = Color(0xFFffffff);
const KSubPrimaryFontsColor = Color(0xFF000000);
const KSubSecondryFontsColor = Colors.grey; //Color(0xFF8a8584);
const KSubFontsColor = Color(0xFFB2B1B9);
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
// const KPrimaryFontFamily = "Segoe UI";
const KPrimaryFontFamily = "Janna LT";

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
  color: KSubPrimaryFontsColor,
);

const KReceiverNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 22.0,
  fontWeight: FontWeight.w700,
  color: KPrimaryFontsColor,
);

const KLastSeenStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KSubFontsColor,
);

const KUserEmailStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Colors.grey,
);

const KPostTimeStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.bold,
  color: Colors.grey,
);

const KFollowing_FollowersStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w700,
  color: KSubPrimaryFontsColor,
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

const KSplashStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  color: KPrimaryColor,
  letterSpacing: 1.0,
);

const KWriteCommentAndSendMessageStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 19.0,
);

const KAddPostButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
);

const KAddPostButtonInAppBarStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KPrimaryColor,
);

const KNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 23.0,
  fontWeight: FontWeight.bold,
  color: KSubPrimaryFontsColor,
);

const KFlushBarTitleStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
);

const KFlushBarMessageStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
  color: KPrimaryFontsColor,
);

const KPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w700,
  fontSize: 20.0,
  color: KSubPrimaryFontsColor,
);

const KLikesCommentsAndSharesCount = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
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
        color: KPrimaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 25.0,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    cursorColor: KPrimaryColor,
  );
}

TextField messageTextField(TextEditingController controller) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      fillColor: KPrimaryColor,
      hintText: "Start a message",
      hintStyle: KWriteCommentAndSendMessageStyle,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
    ),
    cursorColor: KPrimaryColor,
  );
}

TextField commentTextField(TextEditingController controller) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      fillColor: KPrimaryColor,
      hintText: "Write a comment",
      hintStyle: KWriteCommentAndSendMessageStyle,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    ),
    cursorColor: KPrimaryColor,
  );
}

TextField postTextField(TextEditingController controller) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      fillColor: KPrimaryColor,
      hintText: "Write a new post...",
      hintStyle: KWriteCommentAndSendMessageStyle,
      border: InputBorder.none,
    ),
    cursorColor: KPrimaryColor,
    cursorWidth: 5.0,
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
        color: KPrimaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 25.0,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: showPassword,
    ),
    obscureText: obscure,
    cursorColor: KPrimaryColor,
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
        color: KPrimaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 25.0,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    cursorColor: KPrimaryColor,
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
