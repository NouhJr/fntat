import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:fntat/Components/constants.dart';

class ChatScreen extends StatefulWidget {
  final String receiverName;
  ChatScreen({required this.receiverName});
  @override
  _ChatScreenState createState() => _ChatScreenState(name: receiverName);
}

class _ChatScreenState extends State<ChatScreen> {
  final String name;
  _ChatScreenState({required this.name});
  TextEditingController _message = TextEditingController();

  var image =
      "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg?itok=PANMBJF-";
  late PusherClient pusher;
  late Channel channel;

  String mesg = '';

  @override
  void initState() {
    super.initState();
    // PusherAuth auth = PusherAuth(
    //   'http://192.168.1.7:3000/pusher/auth',
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    // );
    print(name);
    pusher = new PusherClient(
      "2a15bf978e97141176f7",
      PusherOptions(),
      enableLogging: true,
    );

    channel = pusher.subscribe("mychannel");

    channel.bind("sendMessage", (event) {
      setState(() {
        mesg = event.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimaryFontsColor,
      appBar: AppBar(
        backgroundColor: KPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KPrimaryFontsColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        title: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 25.0,
          ),
          title: Text(
            name,
            style: KReceiverNameStyle,
          ),
          subtitle: Text(
            "Last seen recently",
            style: KLastSeenStyle,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: KPrimaryFontsColor,
              size: 30.0,
            ),
            onPressed: () => {
              Navigator.pushNamed(context, '/Others'),
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            mesg,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(
          left: 5.0,
          right: 5.0,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => {},
              icon: Icon(Icons.add_a_photo),
              color: KPrimaryColor,
              iconSize: 30.0,
            ),
            SizedBox(
              width: 15.0,
            ),
            Container(
              width: 250.0,
              height: 70.0,
              child: messageTextField(_message),
            ),
            SizedBox(
              width: 10.0,
            ),
            IconButton(
              onPressed: () => {
                channel.trigger("sendMessage", _message.text),
              },
              icon: Icon(Icons.send),
              color: KPrimaryColor,
              iconSize: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
