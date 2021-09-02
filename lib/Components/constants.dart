//Import necessary packages
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

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

const KSubPrimaryButtonsFontStyle3 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w700,
  fontSize: 18.0,
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

const KNameStyle2 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontSize: 19.0,
  fontWeight: FontWeight.w800,
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

const KPostStyle2 = TextStyle(
  fontFamily: KPrimaryFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 17.0,
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
    ),
    cursorColor: KPrimaryColor,
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

///*************************PROFILE CARD**************************/
class ProfileCard extends StatefulWidget {
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
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  var flagUrl;

  getCountryFlag() async {
    var res = await http.get(Uri.parse(
        "https://restcountries.eu/rest/v2/name/${widget.countryName}?fields=flag"));
    final jsonRes = json.decode(res.body);
    setState(() {
      flagUrl = jsonRes[0]['flag'];
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.countryName != "") {
      Future.delayed(Duration(seconds: 1)).then((value) => {
            getCountryFlag(),
          });
    }
  }

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
          child: widget.useAsset
              ? Container(
                  width: 120.0,
                  height: 100.0,
                  child: Image.asset(widget.image),
                )
              : Container(
                  width: 120.0,
                  height: 100.0,
                  child: Image.network(widget.image),
                ),
        ),
        Positioned(
          top: 30.0,
          left: 30.0,
          child: Container(
            width: 40.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: KPrimaryColor.withOpacity(0.6),
            ),
          ),
        ),
        Positioned(
          top: 40.0,
          left: 35.0,
          child: Container(
            width: 30.0,
            height: 30.0,
            child: flagUrl != null ? SvgPicture.network(flagUrl) : Container(),
          ),
        ),
        Positioned(
          top: 80.0,
          left: 40.0,
          child: Text(
            widget.mainPosition,
            style: KPostStyle2,
          ),
        ),
        Positioned(
          top: 100.0,
          left: 40.0,
          child: Text(
            widget.otherPosition,
            style: KPostStyle2,
          ),
        ),
        Positioned(
          top: 130.0,
          left: widget.name.toString().length <= 4
              ? 70.0
              : widget.name.toString().length > 4 &&
                      widget.name.toString().length < 10
                  ? 60.0
                  : widget.name.toString().length >= 10
                      ? 40.0
                      : 85.0,
          child: Text(
            widget.name,
            style: KNameStyle2,
          ),
        ),
        Positioned(
          top: 155.0,
          left: 30.0,
          child: Row(
            children: [
              Text(
                //'Age 23',
                'Age ${widget.age}',
                style: KPostStyle2,
              ),
              SizedBox(
                width: 30.0,
              ),
              Text(
                //'Ht 170',
                'Ht ${widget.height}',
                style: KPostStyle2,
              ),
            ],
          ),
        ),
        Positioned(
          top: 180.0,
          left: 30.0,
          child: Row(
            children: [
              Text(
                widget.category == 1
                    ? 'Leg ${widget.legOrHand}'
                    : widget.category == 2
                        ? 'Hand ${widget.legOrHand}'
                        : '',
                style: KPostStyle2,
              ),
              SizedBox(
                width: widget.category == 2 ? 8.0 : 15.0,
              ),
              Text(
                'Wt ${widget.weight}',
                style: KPostStyle2,
              ),
            ],
          ),
        ),
        // Positioned(
        //   top: 220.0,
        //   left: 90.0,
        //   child: widget.type == 1
        //       ? Text(
        //           "Admin",
        //           style: KPostStyle2,
        //         )
        //       : widget.type == 2
        //           ? Text(
        //               "Amateur",
        //               style: KPostStyle2,
        //             )
        //           : widget.type == 3
        //               ? Text(
        //                   "Professional",
        //                   style: KPostStyle2,
        //                 )
        //               : widget.type == 4
        //                   ? Text(
        //                       "Agent",
        //                       style: KPostStyle2,
        //                     )
        //                   : widget.type == 5
        //                       ? Text(
        //                           "Academy",
        //                           style: KPostStyle2,
        //                         )
        //                       : widget.type == 6
        //                           ? Text(
        //                               "Club",
        //                               style: KPostStyle2,
        //                             )
        //                           : Text(""),
        // ),
        Positioned(
          top: widget.category == 2 ? 205.0 : 210.0,
          left: widget.category == 2 ? 60.0 : 70.0,
          child: widget.category == 1
              ? Text(
                  "Football",
                  style: KPostStyle2,
                )
              : widget.category == 2
                  ? Text(
                      "Basketball",
                      style: KPostStyle2,
                    )
                  : Text(""),
        ),
      ],
    );
  }
}

class HomeProfileCard extends StatefulWidget {
  final userImage;
  final userName;
  final useAsset;
  final countryName;
  HomeProfileCard(
      {this.userName, this.userImage, this.useAsset, this.countryName});
  @override
  _HomeProfileCardState createState() => _HomeProfileCardState();
}

class _HomeProfileCardState extends State<HomeProfileCard> {
  var flagUrl;

  getCountryFlag() async {
    var res = await http.get(Uri.parse(
        "https://restcountries.eu/rest/v2/name/${widget.countryName}?fields=flag"));
    final jsonRes = json.decode(res.body);
    setState(() {
      flagUrl = jsonRes[0]['flag'];
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) => {
          getCountryFlag(),
        });
  }

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
          child: widget.useAsset
              ? CircleAvatar(
                  backgroundImage: AssetImage(widget.userImage),
                  radius: 30.0,
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                  radius: 30.0,
                ),
        ),
        Positioned(
          top: 30.0,
          left: 50.0,
          child: Container(
            width: 40.0,
            height: 40.0,
            child: flagUrl != null ? SvgPicture.network(flagUrl) : Container(),
          ),
        ),
        Positioned(
          top: 85.0,
          left: widget.userName.toString().length <= 10 ? 50.0 : 40.0,
          child: Text(
            widget.userName,
            style: KNameStyle2,
          ),
        ),
      ],
    );
  }
}
