import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/User_Interface/account_screen.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:fntat/Components/constants.dart';

class Settings extends StatefulWidget {
  final bool fromAccount;
  Settings({required this.fromAccount});
  @override
  _SettingsState createState() => _SettingsState(fromAcc: fromAccount);
}

class _SettingsState extends State<Settings> {
  final bool fromAcc;
  _SettingsState({required this.fromAcc});

  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KSubPrimaryColor,
        title: Text(
          "Settings",
          style: KScreenTitlesStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KPrimaryColor,
          ),
          onPressed: () {
            if (fromAcc == true) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Account()),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false);
            }
          },
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) => {
          if (state is SignOutSuccessState)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Initial', (route) => false),
            }
        },
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "Edit Profile",
                  style: KPrimaryFontStyle,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/EditName'),
                },
                child: Text(
                  "Edit Name",
                  style: KEditButtonsStyle,
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/EditEmail'),
                },
                child: Text(
                  "Edit Email",
                  style: KEditButtonsStyle,
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/EditPhone'),
                },
                child: Text(
                  "Edit Phone",
                  style: KEditButtonsStyle,
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/EditPicture'),
                },
                child: Text(
                  "Edit Picture",
                  style: KEditButtonsStyle,
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Divider(
                color: KSubSecondryFontsColor,
                thickness: 1.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Privacy",
                  style: KPrimaryFontStyle,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/ChangePassword'),
                },
                child: Text(
                  "Change Password",
                  style: KEditButtonsStyle,
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextButton(
                onPressed: signOut,
                child: Text(
                  "Sign Out",
                  style: KSignOutButtonStyle,
                ),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Divider(
                color: KSubSecondryFontsColor,
                thickness: 1.0,
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // showAds() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           contentPadding: EdgeInsets.all(
  //             8.0,
  //           ),
  //           content: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               Image.asset(
  //                 "assets/images/demo_ad_vertical.jpg",
  //                 fit: BoxFit.cover,
  //               ),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               child: Text(
  //                 'Skip',
  //                 style: TextStyle(
  //                   color: KSubPrimaryFontsColor,
  //                   fontFamily: KPrimaryFontFamily,
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 18.0,
  //                   height: 1.3,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 authBloc.add(SignOutButtonPressed());
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  signOut() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: KPrimaryFontsColor,
            elevation: 1.0,
            title: Text(
              "Sign Out",
              style: TextStyle(
                color: KSubPrimaryFontsColor,
                fontFamily: KPrimaryFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
                height: 1.3,
              ),
            ),
            content: Text(
              "Are you sure? signing out will remove all " +
                  APPNAME +
                  " data from this device.",
              style: TextStyle(
                color: KSubPrimaryFontsColor,
                fontFamily: KPrimaryFontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                height: 1.3,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: KSubPrimaryFontsColor,
                    fontFamily: KPrimaryFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    height: 1.3,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: KSubPrimaryFontsColor,
                    fontFamily: KPrimaryFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    height: 1.3,
                  ),
                ),
                onPressed: () {
                  authBloc.add(SignOutButtonPressed());
                  // showAds();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
