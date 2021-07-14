import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fntat/Components/constants.dart';

class Warning {
  void errorMessage(BuildContext context,
      {required String title,
      required String message,
      required IconData icons}) {
    Flushbar(
      title: title,
      message: message,
      icon: Icon(
        icons,
        size: 28,
        color: KWarningColor,
      ),
      borderWidth: 5,
      duration: Duration(seconds: 3),
      borderRadius: BorderRadius.circular(10.0),
    )..show(context);
  }
}
