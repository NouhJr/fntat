import 'package:flutter/material.dart';
import 'package:fntat/Components/constants.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: ButtonTheme(
                  minWidth: double.infinity,
                  height: 70.0,
                  buttonColor: KPrimaryColor,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(
                        1.0,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Create account",
                      style: KPrimaryButtonsFontStyle,
                    ),
                    onPressed: () => {
                      Navigator.pushNamed(context, '/SignUp'),
                    },
                  ),
                ),
              ),
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
                    onPressed: () => {
                      Navigator.pushNamed(context, '/SignIn'),
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
    );
  }
}
