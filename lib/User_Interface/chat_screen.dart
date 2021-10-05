import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/User_Interface/account_screen.dart';
import 'package:fntat/User_Interface/settings_screen.dart';
import 'package:fntat/User_Interface/home_screen.dart';
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
  String userName = 'User Name';
  String userImage = "assets/images/nouserimagehandler.jpg";
  File? _imageFile;
  List<dynamic> messages = [];
  var nextPageUrl;
  bool withImage = false;
  bool useAsset = true;
  bool useAssetForOtherUser = true;
  var receiverName = "";
  String receiverImage = "assets/images/nouserimagehandler.jpg";
  var receiverID;
  var userId;
  var token;
  late UserProfileBloc userProfileBloc;
  late List<int> imageBytes;
  late Uint8List imageBytesData;
  String imageNameWeb = '';

  gettingReceiverData() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/profile',
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
          useAssetForOtherUser = false;
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
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
    gettingUserId();
    gettingReceiverData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingUserProfileDataSuccessState) {
            setState(() {
              userName = state.name;
              useAsset = false;
              userImage = '$ImageServerPrefix/${state.image}';
            });
          }
        },
        child: Stack(
          children: [
            Container(
              color: KPrimaryColor,
            ),
            Positioned(
              top: 20.0,
              left: 20.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Account(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    useAsset
                        ? CircleAvatar(
                            backgroundImage: AssetImage(userImage),
                            radius: 30.0,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(userImage),
                            radius: 30.0,
                          ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      userName,
                      style: KNameInHeaderStyle,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 25.0,
              right: 10.0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              toNotifications: true,
                            ),
                          ),
                          (route) => false);
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: KSubPrimaryColor,
                      size: 25.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              toMessages: true,
                            ),
                          ),
                          (route) => false);
                    },
                    icon: Icon(
                      Icons.email,
                      color: KSubPrimaryColor,
                      size: 25.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings(fromAccount: false),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      color: KSubPrimaryColor,
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 160.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                height: screenSize.height - 160,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  color: KSubPrimaryColor,
                ),
                child: MessagesStream(
                  receiverID: id,
                ),
              ),
            ),
            Positioned(
              top: 160.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  color: KSubPrimaryColor,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 30.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: KPrimaryColor,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: KSubPrimaryColor,
                            size: 20.0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 190.0,
              right: 60.0,
              left: 150.0,
              child: Container(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUsersProfile(
                          userID: receiverID,
                        ),
                      ),
                    );
                  },
                  child: kIsWeb
                      ? Center(
                          child: Text(
                            receiverName,
                            style: KUserNameStyle,
                          ),
                        )
                      : Text(
                          receiverName,
                          style: KUserNameStyle,
                        ),
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              right: 40.0,
              left: 150.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherUsersProfile(
                        userID: receiverID,
                      ),
                    ),
                  );
                },
                child: kIsWeb
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          useAssetForOtherUser
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(receiverImage),
                                  radius: 55.0,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '$ImageServerPrefix/$receiverImage'),
                                  radius: 55.0,
                                ),
                        ],
                      )
                    : Row(
                        children: [
                          useAssetForOtherUser
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(receiverImage),
                                  radius: 55.0,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '$ImageServerPrefix/$receiverImage'),
                                  radius: 55.0,
                                ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: kIsWeb
          ? Padding(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KPrimaryColor,
                    ),
                    child: IconButton(
                      onPressed: pickImageInMessagesWeb,
                      icon: Icon(
                        Icons.add_a_photo,
                        color: KSubPrimaryColor,
                      ),
                      iconSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    width: kIsWeb ? 1100.0 : 250.0,
                    height: 70.0,
                    child: messageTextField(_message),
                  ),
                  SizedBox(
                    width: kIsWeb ? 35.0 : 15.0,
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
                          iconSize: 33.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KPrimaryColor,
                    ),
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: KSubPrimaryColor,
                      ),
                      iconSize: 25.0,
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
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Container(
                    width: kIsWeb ? 1100.0 : 250.0,
                    height: 70.0,
                    child: messageTextField(_message),
                  ),
                  SizedBox(
                    width: kIsWeb ? 35.0 : 15.0,
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
                          iconSize: 33.0,
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

  void pickImageInMessagesWeb() async {
    FilePickerResult? imageWeb;
    imageWeb = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (imageWeb != null) {
      setState(() {
        imageNameWeb = imageWeb!.files.single.name;
        imageBytesData = imageWeb.files.single.bytes!;
        withImage = true;
        imageBytes = imageBytesData.cast();
      });
    }
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
      if (withImage && !kIsWeb) {
        String fileName = _imageFile!.path.split('/').last;
        FormData formData = FormData.fromMap({
          "reciver_user_id": id,
          "type": 2,
          "attachment": await MultipartFile.fromFile(_imageFile!.path,
              filename: fileName),
        });
        try {
          final res = await dio.post('$ServerUrl/send-message', data: formData);
          final data = res.data;
          if (data['success'] == true) {
            setState(() {
              _imageFile = null;
            });
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
      } else if (withImage && kIsWeb) {
        FormData formData = FormData.fromMap({
          "reciver_user_id": id,
          "type": 2,
          "attachment": MultipartFile.fromBytes(
            imageBytes,
            filename: imageNameWeb,
          ),
        });
        final res = await dio.post('$ServerUrl/send-message', data: formData);
        final data = res.data;
        if (data['success'] == false) {
          Warning().errorMessage(
            context,
            title: "Not sent",
            message: "Error sending message",
            icons: Icons.warning,
          );
        }
        // var request = http.MultipartRequest('POST', Uri.parse(url));
        // request.files.add(
        //   http.MultipartFile.fromBytes(
        //     'attachment',
        //     imageBytes,
        //     filename: imageNameWeb,
        //   ),
        // );
        // request.headers.addAll({"Authorization": 'Bearer $token'});
        // var response = await request.send();
      } else {
        FormData formData = FormData.fromMap({
          "reciver_user_id": id,
          "type": 1,
          "content": _message.text,
        });
        try {
          final res = await dio.post('$ServerUrl/send-message', data: formData);
          final data = res.data;
          if (data['success'] == true) {
            _message.clear();
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
      final res = await dio.get('$ServerUrl/specific-chat?user_id=$id');
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
                    padding: EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment:
                          userId == msgs[index]['sender_user_id']
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(3.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: .5,
                                spreadRadius: 1.0,
                                color: Colors.black.withOpacity(.12),
                              ),
                            ],
                            color: userId == msgs[index]['sender_user_id']
                                ? Colors.greenAccent.shade100
                                : Colors.white,
                            borderRadius:
                                userId == msgs[index]['sender_user_id']
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(10.0),
                                      )
                                    : BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(5.0),
                                      ),
                          ),
                          child: msgs[index]['type'] == 2
                              ? Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: 250.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          '$ImageServerPrefix/${msgs[index]['attachment']}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Text(
                                  msgs[index]['content'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontFamily: KPrimaryFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ))
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
