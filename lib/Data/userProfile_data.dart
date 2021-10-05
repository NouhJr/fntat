import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fntat/Components/constants.dart';

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
            '$ServerUrl/number-of-followers',
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
            '$ServerUrl/update-phone',
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
            '$ServerUrl/update-profile',
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
            '$ServerUrl/update-profile',
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
        '$ServerUrl/update-image-profile?image',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  updateProfilePictureWeb(
    List<int> picture,
    String pictureName,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "image": MultipartFile.fromBytes(
        picture,
        filename: pictureName,
      ),
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio.post(
        '$ServerUrl/update-image-profile?image',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  updateCoverPhoto(File newPhoto) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    String fileName = newPhoto.path.split('/').last;
    FormData formData = FormData.fromMap({
      "cover_image":
          await MultipartFile.fromFile(newPhoto.path, filename: fileName),
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio.post(
        '$ServerUrl/update-cover-image-profile',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  updateCoverPhotoWeb(
    List<int> photo,
    String photoName,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "cover_image": MultipartFile.fromBytes(
        photo,
        filename: photoName,
      ),
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio.post(
        '$ServerUrl/update-cover-image-profile',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  updateBirthDate(String birthDate) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formDate = FormData.fromMap({"birth_date": birthDate});
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      var res = await dio.post(
        '$ServerUrl/update-birth-date',
        data: formDate,
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
            '$ServerUrl/change-password',
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
      final res = await dio.post(
        '$ServerUrl/profile',
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
            '$ServerUrl/profile',
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
            '$ServerUrl/number-of-followers',
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
            '$ServerUrl/add-post',
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
            '$ServerUrl/add-post',
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

  addPostWithImageWeb(
    String post,
    List<int> image,
    String imageName,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "post": post,
      "image": MultipartFile.fromBytes(
        image,
        filename: imageName,
      ),
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/add-post',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  followUser(int id) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "following_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/follow-user',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  unFollowUser(int id) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "following_id": id,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/unfollow-user',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  deletePost(int postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/delete-post/$postID',
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  editPost(String post, int postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "post": post,
      "post_id": postID,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/edit-post',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  editPostWithImage(String post, File? postImage, int postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    String fileName = postImage!.path.split('/').last;
    FormData formData = FormData.fromMap({
      "post": post,
      "image": await MultipartFile.fromFile(postImage.path, filename: fileName),
      "post_id": postID,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/edit-post',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  sharePost(String post, int postID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "post": post,
      "post_shared_id": postID,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/share-post',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  addComment(int postID, String comment) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "post_id": postID,
      "comment": comment,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/add-comment',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  deleteComment(int postID, int commentID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "comment_id": commentID,
      "post_id": postID,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/delete-comment',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  editComment(String comment, int commentID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "comment": comment,
      "comment_id": commentID,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/edit-comment',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  addReply(int postID, int commentID, String reply) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    FormData formData = FormData.fromMap({
      "post_id": postID,
      "comment_id": commentID,
      "replay_comment": reply,
    });
    dio.options.headers["authorization"] = "Bearer $token";
    try {
      final res = await dio.post(
        '$ServerUrl/add-replay-comment',
        data: formData,
      );
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  gettingHomePagePosts() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("USERID");
    var token = prefs.getString("TOKEN");

    try {
      final res = await http.post(
        Uri.parse('$ServerUrl/home-page-posts'),
        body: {"user_id": id},
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      print(data);
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  deleteMessage(var msgID) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    FormData formData = FormData.fromMap({
      "message_id": msgID,
    });
    try {
      final res =
          await dio.post('$ServerUrl/delete-send-message', data: formData);
      final data = res.data;
      return data;
    } on Exception catch (error) {
      print(error.toString());
      return 400;
    }
  }

  addCard(
      String country,
      int type,
      int category,
      String favorite,
      String height,
      String weight,
      String mainPosition,
      String otherPosition,
      File video) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    String videoName = video.path.split('/').last;
    FormData formData = FormData.fromMap({
      "country": country,
      "type": type,
      "category_id": category,
      "favorite": favorite,
      "length": height,
      "weight": weight,
      "main_position": mainPosition,
      "other_position": otherPosition,
      "user_vedio":
          await MultipartFile.fromFile(video.path, filename: videoName),
    });
    try {
      var res =
          await dio.post('$ServerUrl/update-user-card-data', data: formData);
      return res.data;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }

  addCardWeb(
    String country,
    int type,
    int category,
    String favorite,
    String height,
    String weight,
    String mainPosition,
    String otherPosition,
    List<int> video,
    String videoName,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("TOKEN");
    dio.options.headers["authorization"] = "Bearer $token";
    FormData formData = FormData.fromMap({
      "country": country,
      "type": type,
      "category_id": category,
      "favorite": favorite,
      "length": height,
      "weight": weight,
      "main_position": mainPosition,
      "other_position": otherPosition,
      "user_vedio": MultipartFile.fromBytes(
        video,
        filename: videoName,
      ),
    });
    try {
      var res =
          await dio.post('$ServerUrl/update-user-card-data', data: formData);
      return res.data;
    } on Exception catch (e) {
      print(e.toString());
      return 400;
    }
  }
}
