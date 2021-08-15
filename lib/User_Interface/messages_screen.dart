import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/User_Interface/chat_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final ScrollController _scrollController = ScrollController();
  var dio = Dio();
  var noUserImage = "assets/images/nouserimagehandler.jpg";
  List<dynamic> chatRooms = [];
  var nextPageUrl;
  bool showLoading = true;
  bool hasConnection = false;
  bool loading = false;
  bool _showBackToTopButton = false;

  Future gettingChatRooms() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.get("http://164.160.104.125:9090/fntat/api/rooms");
      final List<dynamic> resBody = res.data['data']['data'];
      final nextPageBody = res.data['data']['next_page_url'];
      setState(() {
        chatRooms = resBody;
        nextPageUrl = nextPageBody;
      });
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  gettingMoreChatRooms() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    if (nextPageUrl != null) {
      try {
        final res = await dio.get(nextPageUrl);
        final List<dynamic> resBody = res.data['data']['data'];
        final nextPageBody = res.data['data']['next_page_url'];
        setState(() {
          chatRooms.addAll(resBody);
          nextPageUrl = nextPageBody;
        });
      } on Exception catch (error) {
        print(error.toString());
      }
    }
  }

  checkIfChatRoomsLoaded() {
    Future.delayed(Duration(seconds: 3));
    if (chatRooms.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  stateIndicator() {
    if (showLoading) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoading = false;
          });
        }
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 5.0,
        ),
      );
    } else {
      return Center(
        child: Text(
          "There's no chats yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  internetConnection() {
    if (showLoading) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoading = false;
          });
        }
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 5.0,
        ),
      );
    } else if (!hasConnection) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: 350.0,
              height: 230.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                image: DecorationImage(
                  image: AssetImage("assets/images/Internet-Access-Error.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 120.0,
              height: 30.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3.0,
                  color: KPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(35.0)),
              ),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.none) {
                      Warning().errorMessage(
                        context,
                        title: "No internet connection !",
                        message: "Pleas turn on wifi or mobile data",
                        icons: Icons.signal_wifi_off,
                      );
                    } else {
                      setState(() {
                        hasConnection = true;
                      });
                      gettingChatRooms();
                    }
                  },
                  child: Text(
                    "Refresh",
                    style: KSubPrimaryButtonsFontStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasConnection = false;
      });
    } else {
      setState(() {
        hasConnection = true;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  final deleteMessageSuccessSnackBar = SnackBar(
    content: Text(
      "Message deleted successfully",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  final deleteMessageErrorSnackBar = SnackBar(
    content: Text(
      "Failed to delete message",
      style: KSnackBarContentStyle,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    backgroundColor: KPrimaryColor,
  );

  @override
  void initState() {
    super.initState();
    checkConnection();
    if (chatRooms.isEmpty) {
      gettingChatRooms();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          chatRooms.isNotEmpty) {
        setState(() {
          loading = true;
        });
        gettingMoreChatRooms();
      } else if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent) {
        setState(() {
          loading = false;
        });
      }
    });

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset >= 400) {
          _showBackToTopButton = true;
        } else {
          _showBackToTopButton = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is DeleteMessageSuccessState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(deleteMessageSuccessSnackBar);
          } else if (state is DeleteMessageErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(deleteMessageErrorSnackBar);
          }
        },
        child: hasConnection
            ? RefreshIndicator(
                backgroundColor: KSubPrimaryColor,
                color: KPrimaryColor,
                strokeWidth: 3.0,
                child: checkIfChatRoomsLoaded()
                    ? ListView.separated(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                              leading: chatRooms[index]['image'] != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'http://164.160.104.125:9090/fntat/${chatRooms[index]['image']}'),
                                      radius: 25.0,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: AssetImage(noUserImage),
                                      radius: 25.0,
                                    ),
                              title: Text(
                                '${chatRooms[index]['name']}',
                                style: KNameStyle,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        receiverID: chatRooms[index]['id']),
                                  ),
                                );
                              },
                              // subtitle: Text(
                              //   '${chatRooms[index]['email']}',
                              //   style: KPostStyle,
                              // ),
                            ),
                        separatorBuilder: (context, index) => Divider(
                              color: KSubSecondryFontsColor,
                              thickness: 0.5,
                            ),
                        itemCount: chatRooms.length)
                    : stateIndicator(),
                onRefresh: gettingChatRooms,
              )
            : internetConnection(),
      ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(
                Icons.arrow_upward,
                color: KPrimaryFontsColor,
                size: 30.0,
              ),
              backgroundColor: KPrimaryColor,
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
