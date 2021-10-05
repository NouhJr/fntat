//Import necessary packages
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///*************************COLORS**************************/
const KPrimaryColor = Color(0xFF2c9448);
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
const KPrimaryFontFamily = "Segoe UI";
// const KPrimaryFontFamily = "Janna LT";

///*************************FONTSTYLES**************************/
const KPrimaryFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KPrimaryButtonsFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryColor,
  // color: KPrimaryFontsColor,
  height: 1.0,
);

const KSubSubPrimaryButtonsFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KSubPrimaryButtonsFontStyle2 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KSubPrimaryButtonsFontStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 19.0,
  color: KPrimaryColor,
  height: 1.0,
);

const KSubPrimaryButtonsFontStyle3 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w700,
  fontSize: 18.0,
  color: KPrimaryColor,
  height: 1.0,
);

const KSignUpButtonInAppBarStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryColor,
  height: 1.0,
);

const KErrorStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KSubErrorStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KPrimaryFontStyleLarge = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 28.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KSubPrimaryFontStyleLarge = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 28.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KDropdownButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.0,
);

const KTextFieldStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  height: 1.0,
);

const KUserNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KReceiverNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 22.0,
  fontWeight: FontWeight.w700,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KLastSeenStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KSubFontsColor,
  height: 1.0,
);

const KUserEmailStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.0,
);

const KPostTimeStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 17.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.0,
);

const KPostTimeInSubPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: KSubSecondryFontsColor,
  height: 1.0,
);

const KFollowing_FollowersStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w700,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KScreenTitlesStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: KPrimaryColor,
  height: 1.0,
);

const KScreenTitlesStyle2 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KEditButtonsStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KSignOutButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  color: KWarningColor,
  height: 1.0,
);

const KSplashStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  color: KPrimaryColor,
  letterSpacing: 1.0,
  height: 1.0,
);

const KWriteCommentAndSendMessageStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 19.0,
  height: 1.0,
);

const KAddPostButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KAddPostButtonInAppBarStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
  color: KPrimaryColor,
  height: 1.0,
);

const KNameStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 21.0,
  fontWeight: FontWeight.bold,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KNameStyle2 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w800,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KNameInHeaderStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 23.0,
  fontWeight: FontWeight.bold,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KEmailInHeaderStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KSearchLabelStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KNameInSubPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KFlushBarTitleStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KFlushBarMessageStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KPostStyle2 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KSubPostStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 15.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KLikesCommentsAndSharesCount = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  height: 1.0,
  color: KSubSecondryFontsColor,
);

const KSnackBarContentStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
  color: KPrimaryFontsColor,
  height: 1.0,
);

const KPostOptionsStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KCategoryButtonStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19,
  color: KSubPrimaryFontsColor,
);

const KNameInCardStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 16.0,
  fontWeight: FontWeight.w900,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

const KDataInCardStyle = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 16.0,
  color: KSubPrimaryFontsColor,
  height: 1.0,
);

///*************************TEXTFIELDS**************************/
TextField basicTextField(
    TextEditingController controller, String hint, bool isName) {
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
    ),
    cursorColor: KPrimaryColor,
    inputFormatters: isName
        ? [
            LengthLimitingTextInputFormatter(31),
          ]
        : null,
    enableSuggestions: false,
  );
}

TextField heightAndWeightTextField(
    TextEditingController controller, String hint) {
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
    ),
    keyboardType: TextInputType.number,
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
      suffixIcon: showPassword,
    ),
    enableSuggestions: false,
    autocorrect: false,
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

///*************************USER CARD**************************/

