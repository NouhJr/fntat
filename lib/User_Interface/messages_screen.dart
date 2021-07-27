import 'package:flutter/material.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/User_Interface/chat_screen.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var image =
      "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg?itok=PANMBJF-";
  List titles = ["Omar", "Mohand", "Ali"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 80.0,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(image),
                      radius: 25.0,
                    ),
                    title: Text(
                      titles[index],
                      style: KNameStyle,
                    ),
                    onTap: () {
                      print(titles[index]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(receiverName: titles[index])));
                    },
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: titles.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 1.0,
        backgroundColor: KPrimaryColor,
        child: Icon(
          Icons.add_comment,
          size: 30.0,
        ),
      ),
    );
  }
}
