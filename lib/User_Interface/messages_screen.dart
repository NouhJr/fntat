import 'package:flutter/material.dart';
import 'package:fntat/Components/constants.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List titles = ["Omar", "Mohand", "Ali"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      body: ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg?itok=PANMBJF-"),
                  radius: 25.0,
                ),
                title: Text(titles[index]),
              ),
              Divider(
                color: KSubSecondryFontsColor,
                thickness: 0.5,
              ),
            ],
          ),
        ),
        itemCount: titles.length,
      ),
    );
  }
}
