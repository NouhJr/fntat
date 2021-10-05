import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fntat/Components/constants.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "Join " + APPNAME + " community",
                    textAlign: TextAlign.center,
                    style: KPrimaryFontStyle,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: 220.0,
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
                      onTap: () {
                        // if (kIsWeb) {
                        //   Navigator.pushNamed(context, '/SignUp');
                        // }
                        // else {
                        //   Navigator.pushNamed(context, '/SignUpWeb');
                        // }
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, '/SignUp', (route) => false);
                        Navigator.pushNamed(context, '/SignUp');
                      },
                      child: Text(
                        "Create account",
                        style: KPrimaryButtonsFontStyle,
                      ),
                    ),
                  ),
                ),
                // Container(
                //   width: 220.0,
                //   child: ButtonTheme(
                //     minWidth: double.infinity,
                //     height: 70.0,
                //     child: ElevatedButton(
                //       style: ButtonStyle(
                //         backgroundColor:
                //             MaterialStateProperty.all(KPrimaryColor),
                //         elevation: MaterialStateProperty.all(
                //           1.0,
                //         ),
                //         shape:
                //             MaterialStateProperty.all<RoundedRectangleBorder>(
                //           RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(20.0),
                //           ),
                //         ),
                //       ),
                //       child: Text(
                //         "Create account",
                //         style: KPrimaryButtonsFontStyle,
                //       ),
                //       onPressed: () => {
                //         // Navigator.pushNamed(context, '/SignUp'),
                //         Navigator.pushNamedAndRemoveUntil(
                //             context, '/SignUp', (route) => false),
                //       },
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 100.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account?",
                      style: TextStyle(
                        color: KSubSecondryFontsColor,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/SignIn');
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, '/SignIn', (route) => false);
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: KPrimaryColor,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
