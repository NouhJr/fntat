//Import necessary packages
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///*************************COLORS**************************/
const KPrimaryColor = Color(0xFF2c9448); //Color(0xFF4379e6);
const KSubPrimaryColor = Color(0xFFffffff);
const KPrimaryFontsColor = Color(0xFFffffff);
const KSubPrimaryFontsColor = Color(0xFF000000);
const KSubSecondryFontsColor = Color(0xFF66696e);
const KSubFontsColor = Color(0xFFB2B1B9);
const KWarningColor = Color(0xFFe01709);
const KHeaderColor = Color(0xFF2a4158);

///*************************APPNAME**************************/
const APPNAME = "Fntat";

const AppNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KPrimaryColor,
);

///*************************SERVERURL**************************/
const ServerUrl = "http://164.160.104.133:9090/fntat/api";
const ImageServerPrefix = "http://164.160.104.133:9090/fntat";

///*************************FONTS**************************/
// const KPrimaryFontFamily = "Segoe UI";
const KPrimaryFontFamily = "Janna LT";

///*************************FONTSTYLES**************************/
const KPrimaryFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KPrimaryButtonsFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryColor,
  // color: KPrimaryFontsColor,
  height: 1.3,
);

const KSubSubPrimaryButtonsFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KSubPrimaryButtonsFontStyle2 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KSubPrimaryButtonsFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 19.0,
  color: KPrimaryColor,
  height: 1.3,
);

const KSignUpButtonInAppBarStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryColor,
  height: 1.3,
);

const KErrorStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KSubErrorStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KPrimaryFontStyleLarge = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 28.0,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KSubPrimaryFontStyleLarge = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 28.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KDropdownButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.3,
);

const KTextFieldStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  height: 1.3,
);

const KUserNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KReceiverNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 22.0,
  fontWeight: FontWeight.w700,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KLastSeenStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KSubFontsColor,
  height: 1.3,
);

const KUserEmailStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.3,
);

const KPostTimeStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.3,
);

const KPostTimeInSubPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.3,
);

const KFollowing_FollowersStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w700,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KScreenTitlesStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: KPrimaryColor,
  height: 1.3,
);

const KEditButtonsStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KSignOutButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KWarningColor,
  height: 1.3,
);

const KSplashStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  color: KPrimaryColor,
  letterSpacing: 1.0,
  height: 1.3,
);

const KWriteCommentAndSendMessageStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 19.0,
  height: 1.3,
);

const KAddPostButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KAddPostButtonInAppBarStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KPrimaryColor,
  height: 1.3,
);

const KNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 21.0,
  fontWeight: FontWeight.bold,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KNameInHeaderStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 23.0,
  fontWeight: FontWeight.bold,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KEmailInHeaderStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KSearchLabelStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KNameInSubPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KFlushBarTitleStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KFlushBarMessageStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 18.0,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KSubPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 15.0,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KLikesCommentsAndSharesCount = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  height: 1.3,
  color: KSubSecondryFontsColor,
);

const KSnackBarContentStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
  height: 1.3,
);

const KPostOptionsStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
  color: KSubPrimaryFontsColor,
  height: 1.3,
);

const KCategoryButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19,
  color: KSubPrimaryFontsColor,
);

///*************************TEXTFIELDS**************************/
TextField basicTextField(TextEditingController controller, String hint) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
        borderRadius: BorderRadius.circular(40.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
        borderRadius: BorderRadius.circular(40.0),
      ),
      filled: true,
      fillColor: KSubPrimaryColor,
      hintText: hint,
      hintStyle: KWriteCommentAndSendMessageStyle,
      // TextStyle(
      //   fontFamily: KPrimaryFontFamily,
      //   color: KPrimaryColor,
      //   fontWeight: FontWeight.w600,
      //   fontSize: 20.0,
      // ),
      // border: UnderlineInputBorder(
      //   borderSide: BorderSide(color: KPrimaryColor),
      // ),
      // floatingLabelBehavior: FloatingLabelBehavior.always,
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

TextField commentTextField(TextEditingController controller, String hint) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
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

TextField postTextField(TextEditingController controller, String hint) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      fillColor: KPrimaryColor,
      hintText: hint,
      hintStyle: KWriteCommentAndSendMessageStyle,
      border: InputBorder.none,
    ),
    cursorColor: KPrimaryColor,
    cursorWidth: 5.0,
  );
}

TextField passwordTextField(TextEditingController controller, String hint,
    bool obscure, IconButton showPassword) {
  return TextField(
    style: KTextFieldStyle,
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
        borderRadius: BorderRadius.circular(40.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: KPrimaryColor),
        borderRadius: BorderRadius.circular(40.0),
      ),
      filled: true,
      fillColor: KSubPrimaryColor,
      hintText: hint,
      hintStyle: KWriteCommentAndSendMessageStyle,
      // TextStyle(
      //   fontFamily: KPrimaryFontFamily,
      //   color: KPrimaryColor,
      //   fontWeight: FontWeight.w700,
      //   fontSize: 25.0,
      // ),
      // enabledBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: KPrimaryColor),
      // ),
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: KPrimaryColor),
      // ),
      // border: UnderlineInputBorder(
      //   borderSide: BorderSide(color: KPrimaryColor),
      // ),
      // floatingLabelBehavior: FloatingLabelBehavior.always,
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
      this.onPress,
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
