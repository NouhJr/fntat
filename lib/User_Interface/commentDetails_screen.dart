import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:dio/dio.dart';
import 'package:fntat/User_Interface/editPost_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/User_Interface/sharePost_screen.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:fntat/Components/constants.dart';

class CommentDetails extends StatefulWidget {
  final postID;
  final commentID;
  CommentDetails({this.postID, this.commentID});
  @override
  _CommentDetailsState createState() =>
      _CommentDetailsState(pID: postID, cID: commentID);
}

class _CommentDetailsState extends State<CommentDetails> {
  final pID;
  final cID;
  _CommentDetailsState({required this.pID, required this.cID});

  ScrollController _scrollController = ScrollController();
  List<dynamic> post = [];
  List<dynamic> replays = [];
  var dio = Dio();

  checkPostLength() {
    Future.delayed(Duration(seconds: 4));
    if (post.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  checkReplaiesLength() {
    Future.delayed(Duration(seconds: 2));
    if (replays.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        backgroundColor: KSubPrimaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: KPrimaryColor,
            size: 30.0,
          ),
          onPressed: () => {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false),
          },
        ),
        title: Text(
          "Comment",
          style: KScreenTitlesStyle,
        ),
      ),
      body: checkPostLength()
          ? ListView(
              controller: _scrollController,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${post[0]['user']['name']}',
                                    style: KNameStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Divider(
                          color: KSubSecondryFontsColor,
                          thickness: 0.5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      '${post[0]['comment']}',
                                      style: KPostStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                checkReplaiesLength()
                    ? ListView.separated(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 2.0,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {},
                                                child: Text(
                                                  '${replays[index]['replay_comment']}',
                                                  style: KPostStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        separatorBuilder: (context, index) => Divider(
                          color: KSubSecondryFontsColor,
                          thickness: 0.5,
                        ),
                        itemCount: replays.length,
                      )
                    : Center(
                        child: Text(
                          "There's no replaies for this post yet",
                          style: KErrorStyle,
                        ),
                      ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: KSubPrimaryColor,
                color: KPrimaryColor,
                strokeWidth: 5.0,
              ),
            ),
      resizeToAvoidBottomInset: true,
    );
  }

  ///****************************************************************************************************************************

  getComments() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.get(
          "http://164.160.104.125:9090/fntat/api/show-post-comments-replays/$pID");
      final List<dynamic> postBody = res.data['data'];
      Future.delayed(Duration(seconds: 2));
      getOneCommentWithReplays(postBody);
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  getOneCommentWithReplays(List<dynamic> list) {
    for (var i = 0; i < list.length; i++) {
      if (cID == list[i]['id']) {
        setState(() {
          post.add(list[i]);
          replays = list[i]['replay_comment'];
        });
      }
    }
  }

  String t = "Edit comment,Delete comment";
  List<String> cOptions = ['Edit comment', 'Delete comment'];

  commentOptions(String option, var commentID, var postID, var comment) {
    // if (option == cOptions[0]) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => EditComment(
    //         comment: comment,
    //         commentID: commentID,
    //       ),
    //     ),
    //   );
    // } else {
    //   showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           backgroundColor: KPrimaryFontsColor,
    //           elevation: 1.0,
    //           title: Text(
    //             "Delete Comment",
    //             style: TextStyle(
    //               color: KSubPrimaryFontsColor,
    //               fontFamily: KPrimaryFontFamily,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 21.0,
    //               height: 1.3,
    //             ),
    //           ),
    //           content: Text(
    //             "Are you sure? deleting comment will remove this comment from this post",
    //             style: TextStyle(
    //               color: KSubPrimaryFontsColor,
    //               fontFamily: KPrimaryFontFamily,
    //               fontWeight: FontWeight.w400,
    //               fontSize: 18.0,
    //               height: 1.3,
    //             ),
    //           ),
    //           actions: [
    //             TextButton(
    //               child: Text(
    //                 'Cancel',
    //                 style: TextStyle(
    //                   color: KSubPrimaryFontsColor,
    //                   fontFamily: KPrimaryFontFamily,
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 18.0,
    //                   height: 1.3,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //             ),
    //             TextButton(
    //               child: Text(
    //                 'Ok',
    //                 style: TextStyle(
    //                   color: KSubPrimaryFontsColor,
    //                   fontFamily: KPrimaryFontFamily,
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 18.0,
    //                   height: 1.3,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 userProfileBloc.add(
    //                   DeleteCommentButtonPressed(
    //                       postID: postID, commentID: commentID),
    //                 );
    //                 Navigator.pop(context);
    //               },
    //             ),
    //           ],
    //         );
    //       });
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
