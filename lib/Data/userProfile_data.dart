import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileApi {
  var dio = Dio();

  getUserFollowingFollowersCount(int id) async {
    FormData formData = FormData.fromMap({
      "user_id": 3,
    });
    try {
      // var res = await http.post(
      //     Uri.parse(
      //         "http://164.160.104.125:9090/fntat/api/number-of-followers"),
      //     body: {
      //       "user_id": "3",
      //     }).timeout(const Duration(seconds: 10));
      // final data = res.body;
      // return data;
      var res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/number-of-followers",
            data: {
              "user_id": 3,
            },
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 400;
                }),
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

  updateUserPhone(String newPhone) async {
    FormData formData = FormData.fromMap({
      "phone": newPhone,
    });

    try {
      var res = await dio
          .post(
            "http://164.160.104.125:9090/fntat/api/update-phone",
            data: formData,
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 400;
                }),
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
}
