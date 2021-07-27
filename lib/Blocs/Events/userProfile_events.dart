import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends UserProfileEvent {}

class GettingFollowingAndFollowersAndPostsCount extends UserProfileEvent {}

class GettingUserProfileData extends UserProfileEvent {}

class GettingOtherUsersProfileData extends UserProfileEvent {
  final userID;
  GettingOtherUsersProfileData({required this.userID});
}

class GettingOtherUsersFollowingAndFollowersAndPostsCount
    extends UserProfileEvent {
  final userID;
  GettingOtherUsersFollowingAndFollowersAndPostsCount({required this.userID});
}

class EditPhoneButtonPressed extends UserProfileEvent {
  final String newPhone;
  EditPhoneButtonPressed({required this.newPhone});
}

class EditNameButtonPressed extends UserProfileEvent {
  final String newName;
  EditNameButtonPressed({required this.newName});
}

class EditEmailButtonPressed extends UserProfileEvent {
  final String newEmail;
  EditEmailButtonPressed({required this.newEmail});
}

class EditPictureButtonPressed extends UserProfileEvent {
  final File newPicture;
  EditPictureButtonPressed({required this.newPicture});
}

class ChangePasswordButtonPressed extends UserProfileEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;
  ChangePasswordButtonPressed({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });
}

class AddNewPostButtonPressed extends UserProfileEvent {
  final String post;
  AddNewPostButtonPressed({required this.post});
}

class AddNewPostWithImageFired extends UserProfileEvent {
  final String post;
  final File? image;
  AddNewPostWithImageFired({required this.post, required this.image});
}
