import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/User_Interface/editPost_screen.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';
import 'package:fntat/User_Interface/sharePost_screen.dart';
import 'package:fntat/User_Interface/home_screen.dart';
// import 'package:fntat/User_Interface/addComment_screen.dart';
// import 'package:fntat/User_Interface/addReplay_screen.dart';
import 'package:fntat/User_Interface/editComment_screen.dart';
// import 'package:fntat/User_Interface/commentDetails_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class PostDetailsScreen extends StatefulWidget {
  final postID;
  final likeState;
  final likeID;
  PostDetailsScreen({this.postID, this.likeState, this.likeID});
  @override
  _PostDetailsScreenState createState() =>
      _PostDetailsScreenState(pID: postID, withLiked: likeState, lID: likeID);
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final pID;
  final withLiked;
  final lID;
  _PostDetailsScreenState({required this.pID, this.withLiked, this.lID});

  ScrollController _scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();
  TextEditingController replayController = TextEditingController();

  String noPostImage = "assets/images/nopostimagehandler.jpg";
  String noUserImage = "assets/images/nouserimagehandler.jpg";
  String loggedUserImage = "assets/images/nouserimagehandler.jpg";
  List<dynamic> posts = [];
  List<dynamic> post = [];
  List<dynamic> comments = [];
  List<dynamic> userLikes = [];
  List<dynamic> tempLikesBody = [];
  List<dynamic> replies = [];
  bool useAsset = true;
  bool shrinked = false;
  bool showLoadingPost = true;
  bool showLoadingComments = true;
  bool showLoadingReplies = true;
  bool isLiked = false;
  var dio = Dio();
  var userId = 0;
  var user;
  late UserProfileBloc userProfileBloc;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLiked = withLiked;
    });
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
    gettingUserId();
    getPostData();
    getPostComments();
    getCommentReplies();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (shrinked == false) {
          setState(() {
            shrinked = true;
          });
        }
      } else {
        if (_scrollController.position.userScrollDirection ==
                ScrollDirection.forward &&
            _scrollController.position.pixels <=
                _scrollController.position.minScrollExtent) {
          if (shrinked == true) {
            setState(() {
              shrinked = false;
            });
          }
        }
      }
    });
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
          "Post",
          style: KScreenTitlesStyle,
        ),
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingUserProfileDataSuccessState) {
            setState(() {
              useAsset = false;
              loggedUserImage = state.image;
            });
          }
        },
        child: RefreshIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 3.0,
          child: ListView(
            controller: _scrollController,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              checkPostLength()
                  ? Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 2.0,
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => {
                                if (userId == posts[0]['user_id'])
                                  {
                                    Navigator.pushNamed(context, '/Profile'),
                                  }
                                else
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtherUsersProfile(
                                          userID: posts[0]['user_id'],
                                        ),
                                      ),
                                    ),
                                  }
                              },
                              child: Row(
                                children: [
                                  posts[0]['user']['image'] != null
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'http://164.160.104.125:9090/fntat/${posts[0]['user']['image']}'),
                                          radius: 25.0,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              AssetImage(noUserImage),
                                          radius: 30.0,
                                        ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${posts[0]['user']['name']}',
                                          style: KNameStyle,
                                        ),
                                        posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('00') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('01') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('02') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('03') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('04') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('05') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('06') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('07') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('08') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('09') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('10') ||
                                                posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('11')
                                            ? Text(
                                                '${posts[0]['updated_at'].toString().substring(11, 16)} AM',
                                                style: KPostTimeStyle,
                                              )
                                            : posts[0]['updated_at']
                                                    .toString()
                                                    .substring(11, 13)
                                                    .contains('12')
                                                ? Text(
                                                    '12:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                    style: KPostTimeStyle,
                                                  )
                                                : posts[0]['updated_at']
                                                        .toString()
                                                        .substring(11, 13)
                                                        .contains('13')
                                                    ? Text(
                                                        '1:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                        style: KPostTimeStyle,
                                                      )
                                                    : posts[0]['updated_at']
                                                            .toString()
                                                            .substring(11, 13)
                                                            .contains('14')
                                                        ? Text(
                                                            '2:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                            style:
                                                                KPostTimeStyle,
                                                          )
                                                        : posts[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains('15')
                                                            ? Text(
                                                                '3:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                style:
                                                                    KPostTimeStyle,
                                                              )
                                                            : posts[0]['updated_at']
                                                                    .toString()
                                                                    .substring(11, 13)
                                                                    .contains('16')
                                                                ? Text(
                                                                    '4:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                    style:
                                                                        KPostTimeStyle,
                                                                  )
                                                                : posts[0]['updated_at'].toString().substring(11, 13).contains('17')
                                                                    ? Text(
                                                                        '5:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                        style:
                                                                            KPostTimeStyle,
                                                                      )
                                                                    : posts[0]['updated_at'].toString().substring(11, 13).contains('18')
                                                                        ? Text(
                                                                            '6:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                            style:
                                                                                KPostTimeStyle,
                                                                          )
                                                                        : posts[0]['updated_at'].toString().substring(11, 13).contains('19')
                                                                            ? Text(
                                                                                '7:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                style: KPostTimeStyle,
                                                                              )
                                                                            : posts[0]['updated_at'].toString().substring(11, 13).contains('20')
                                                                                ? Text(
                                                                                    '8:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                    style: KPostTimeStyle,
                                                                                  )
                                                                                : posts[0]['updated_at'].toString().substring(11, 13).contains('21')
                                                                                    ? Text(
                                                                                        '9:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                        style: KPostTimeStyle,
                                                                                      )
                                                                                    : posts[0]['updated_at'].toString().substring(11, 13).contains('22')
                                                                                        ? Text(
                                                                                            '10:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                            style: KPostTimeStyle,
                                                                                          )
                                                                                        : posts[0]['updated_at'].toString().substring(11, 13).contains('23')
                                                                                            ? Text(
                                                                                                '11:${posts[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                style: KPostTimeStyle,
                                                                                              )
                                                                                            : posts[0]['updated_at'].toString().substring(11, 13).contains('00')
                                                                                                ? Text(
                                                                                                    '12:${posts[0]['updated_at'].toString().substring(14, 16)} AM',
                                                                                                    style: KPostTimeStyle,
                                                                                                  )
                                                                                                : Text(''),
                                      ],
                                    ),
                                  ),
                                  userId == posts[0]['user_id']
                                      ? PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            size: 25.0,
                                          ),
                                          onSelected: (e) => {
                                            postOptions(
                                              e.toString().substring(0, 9),
                                              posts[0]['id'],
                                            ),
                                          },
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
                                        )
                                      : Container(),
                                ],
                              ),
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
                                      child: Text(
                                        '${posts[0]['post']}',
                                        style: KPostStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            posts[0]['image_flag'] == 1
                                ? Container(
                                    width: double.infinity,
                                    child: displayPostImage(
                                        posts[0]['images'][0]['image']),
                                  )
                                : SizedBox(
                                    height: 5.0,
                                  ),
                            posts[0]['post_shared_id'] != null
                                ? displayPost(
                                    posts[0]['post_shared_id'],
                                  )
                                : Container(),
                            Divider(
                              color: KSubSecondryFontsColor,
                              thickness: 0.5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        '${posts[0]['likes_count'] ?? "0"} Likes',
                                        style: KLikesCommentsAndSharesCount,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${posts[0]['comments_count'] ?? "0"} Comments',
                                            style: KLikesCommentsAndSharesCount,
                                          ),
                                          Text(
                                            ' • ',
                                            style: KLikesCommentsAndSharesCount,
                                          ),
                                          Text(
                                            '${posts[0]['shares_count'] ?? "0"} Shares',
                                            style: KLikesCommentsAndSharesCount,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: KSubSecondryFontsColor,
                              thickness: 0.5,
                            ),
                            Container(
                              height: 25.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  isLiked
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.favorite,
                                            color: KWarningColor,
                                          ),
                                          iconSize: 21.0,
                                          onPressed: () {
                                            unLike(posts[0]['id'], lID);
                                            setState(() {
                                              isLiked = false;
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.heart,
                                            color: KSubSecondryFontsColor,
                                          ),
                                          iconSize: 20.0,
                                          onPressed: () {
                                            like(posts[0]['id']);
                                            setState(() {
                                              isLiked = true;
                                            });
                                          },
                                        ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.shareAlt,
                                    ),
                                    iconSize: 20.0,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SharePost(
                                            postID: posts[0]['id'],
                                            userID: posts[0]['user_id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : postStateIndicator(),
              checkCommentsLength()
                  ? ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ExpansionTile(
                        leading: comments[index]['user']['image'] != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'http://164.160.104.125:9090/fntat/${comments[index]['user']['image']}'),
                                radius: 25.0,
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(noUserImage),
                                radius: 25.0,
                              ),
                        title: InkWell(
                          onTap: () {
                            if (userId == comments[index]['user_id']) {
                              Navigator.pushNamed(context, '/Profile');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtherUsersProfile(
                                    userID: comments[index]['user_id'],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            '${comments[index]['user']['name']}',
                            style: KNameInSubPostStyle,
                          ),
                        ),
                        subtitle: Text(
                          '${comments[index]['comment']}',
                          style: KSubPostStyle,
                        ),
                        trailing: userId == comments[index]['user_id']
                            ? PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 25.0,
                                  color: KSubPrimaryFontsColor,
                                ),
                                onSelected: (t) => {
                                  commentOptions(
                                    t.toString().substring(0, 12),
                                    comments[index]['id'],
                                    comments[index]['post_id'],
                                    comments[index]['comment'],
                                  ),
                                },
                                itemBuilder: (context) {
                                  return cOptions.map((choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(
                                        choice,
                                        style: KPostOptionsStyle,
                                      ),
                                    );
                                  }).toList();
                                },
                              )
                            : Container(),
                        children: [
                          checkRepliesLength()
                              ? ListView.separated(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, pos) => ListTile(
                                    title: Text(
                                      '${replies[pos]['replay_comment']}',
                                      style: KSubPostStyle,
                                    ),
                                  ),
                                  separatorBuilder: (context, index) => Divider(
                                    color: KSubSecondryFontsColor,
                                    thickness: 0.5,
                                  ),
                                  itemCount: replies.length,
                                )
                              : repliesStateIndicator(),
                          Container(
                            margin: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                useAsset
                                    ? CircleAvatar(
                                        backgroundImage:
                                            AssetImage(loggedUserImage),
                                        radius: 20.0,
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            '$ImageServerPrefix/$loggedUserImage'),
                                        radius: 20.0,
                                      ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                  width: 250.0,
                                  height: 50.0,
                                  child: commentTextField(
                                      replayController, "Write a replay"),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      addReply(comments[index]['id']);
                                    },
                                    icon: Icon(Icons.send),
                                    color: KPrimaryColor,
                                    iconSize: 25.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     Card(
                      //       clipBehavior: Clip.antiAliasWithSaveLayer,
                      //       elevation: 2.0,
                      //       margin: EdgeInsets.symmetric(
                      //           horizontal: 8.0, vertical: 8.0),
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(10.0),
                      //         child: Column(
                      //           children: [
                      //             InkWell(
                      //               onTap: () {
                      //                 if (userId == comments[index]['user_id']) {
                      //                   Navigator.pushNamed(context, '/Profile');
                      //                 } else {
                      //                   Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           OtherUsersProfile(
                      //                         userID: comments[index]['user_id'],
                      //                       ),
                      //                     ),
                      //                   );
                      //                 }
                      //               },
                      //               child: Row(
                      //                 children: [
                      //                   comments[index]['user']['image'] != null
                      //                       ? CircleAvatar(
                      //                           backgroundImage: NetworkImage(
                      //                               'http://164.160.104.125:9090/fntat/${comments[index]['user']['image']}'),
                      //                           radius: 30.0,
                      //                         )
                      //                       : CircleAvatar(
                      //                           backgroundImage:
                      //                               AssetImage(noUserImage),
                      //                           radius: 30.0,
                      //                         ),
                      //                   SizedBox(
                      //                     width: 20.0,
                      //                   ),
                      //                   Expanded(
                      //                     child: Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Text(
                      //                           '${comments[index]['user']['name']}',
                      //                           style: KNameStyle,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   userId == comments[index]['user_id']
                      //                       ? PopupMenuButton(
                      //                           icon: Icon(
                      //                             Icons.more_vert,
                      //                             size: 25.0,
                      //                             color: KSubPrimaryFontsColor,
                      //                           ),
                      //                           onSelected: (t) => {
                      //                             commentOptions(
                      //                               t.toString().substring(0, 12),
                      //                               comments[index]['id'],
                      //                               comments[index]['post_id'],
                      //                               comments[index]['comment'],
                      //                             ),
                      //                           },
                      //                           itemBuilder: (context) {
                      //                             return cOptions.map((choice) {
                      //                               return PopupMenuItem<String>(
                      //                                 value: choice,
                      //                                 child: Text(
                      //                                   choice,
                      //                                   style: KPostOptionsStyle,
                      //                                 ),
                      //                               );
                      //                             }).toList();
                      //                           },
                      //                         )
                      //                       : Container(),
                      //                 ],
                      //               ),
                      //             ),
                      //             Divider(
                      //               color: KSubSecondryFontsColor,
                      //               thickness: 0.5,
                      //             ),
                      //             Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.start,
                      //                   children: [
                      //                     Expanded(
                      //                       child: InkWell(
                      //                         onTap: () {
                      //                           Navigator.push(
                      //                             context,
                      //                             MaterialPageRoute(
                      //                               builder: (context) =>
                      //                                   CommentDetails(
                      //                                 postID: posts[0]['id'],
                      //                                 commentID: comments[index]
                      //                                     ['id'],
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                         child: Text(
                      //                           '${comments[index]['comment']}',
                      //                           style: KPostStyle,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //             SizedBox(
                      //               height: 5.0,
                      //             ),
                      //             Divider(
                      //               color: KSubSecondryFontsColor,
                      //               thickness: 0.5,
                      //             ),
                      //             Row(
                      //               children: [
                      //                 Expanded(
                      //                   child: Row(
                      //                     children: [
                      //                       TextButton(
                      //                         child: Text(
                      //                           "Reply",
                      //                           style: KUserEmailStyle,
                      //                         ),
                      //                         onPressed: () {
                      //                           Navigator.push(
                      //                             context,
                      //                             MaterialPageRoute(
                      //                               builder: (context) =>
                      //                                   AddReplay(
                      //                                 postID: posts[0]['id'],
                      //                                 commentID: comments[index]
                      //                                     ['id'],
                      //                               ),
                      //                             ),
                      //                           );
                      //                         },
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      separatorBuilder: (context, index) => Divider(
                        color: KSubSecondryFontsColor,
                        thickness: 0.5,
                      ),
                      itemCount: comments.length,
                    )
                  : stateIndicator(),
            ],
          ),
          onRefresh: getDataOnRefresh,
        ),
      ),
      resizeToAvoidBottomInset: true,

      bottomSheet: Container(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            useAsset
                ? CircleAvatar(
                    backgroundImage: AssetImage(loggedUserImage),
                    radius: 20.0,
                  )
                : CircleAvatar(
                    backgroundImage:
                        NetworkImage('$ImageServerPrefix/$loggedUserImage'),
                    radius: 20.0,
                  ),
            SizedBox(
              width: 15.0,
            ),
            Container(
              width: 250.0,
              height: 50.0,
              child: commentTextField(commentController, "Write a comment"),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  addComment();
                },
                icon: Icon(Icons.send),
                color: KPrimaryColor,
                iconSize: 30.0,
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: shrinked
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => AddComment(
      //                 postID: pID,
      //               ),
      //             ),
      //           );
      //         },
      //         child: Icon(
      //           Icons.add,
      //           color: KPrimaryFontsColor,
      //           size: 30.0,
      //         ),
      //         backgroundColor: KPrimaryColor,
      //       )
      //     : FloatingActionButton.extended(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => AddComment(
      //                 postID: pID,
      //               ),
      //             ),
      //           );
      //         },
      //         label: Text(
      //           "Add Comment",
      //           style: KAddPostButtonStyle,
      //         ),
      //         backgroundColor: KPrimaryColor,
      //         icon: Icon(
      //           Icons.add,
      //           color: KPrimaryFontsColor,
      //           size: 30.0,
      //         ),
      //       ),
    );
  }

  ///**************************************************************************************************************************** */
  gettingUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    setState(() {
      userId = id!;
    });
  }

  getPostData() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
    try {
      final res = await dio.post(
          "http://164.160.104.125:9090/fntat/api/get-post-by-id?post_id=$pID");
      final List<dynamic> postBody = res.data['data']['data'];
      setState(() {
        posts = postBody;
      });
    } on Exception catch (error) {
      print(error.toString());
      posts = [];
    }
  }

  like(int postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
    FormData formData = FormData.fromMap({
      "post_id": postID,
    });
    try {
      await dio.post("http://164.160.104.125:9090/fntat/api/add-like",
          data: formData);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  unLike(int postID, int likeID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
    FormData formData = FormData.fromMap({
      "post_id": postID,
      "like_id": likeID,
    });
    try {
      await dio.post("http://164.160.104.125:9090/fntat/api/delete-like",
          data: formData);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getPostComments() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
    try {
      final res = await dio
          .get("http://164.160.104.125:9090/fntat/api/show-post-comments/$pID");
      final List<dynamic> commentsBody = res.data['data'];
      setState(() {
        comments = commentsBody;
      });
    } on Exception catch (error) {
      print(error.toString());
      comments = [];
    }
  }

  getCommentReplies() {
    for (var i = 0; i < comments.length; i++) {
      setState(() {
        replies.addAll(comments[i]['replay_comment']);
      });
    }
  }

  Future getDataOnRefresh() async {
    getPostData();
    getPostComments();
  }

  displayPostImage(String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350.0,
          height: 230.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
              image: NetworkImage('http://164.160.104.125:9090/fntat/$image'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  String e = "Edit post,Delete post";
  List<String> options = ['Edit post', 'Delete post'];

  postOptions(String option, var postID) {
    if (option == options[0]) {
      {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPost(
              postID: postID,
            ),
          ),
        );
      }
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: KPrimaryFontsColor,
              elevation: 1.0,
              title: Text(
                "Delete Post",
                style: TextStyle(
                  color: KSubPrimaryFontsColor,
                  fontFamily: KPrimaryFontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0,
                  height: 1.3,
                ),
              ),
              content: Text(
                "Are you sure? deleting post will remove this post from your posts",
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
                  onPressed: () async {
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
                      userProfileBloc
                          .add(DeletePostButtonPressed(postID: postID));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          });
    }
  }

  String t = "Edit comment,Delete comment";
  List<String> cOptions = ['Edit comment', 'Delete comment'];

  commentOptions(String option, var commentID, var postID, var comment) {
    if (option == cOptions[0]) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditComment(
            comment: comment,
            commentID: commentID,
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: KPrimaryFontsColor,
              elevation: 1.0,
              title: Text(
                "Delete Comment",
                style: TextStyle(
                  color: KSubPrimaryFontsColor,
                  fontFamily: KPrimaryFontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0,
                  height: 1.3,
                ),
              ),
              content: Text(
                "Are you sure? deleting comment will remove this comment from this post",
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
                  onPressed: () async {
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
                      userProfileBloc.add(
                        DeleteCommentButtonPressed(
                            postID: postID, commentID: commentID),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          });
    }
  }

  checkPostLength() {
    Future.delayed(Duration(seconds: 3));
    if (posts.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  checkCommentsLength() {
    Future.delayed(Duration(seconds: 3));
    if (comments.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  checkRepliesLength() {
    Future.delayed(Duration(seconds: 3));
    if (replies.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  repliesStateIndicator() {
    if (showLoadingReplies) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoadingReplies = false;
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
          "There's no replies for this comment yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  postStateIndicator() {
    if (showLoadingPost) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoadingPost = false;
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
          "Error loading post",
          style: KErrorStyle,
        ),
      );
    }
  }

  stateIndicator() {
    if (showLoadingComments) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        if (this.mounted) {
          setState(() {
            showLoadingComments = false;
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
          "There's no comments for this post yet",
          style: KErrorStyle,
        ),
      );
    }
  }

  gettingSharedPostData(var postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
    FormData postFormData = FormData.fromMap({
      "post_id": postID,
    });
    try {
      final postRes = await dio.post(
          "http://164.160.104.125:9090/fntat/api/get-post-by-id?post_id=$postID",
          data: postFormData);
      final List<dynamic> postsBody = postRes.data['data']['data'];
      final userData = postRes.data['data']['data'][0]['user'];
      setState(() {
        post = postsBody;
        user = userData;
      });
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  displayPost(var postID) {
    gettingSharedPostData(postID);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1.0,
      child: post.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherUsersProfile(
                            userID: user['id'],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        user['image'] == null
                            ? CircleAvatar(
                                backgroundImage: AssetImage(
                                  noUserImage,
                                ),
                                radius: 20.0,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'http://164.160.104.125:9090/fntat/${user['image']}',
                                ),
                                radius: 20.0,
                              ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user['name']}',
                                style: KNameInSubPostStyle,
                              ),
                              post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('00') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('01') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('02') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('03') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('04') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('05') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('06') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('07') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('08') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('09') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('10') ||
                                      post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('11')
                                  ? Text(
                                      '${post[0]['updated_at'].toString().substring(11, 16)} AM',
                                      style: KPostTimeStyle,
                                    )
                                  : post[0]['updated_at']
                                          .toString()
                                          .substring(11, 13)
                                          .contains('12')
                                      ? Text(
                                          '12:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                          style: KPostTimeStyle,
                                        )
                                      : post[0]['updated_at']
                                              .toString()
                                              .substring(11, 13)
                                              .contains('13')
                                          ? Text(
                                              '1:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                              style: KPostTimeStyle,
                                            )
                                          : post[0]['updated_at']
                                                  .toString()
                                                  .substring(11, 13)
                                                  .contains('14')
                                              ? Text(
                                                  '2:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                  style: KPostTimeStyle,
                                                )
                                              : post[0]['updated_at']
                                                      .toString()
                                                      .substring(11, 13)
                                                      .contains('15')
                                                  ? Text(
                                                      '3:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                      style: KPostTimeStyle,
                                                    )
                                                  : post[0]['updated_at']
                                                          .toString()
                                                          .substring(11, 13)
                                                          .contains('16')
                                                      ? Text(
                                                          '4:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                          style: KPostTimeStyle,
                                                        )
                                                      : post[0]['updated_at']
                                                              .toString()
                                                              .substring(11, 13)
                                                              .contains('17')
                                                          ? Text(
                                                              '5:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                              style:
                                                                  KPostTimeStyle,
                                                            )
                                                          : post[0]['updated_at'].toString().substring(11, 13).contains('18')
                                                              ? Text(
                                                                  '6:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                  style:
                                                                      KPostTimeStyle,
                                                                )
                                                              : post[0]['updated_at'].toString().substring(11, 13).contains('19')
                                                                  ? Text(
                                                                      '7:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                      style:
                                                                          KPostTimeStyle,
                                                                    )
                                                                  : post[0]['updated_at'].toString().substring(11, 13).contains('20')
                                                                      ? Text(
                                                                          '8:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                          style:
                                                                              KPostTimeStyle,
                                                                        )
                                                                      : post[0]['updated_at'].toString().substring(11, 13).contains('21')
                                                                          ? Text(
                                                                              '9:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                              style: KPostTimeStyle,
                                                                            )
                                                                          : post[0]['updated_at'].toString().substring(11, 13).contains('22')
                                                                              ? Text(
                                                                                  '10:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                  style: KPostTimeStyle,
                                                                                )
                                                                              : post[0]['updated_at'].toString().substring(11, 13).contains('23')
                                                                                  ? Text(
                                                                                      '11:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                      style: KPostTimeStyle,
                                                                                    )
                                                                                  : post[0]['updated_at'].toString().substring(11, 13).contains('00')
                                                                                      ? Text(
                                                                                          '12:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                          style: KPostTimeStyle,
                                                                                        )
                                                                                      : Text(''),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: KSubSecondryFontsColor,
                    thickness: 0.5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailsScreen(
                                postID: postID,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                post[0]['post'],
                                style: KSubPostStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  post[0]['image_flag'] == 1
                      ? displayPostImage(post[0]['images'][0]['image'])
                      : Container(),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: KSubPrimaryColor,
                color: KPrimaryColor,
                strokeWidth: 5.0,
              ),
            ),
    );
  }

  addComment() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (commentController.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Comment can't be empty !",
        message: 'Please type a comment.',
        icons: Icons.warning,
      );
    } else {
      userProfileBloc.add(AddCommentButtonPressed(
          postID: pID, comment: commentController.text));
      commentController.clear();
      getPostComments();
    }
  }

  addReply(var commentID) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (replayController.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Reply can't be empty !",
        message: 'Please type a reply.',
        icons: Icons.warning,
      );
    } else {
      userProfileBloc.add(AddReplyButtonPressed(
          postID: pID, commentID: commentID, reply: replayController.text));
      replayController.clear();
      getCommentReplies();
    }
  }
}
