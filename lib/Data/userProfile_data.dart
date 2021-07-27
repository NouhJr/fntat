import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileApi {
  var dio = Dio();

  getUserFollowingFollowersCount() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      Future.delayed(Duration(seconds: 3));
      final res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/number-of-followers",
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

  updateUserPhone(String newPhone) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "phone": newPhone,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/update-phone",
            data: formData,
          )
          .timeout(const Duration(seconds: 10));
      final data = res.data;
      return data;
    } on TimeoutException catch (e) {
      print(e.toString());
      return 400;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  updateUserName(String newName) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "name": newName,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/update-profile",
            data: formData,
          )
          .timeout(const Duration(seconds: 10));
      final data = res.data;
      return data;
    } on TimeoutException catch (e) {
      print(e.toString());
      return 400;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  updateUserEmail(String newEmail) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "email": newEmail,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/update-profile",
            data: formData,
          )
          .timeout(const Duration(seconds: 10));
      final data = res.data;
      return data;
    } on TimeoutException catch (e) {
      print(e.toString());
      return 400;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  updateUserPicture(File newImage) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    String fileName = newImage.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(newImage.path, filename: fileName),
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio.post(
        "http://164.160.104.125:9090/fntat/api/update-image-profile?image",
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  changePassword(
      String oldPassword, String newPassword, String confirmNewPassword) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_new_password": confirmNewPassword,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/change-password",
            data: formData,
          )
          .timeout(const Duration(seconds: 10));
      final data = res.data;
      return data;
    } on TimeoutException catch (e) {
      print(e.toString());
      return 400;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  gettingUserProfileData() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      Future.delayed(Duration(seconds: 3));
      final res = await dio.post(
        "http://164.160.104.125:9090/fntat/api/profile",
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  gettingOtherUsersProfileData(var id) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      Future.delayed(Duration(seconds: 3));
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

  getOtherUsersFollowingFollowersCount(var id) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "user_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      Future.delayed(Duration(seconds: 3));
      final res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/number-of-followers",
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

  addPost(String post) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "post": post,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/add-post",
            data: formData,
          )
          .timeout(const Duration(seconds: 20));
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

  addPostWithImage(String post, File? image) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    String fileName = image!.path.split('/').last;
    FormData formData = FormData.fromMap({
      "post": post,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/add-post",
            data: formData,
          )
          .timeout(const Duration(seconds: 20));
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
}
