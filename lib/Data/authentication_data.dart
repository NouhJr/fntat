import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  var dio = Dio();

  signup(String name, String email, String phone, String password,
      String passwordConfirmation, int type, int category) async {
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "phone": phone,
      "type": type,
      "category_id": category,
    };
    FormData formData = FormData.fromMap(body);
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
    Map<String, dynamic> body = {
      "phone": phone,
      "password": password,
    };
    FormData formData = FormData.fromMap(body);
    try {
      var res = await dio
          .post(
              "http://164.160.104.125:9090/fntat/api/login?phone=$phone&password=$password",
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

  signout() async {
    var deletePrefs = await SharedPreferences.getInstance();
    deletePrefs.remove("TOKEN");
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
