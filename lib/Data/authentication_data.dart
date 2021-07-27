import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  var dio = Dio();

  signup(
      String name,
      String email,
      String phone,
      String password,
      String passwordConfirmation,
      int type,
      int category,
      File image,
      String description) async {
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "phone": phone,
      "type": type,
      "category_id": category,
      "description": description,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),
    });
    try {
      var res = await dio
          .post("http://164.160.104.125:9090/fntat/api/register",
              data: formData)
          .timeout(const Duration(seconds: 10));
      final data = res.data;
      return data;
    } on TimeoutException catch (_) {
      return 400;
    } on Exception catch (_) {
      return 400;
    }
  }

  signin(String phone, String password) async {
    try {
      var res = await http.post(
        Uri.parse(
            "http://164.160.104.125:9090/fntat/api/login?phone=$phone&password=$password"),
        body: {
          "phone": phone,
          "password": password,
        },
      ).timeout(const Duration(seconds: 10));
      final data = json.decode(res.body);
      return data;
    } on TimeoutException catch (_) {
      return 400;
    } on Exception catch (_) {
      return 400;
    }
  }

  getUserData() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/profile",
            data: formData,
          )
          .timeout(const Duration(seconds: 10));
      final data = res.data;
      return data;
    } on TimeoutException catch (err) {
      print(err.toString());
      return 400;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  signout() async {
    var deletePrefs = await SharedPreferences.getInstance();
    deletePrefs.remove("TOKEN");
    deletePrefs.remove("NAME");
    deletePrefs.remove("EMAIL");
    deletePrefs.remove("IMAGE");
    deletePrefs.remove("USERID");
    deletePrefs.remove("USERTYPE");
    deletePrefs.remove("USERSTATUS");
  }

  resetpassword(String password, String confirmPassword) async {
    Map<String, dynamic> body = {
      "password": password,
      "password_confirmation": confirmPassword,
    };
    FormData formData = FormData.fromMap(body);
    var prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt("USERID");
    try {
      var res = await dio
          .post("http://164.160.104.125:9090/fntat/api/reset-password/$userID",
              data: formData)
          .timeout(const Duration(seconds: 10));
      final data = res.data;
      return data;
    } on TimeoutException catch (_) {
      return 400;
    } on Exception catch (_) {
      return 400;
    }
  }
}
