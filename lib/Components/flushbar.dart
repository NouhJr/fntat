import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fntat/Components/constants.dart';

class Warning {
  void errorMessage(BuildContext context,
      {required String title,
      required String message,
      required IconData icons}) {
    Flushbar(
      titleText: Text(
        title,
        style: KFlushBarTitleStyle,
      ),
      messageText: Text(
        message,
        style: KFlushBarMessageStyle,
      ),
      icon: Icon(
        icons,
        size: 30,
        color: KWarningColor,
      ),
      borderWidth: 5,
      duration: Duration(seconds: 3),
      borderRadius: BorderRadius.circular(10.0),
    )..show(context);
  }

  normalMessage(
    BuildContext context, {
    required Function onTab,
    required String title,
    required String message,
    required IconData icons,
  }) {
    return Flushbar(
      titleText: Text(
        title,
        style: KFlushBarTitleStyle,
      ),
      messageText: Text(
        message,
        style: KFlushBarMessageStyle,
      ),
      icon: Icon(
        icons,
        size: 30,
        color: KPrimaryColor,
      ),
      onTap: onTab(),
      borderWidth: 5,
      duration: Duration(seconds: 3),
      borderRadius: BorderRadius.circular(10.0),
    )..show(context);
  }
}
