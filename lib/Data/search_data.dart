import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/User_Interface/otherUsersProfile_screen.dart';

class SearchBar extends SearchDelegate<SearchedUsers> {
  var dio = Dio();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  var image =
      "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg?itok=PANMBJF-";

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<SearchedUsers>>(
      future: search(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    height: 100.0,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5.0,
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(image),
                          radius: 25.0,
                        ),
                        title: Text(
                          snapshot.data?[index].name ?? "",
                          style: KNameStyle,
                        ),
                        subtitle: Text(
                          snapshot.data?[index].email ?? "",
                          style: KUserEmailStyle,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherUsersProfile(
                                        userID:
                                            snapshot.data?[index].userID ?? 0,
                                      )));
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: snapshot.data?.length ?? 0,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: KSubPrimaryColor,
              color: KPrimaryColor,
              strokeWidth: 5.0,
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Future<List<SearchedUsers>> search() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    FormData formData = FormData.fromMap({
      "name": query,
    });
    try {
      final res = await dio.post(
          "http://164.160.104.125:9090/fntat/api/search-user",
          data: formData);
      final body = res.data;
      final list = body['data'] as List;
      return list.map((e) => SearchedUsers.fromJson(e)).toList();
    } on Exception catch (error) {
      print(error.toString());
      return [];
    }
  }
}

class SearchedUsers {
  String name;
  String email;
  String image;
  var userID;
  SearchedUsers({
    required this.name,
    required this.email,
    required this.image,
    required this.userID,
  });

  factory SearchedUsers.fromJson(Map<String, dynamic> json) => SearchedUsers(
        name: json['name'],
        email: json['email'],
        image: json['image'],
        userID: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'image': image,
        'id': userID,
      };
}