class ProfileCard extends StatelessWidget {
  final name;
  final image;
  final useAsset;
  final type;
  final category;
  final countryName;
  final legOrHand;
  final mainPosition;
  final otherPosition;
  final age;
  final height;
  final weight;
  ProfileCard({
    this.name,
    this.image,
    this.useAsset,
    this.type,
    this.category,
    this.countryName,
    this.legOrHand,
    this.mainPosition,
    this.otherPosition,
    this.age,
    this.height,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 200.0,
          height: 250.0,
          child: Image.asset("assets/images/profilecardgreencropped.png"),
        ),
        Positioned(
          top: 30.0,
          left: 40.0,
          child: useAsset
              ? Container(
                  width: 120.0,
                  height: 100.0,
                  child: Image.asset(image),
                )
              : Container(
                  width: 120.0,
                  height: 100.0,
                  child: Image.network(image),
                ),
        ),
        Positioned(
          top: 30.0,
          left: 30.0,
          child: Visibility(
            visible:
                countryName != null || mainPosition != '' || otherPosition != ''
                    ? true
                    : false,
            child: Container(
              width: 40.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: KPrimaryColor.withOpacity(0.6),
              ),
            ),
          ),
        ),
        Positioned(
          top: 40.0,
          left: 35.0,
          child: Container(
            width: 30.0,
            height: 30.0,
            child: countryName == null
                ? Container()
                : Image.asset('icons/flags/png/$countryName.png',
                    package: 'country_icons'),
          ),
        ),
        Positioned(
          top: 75.0,
          left: 40.0,
          child: Text(
            mainPosition,
            style: KPostStyle2,
          ),
        ),
        Positioned(
          top: 100.0,
          left: 40.0,
          child: Text(
            otherPosition,
            style: KPostStyle2,
          ),
        ),
        Positioned(
          top: name.toString().length >= 14 ? 130.0 : 135.0,
          left: name.toString().length <= 4
              ? 80.0
              : name.toString().length > 4 && name.toString().length <= 10
                  ? 50.0
                  : 40.0,
          child: Container(
            width: 130.0,
            height: 80.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: KNameInCardStyle,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: name.toString().length >= 14 ? 165.0 : 160.0,
          left: 30.0,
          child: Row(
            children: [
              Visibility(
                visible: age != '0' ? true : false,
                child: Text(
                  'Age $age',
                  style: KDataInCardStyle,
                ),
              ),
              SizedBox(
                width: 30.0,
              ),
              Visibility(
                visible: height != '0' ? true : false,
                child: Text(
                  'Ht $height',
                  style: KDataInCardStyle,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: name.toString().length >= 14 ? 190.0 : 185.0,
          left: 30.0,
          child: Row(
            children: [
              Visibility(
                visible: legOrHand != null ? true : false,
                child: Text(
                  category == 1
                      ? 'Leg $legOrHand'
                      : category == 2
                          ? 'Hand $legOrHand'
                          : '',
                  style: KDataInCardStyle,
                ),
              ),
              SizedBox(
                width: category == 1 && legOrHand.toString().length == 5
                    ? 13.0
                    : category == 1 && legOrHand.toString().length == 4
                        ? 20.0
                        : 8.0,
              ),
              Visibility(
                visible: weight != '0' ? true : false,
                child: Text(
                  'Wt $weight',
                  style: KDataInCardStyle,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: category == 2 ? 210.0 : 215.0,
          left: category == 2 ? 60.0 : 70.0,
          child: Visibility(
            visible: category != null ? true : false,
            child: Text(
              category == 1
                  ? "Football"
                  : category == 2
                      ? "Basketball"
                      : "",
              style: KDataInCardStyle,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeProfileCard extends StatelessWidget {
  final userImage;
  final userName;
  final useAsset;
  final countryName;
  HomeProfileCard(
      {this.userName, this.userImage, this.useAsset, this.countryName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 220.0,
          height: 120.0,
          child: Image.asset("assets/images/profilecardgreenhalfcropped.png"),
        ),
        Positioned(
          top: 20.0,
          left: 110.0,
          child: useAsset
              ? CircleAvatar(
                  backgroundImage: AssetImage(userImage),
                  radius: 30.0,
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 30.0,
                ),
        ),
        Positioned(
          top: 30.0,
          left: 50.0,
          child: Container(
            width: 40.0,
            height: 40.0,
            child: countryName == null
                ? Container()
                : Image.asset('icons/flags/png/$countryName.png',
                    package: 'country_icons'),
          ),
        ),
        Positioned(
          top: 80.0,
          left: userName.toString().length <= 4
              ? 80.0
              : userName.toString().length > 4 &&
                      userName.toString().length <= 10
                  ? 50.0
                  : 50.0,
          child: Container(
            width: 130.0,
            height: 80.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: KNameStyle2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
