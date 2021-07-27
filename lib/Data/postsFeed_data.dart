import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsData {
  var dio = Dio();

  gettingPosts() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";

    try {
      final res = await dio.post(
          "http://164.160.104.125:9090/fntat/api/home-page-posts",
          data: formData);
      final body = res.data['data']['data'];
      // final list = body['data']['data'] as List;

      // List<Posts> posts = list.map((e) => Posts.fromJson(e)).toList();
      // return posts;
      return body;
    } on Exception catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<List<Posts>> getUserOwnedPosts() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";

    try {
      final res = await dio.post(
          "http://164.160.104.125:9090/fntat/api/user-owned-posts",
          data: formData);
      final body = res.data;
      final list = body['data']['data'] as List;

      List<Posts> posts = list.map((e) => Posts.fromJson(e)).toList();
      return posts;
    } on Exception catch (error) {
      print(error.toString());
      return [];
    }
  }
}

class Posts {
  var id;
  var userId;
  var post;
  var images;
  var likesCount;
  var commentsCount;
  var sharesCount;
  var userName;
  var postDate;
  Posts({
    required this.id,
    required this.userId,
    required this.post,
    required this.images,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.userName,
    required this.postDate,
  });

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        id: json['id'],
        userId: json['user_id'],
        userName: json['user'],
        postDate: json['updated_at'],
        post: json['post'],
        images: json['images'],
        likesCount: json['likes_count'],
        commentsCount: json['comments_count'],
        sharesCount: json['shares_count'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'post': post,
        'images': images,
        'likes_count': likesCount,
        'comments_count': commentsCount,
        'shares_count': sharesCount,
      };
}
