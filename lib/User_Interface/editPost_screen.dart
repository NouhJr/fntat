import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:fntat/User_Interface/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditPost extends StatefulWidget {
  final postID;
  EditPost({this.postID});
  @override
  _EditPostState createState() => _EditPostState(
        id: postID,
      );
}

class _EditPostState extends State<EditPost> {
  final id;
  _EditPostState({
    required this.id,
  });
  TextEditingController _post = TextEditingController();

  // File? _image;
  bool hasImage = false;

  String image = "assets/images/nouserimagehandler.jpg";
  bool useAsset = true;

  String userName = "";

  var dio = Dio();
  List<dynamic> post = [];

  gettingPostData() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "post_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else {
      try {
        final res = await dio.post('$ServerUrl/get-post-by-id? post_id=$id',
            data: formData);
        final List<dynamic> postsBody = res.data['data']['data'];
        setState(() {
          post = postsBody;
        });
      } on Exception catch (error) {
        print(error.toString());
        setState(() {
          post = [];
        });
      }
    }
  }

  displayPostImage(String postImage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
              image: NetworkImage('$ImageServerPrefix/$postImage'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  checkPostLength() {
    Future.delayed(Duration(seconds: 3));
    if (post.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _post.dispose();
  }

  late UserProfileBloc userProfileBloc;

  @override
  void initState() {
    super.initState();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    userProfileBloc.add(GettingUserProfileData());
    gettingPostData();
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
            Navigator.pop(context),
          },
        ),
        actions: [
          Row(
            children: [
              Container(
                width: 90.0,
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: KPrimaryColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                ),
                child: Center(
                  child: InkWell(
                    onTap: editPost,
                    child: Text(
                      "Save",
                      style: KSubPrimaryButtonsFontStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is GettingUserProfileDataSuccessState) {
            setState(() {
              userName = state.name;
              if (state.image != null) {
                setState(() {
                  image = '$ImageServerPrefix/${state.image}';
                  useAsset = false;
                });
              }
            });
          } else if (state is EditPostSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          }
        },
        child: checkPostLength()
            ? Padding(
                padding: EdgeInsets.all(20.0),
                child: kIsWeb
                    ? Center(
                        child: Container(
                          width: 435.0,
                          height: double.infinity,
                          child: ListView(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      useAsset
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(image),
                                              radius: 25.0,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(image),
                                              radius: 25.0,
                                            ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          userName,
                                          style: KNameStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  postTextField(_post, "Write a new post..."),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 1.0,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              useAsset
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          AssetImage(
                                                        image,
                                                      ),
                                                      radius: 20.0,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        image,
                                                      ),
                                                      radius: 20.0,
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
                                                      userName,
                                                      style:
                                                          KNameInSubPostStyle,
                                                    ),
                                                    post[0]['updated_at'].toString().substring(11, 13).contains('00') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains(
                                                                    '01') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains(
                                                                    '02') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains(
                                                                    '03') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains(
                                                                    '04') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains(
                                                                    '05') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains(
                                                                    '06') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains(
                                                                    '07') ||
                                                            post[0]['updated_at']
                                                                .toString()
                                                                .substring(11, 13)
                                                                .contains('08') ||
                                                            post[0]['updated_at'].toString().substring(11, 13).contains('09') ||
                                                            post[0]['updated_at'].toString().substring(11, 13).contains('10') ||
                                                            post[0]['updated_at'].toString().substring(11, 13).contains('11')
                                                        ? Text(
                                                            '${post[0]['updated_at'].toString().substring(11, 16)} AM',
                                                            style:
                                                                KPostTimeStyle,
                                                          )
                                                        : post[0]['updated_at'].toString().substring(11, 13).contains('12')
                                                            ? Text(
                                                                '12:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                style:
                                                                    KPostTimeStyle,
                                                              )
                                                            : post[0]['updated_at'].toString().substring(11, 13).contains('13')
                                                                ? Text(
                                                                    '1:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                    style:
                                                                        KPostTimeStyle,
                                                                  )
                                                                : post[0]['updated_at'].toString().substring(11, 13).contains('14')
                                                                    ? Text(
                                                                        '2:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                        style:
                                                                            KPostTimeStyle,
                                                                      )
                                                                    : post[0]['updated_at'].toString().substring(11, 13).contains('15')
                                                                        ? Text(
                                                                            '3:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                            style:
                                                                                KPostTimeStyle,
                                                                          )
                                                                        : post[0]['updated_at'].toString().substring(11, 13).contains('16')
                                                                            ? Text(
                                                                                '4:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                style: KPostTimeStyle,
                                                                              )
                                                                            : post[0]['updated_at'].toString().substring(11, 13).contains('17')
                                                                                ? Text(
                                                                                    '5:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                    style: KPostTimeStyle,
                                                                                  )
                                                                                : post[0]['updated_at'].toString().substring(11, 13).contains('18')
                                                                                    ? Text(
                                                                                        '6:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                        style: KPostTimeStyle,
                                                                                      )
                                                                                    : post[0]['updated_at'].toString().substring(11, 13).contains('19')
                                                                                        ? Text(
                                                                                            '7:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                            style: KPostTimeStyle,
                                                                                          )
                                                                                        : post[0]['updated_at'].toString().substring(11, 13).contains('20')
                                                                                            ? Text(
                                                                                                '8:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                                style: KPostTimeStyle,
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
                                          Divider(
                                            color: KSubSecondryFontsColor,
                                            thickness: 0.5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      post[0]['post'],
                                                      style: KSubPostStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          post[0]['image_flag'] == 1
                                              ? displayPostImage(
                                                  post[0]['images'][0]['image'])
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  useAsset
                                      ? CircleAvatar(
                                          backgroundImage: AssetImage(image),
                                          radius: 25.0,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(image),
                                          radius: 25.0,
                                        ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      userName,
                                      style: KNameStyle,
                                    ),
                                  ),
                                ],
                              ),
                              postTextField(_post, "Write a new post..."),
                              SizedBox(
                                height: 25.0,
                              ),
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 1.0,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          useAsset
                                              ? CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                    image,
                                                  ),
                                                  radius: 20.0,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    image,
                                                  ),
                                                  radius: 20.0,
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
                                                  userName,
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
                                                            style:
                                                                KPostTimeStyle,
                                                          )
                                                        : post[0]['updated_at']
                                                                .toString()
                                                                .substring(
                                                                    11, 13)
                                                                .contains('13')
                                                            ? Text(
                                                                '1:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                style:
                                                                    KPostTimeStyle,
                                                              )
                                                            : post[0]['updated_at']
                                                                    .toString()
                                                                    .substring(
                                                                        11, 13)
                                                                    .contains(
                                                                        '14')
                                                                ? Text(
                                                                    '2:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                    style:
                                                                        KPostTimeStyle,
                                                                  )
                                                                : post[0]['updated_at'].toString().substring(11, 13).contains('15')
                                                                    ? Text(
                                                                        '3:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                        style:
                                                                            KPostTimeStyle,
                                                                      )
                                                                    : post[0]['updated_at'].toString().substring(11, 13).contains('16')
                                                                        ? Text(
                                                                            '4:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                            style:
                                                                                KPostTimeStyle,
                                                                          )
                                                                        : post[0]['updated_at'].toString().substring(11, 13).contains('17')
                                                                            ? Text(
                                                                                '5:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                style: KPostTimeStyle,
                                                                              )
                                                                            : post[0]['updated_at'].toString().substring(11, 13).contains('18')
                                                                                ? Text(
                                                                                    '6:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                    style: KPostTimeStyle,
                                                                                  )
                                                                                : post[0]['updated_at'].toString().substring(11, 13).contains('19')
                                                                                    ? Text(
                                                                                        '7:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                        style: KPostTimeStyle,
                                                                                      )
                                                                                    : post[0]['updated_at'].toString().substring(11, 13).contains('20')
                                                                                        ? Text(
                                                                                            '8:${post[0]['updated_at'].toString().substring(14, 16)} PM',
                                                                                            style: KPostTimeStyle,
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
                                      Divider(
                                        color: KSubSecondryFontsColor,
                                        thickness: 0.5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  post[0]['post'],
                                                  style: KSubPostStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      post[0]['image_flag'] == 1
                                          ? displayPostImage(
                                              post[0]['images'][0]['image'])
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  editPost() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_post.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Post can't be empty !",
        message: 'Please type a post.',
        icons: Icons.warning,
      );
    } else {
      userProfileBloc.add(EditPostButtonPressed(post: _post.text, postID: id));
    }
  }
}
