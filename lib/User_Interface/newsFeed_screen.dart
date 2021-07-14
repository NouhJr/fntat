import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fntat/Components/constants.dart';

class UserFeed extends StatefulWidget {
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: KSubPrimaryColor,
        body: ListView(),
      ),
    );
  }
}
