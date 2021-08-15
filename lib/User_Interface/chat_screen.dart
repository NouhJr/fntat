import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

var dio = Dio();

class ChatScreen extends StatefulWidget {
  final receiverID;
  ChatScreen({required this.receiverID});
  @override
  _ChatScreenState createState() => _ChatScreenState(id: receiverID);
}

class _ChatScreenState extends State<ChatScreen> {
  final id;
  _ChatScreenState({required this.id});

  TextEditingController _message = TextEditingController();
  String image = "assets/images/nouserimagehandler.jpg";
  File? _imageFile;
  List<dynamic> messages = [];
  var nextPageUrl;
  bool withImage = false;
  bool useAsset = true;
  var receiverName = "";
  var receiverImage;
  var receiverID;
  var userId;
  var token;

  gettingReceiverData() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        "http://164.160.104.125:9090/fntat/api/profile",
        data: formData,
      );
      final data = res.data;
      setState(() {
        receiverName = data['data']['name'];
        receiverID = data['data']['id'];
      });
      if (data['data']['image'] != null) {
        setState(() {
          receiverImage = data['data']['image'];
          useAsset = false;
        });
      }
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  gettingUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var userToken = prefs.getString("TOKEN");
    setState(() {
      userId = id!;
      token = userToken!;
    });
  }

  @override
  void initState() {
    super.initState();
    gettingUserId();
    gettingReceiverData();
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
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUsersProfile(
                  userID: id,
                ),
              ),
            );
          },
          child: Row(
            children: [
              useAsset
                  ? CircleAvatar(
                      backgroundImage: AssetImage(image),
                      radius: 25.0,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(
                          'http://164.160.104.125:9090/fntat/$receiverImage'),
                      radius: 25.0,
                    ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                receiverName,
                style: KReceiverNameStyle,
              ),
            ],
          ),
        ),
      ),
      body: MessagesStream(
        receiverID: id,
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(
          left: 5.0,
          right: 5.0,
        ),
        child: Row(
          children: [
            PopupMenuButton(
              icon: Icon(
                Icons.add_a_photo,
                color: KPrimaryColor,
              ),
              iconSize: 30.0,
              onSelected: imageOptions,
              itemBuilder: (context) {
                return options.map((choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: KPostOptionsStyle,
                    ),
                  );
                }).toList();
              },
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
              width: 5.0,
            ),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send),
                    color: KPrimaryColor,
                    iconSize: 30.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> options = ['Take photo', 'Choose existing photo'];
  imageOptions(String option) {
    if (option == options[0]) {
      takeImage();
    } else if (option == options[1]) {
      chooseFile();
    }
  }

  Future chooseFile() async {
    final source = ImageSource.gallery;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      withImage = true;
      _imageFile = File(pickedFile!.path);
    });
  }

  Future takeImage() async {
    final source = ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
      withImage = true;
    });
  }

  sendMessage() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    } else if (withImage == false && _message.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "No message to send !",
        message: 'Please enter a message.',
        icons: Icons.warning,
      );
    } else {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("TOKEN");
      dio.options.headers["authorization"] = "Bearer $token";
      if (withImage) {
        String fileName = _imageFile!.path.split('/').last;
        FormData formData = FormData.fromMap({
          "reciver_user_id": id,
          "type": 2,
          "attachment": await MultipartFile.fromFile(_imageFile!.path,
              filename: fileName),
        });
        try {
          final res = await dio.post(
              "http://164.160.104.125:9090/fntat/api/send-message",
              data: formData);
          final data = res.data;
          if (data['success'] == true) {
            setState(() {
              _imageFile = null;
            });
            // Warning().normalMessage(
            //   context,
            //   onTab: () {},
            //   title: "Sent",
            //   message: "Message sent successfully",
            //   icons: Icons.done,
            // );
          } else {
            Warning().errorMessage(
              context,
              title: "Not sent",
              message: "Error sending message",
              icons: Icons.warning,
            );
          }
        } on Exception catch (error) {
          print(error.toString());
          Warning().errorMessage(
            context,
            title: "Not sent",
            message: "Error sending message",
            icons: Icons.warning,
          );
        }
      } else {
        FormData formData = FormData.fromMap({
          "reciver_user_id": id,
          "type": 1,
          "content": _message.text,
        });
        try {
          final res = await dio.post(
              "http://164.160.104.125:9090/fntat/api/send-message",
              data: formData);
          final data = res.data;
          if (data['success'] == true) {
            _message.clear();
            // Warning().normalMessage(
            //   context,
            //   onTab: () {},
            //   title: "Sent",
            //   message: "Message sent successfully",
            //   icons: Icons.done,
            // );
          } else {
            Warning().errorMessage(
              context,
              title: "Not sent",
              message: "Error sending message",
              icons: Icons.warning,
            );
          }
        } on Exception catch (error) {
          print(error.toString());
          Warning().errorMessage(
            context,
            title: "Not sent",
            message: "Error sending message",
            icons: Icons.warning,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _message.dispose();
  }
}

class MessagesStream extends StatefulWidget {
  final receiverID;
  MessagesStream({this.receiverID});
  @override
  _MessagesStreamState createState() => _MessagesStreamState(id: receiverID);
}

class _MessagesStreamState extends State<MessagesStream> {
  final id;
  _MessagesStreamState({this.id});
  ScrollController _scrollController = ScrollController();
  List<dynamic> msgs = [];
  late UserProfileBloc userProfileBloc;
  var userId;
  var nextPageUrl;
  bool showLoading = true;
  var realTime;

  gettingUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    setState(() {
      userId = id!;
    });
  }

  gettingMessages() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.get(
          "http://164.160.104.125:9090/fntat/api/specific-chat?user_id=$id");
      final List<dynamic> msgsBody = res.data['data']['data'];
      final nextPage = res.data['data']['next_page_url'];
      setState(() {
        msgs = msgsBody;
        nextPageUrl = nextPage;
      });
      // return msgs;
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  gettingMoreMessages() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    if (nextPageUrl != null) {
      try {
        final res = await dio.get(nextPageUrl);
        final List<dynamic> msgsBody = res.data['data']['data'];
        final nextPage = res.data['data']['next_page_url'];
        setState(() {
          msgs.addAll(msgsBody);
          nextPageUrl = nextPage;
        });
        // return msgs;
      } on Exception catch (error) {
        print(error.toString());
      }
    }
  }

  Future<void> init() async {
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen((event) {
      if (this.mounted) {
        if (int.parse(event.data['type']) == 1) {
          setState(() {
            realTime = {
              "id": int.parse(event.data['message_id']),
              "content": event.data['content'],
              "sender_user_id": int.parse(event.data['sender_id']),
              "type": int.parse(event.data['type']),
              "attachment": null,
            };
          });
          setState(() {
            msgs.insert(0, realTime);
          });
        } else if (int.parse(event.data['type']) == 2) {
          setState(() {
            realTime = {
              "id": int.parse(event.data['message_id']),
              "content": null,
              "sender_user_id": int.parse(event.data['sender_id']),
              // event.data['sender_id'],
              "type": int.parse(event.data['type']),
              "attachment": event.data['content'],
            };
          });
          setState(() {
            msgs.insert(0, realTime);
          });
        } else {
          print("from last else");
        }
      }
    });
  }

  stateIndicator() {
    if (showLoading) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoading = false;
          });
        }
      });
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          LinearProgressIndicator(
            backgroundColor: KSubPrimaryColor,
            color: KPrimaryColor,
            minHeight: 5.0,
          ),
        ],
      );
    } else {
      return Center(
        child: Text(
          "There's no messages yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    gettingUserId();
    gettingMessages();
    init();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        gettingMoreMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {},
      child: msgs.isNotEmpty
          ? ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 60),
              itemCount: msgs.length,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: userId == msgs[index]['sender_user_id']
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Material(
                      borderRadius: userId == msgs[index]['sender_user_id']
                          ? BorderRadius.all(Radius.circular(15.0))
                          : BorderRadius.all(Radius.circular(15.0)),
                      elevation: 1.0,
                      color: userId == msgs[index]['sender_user_id']
                          ? Color(0xff163c41)
                          : Color(0xfff9f9f9),
                      child: InkWell(
                        onLongPress: userId == msgs[index]['sender_user_id']
                            ? () {
                                messageLongPress(msgs[index]['id']);
                              }
                            : () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 9.0, horizontal: 9.0),
                          child: msgs[index]['type'] == 2
                              ? Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          'http://164.160.104.125:9090/fntat/${msgs[index]['attachment']}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Text(
                                  msgs[index]['content'],
                                  style: TextStyle(
                                    color:
                                        userId == msgs[index]['sender_user_id']
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 19.0,
                                    fontFamily: KPrimaryFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : stateIndicator(),
    );
  }

  messageLongPress(var msgID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: KPrimaryFontsColor,
            elevation: 1.0,
            title: Text(
              "Delete Message",
              style: TextStyle(
                color: KSubPrimaryFontsColor,
                fontFamily: KPrimaryFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
                height: 1.3,
              ),
            ),
            content: Text(
              "Are you sure? delete will remove this message from this chat permanently",
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
                  deleteMessage(msgID);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  deleteMessage(var messageID) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    } else {
      userProfileBloc.add(DeleteMessageButtonPressed(messageID: messageID));
      deleteMessageRealTime(messageID);
    }
  }

  deleteMessageRealTime(var id) {
    for (var i = 0; i < msgs.length; i++) {
      if (id == msgs[i]['id']) {
        setState(() {
          msgs.removeAt(i);
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
