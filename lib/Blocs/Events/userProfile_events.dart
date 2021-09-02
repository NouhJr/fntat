import 'dart:io';
import 'package:equatable/equatable.dart';

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

class EditCoverPhotoButtonPressed extends UserProfileEvent {
  final File newPhoto;
  EditCoverPhotoButtonPressed({required this.newPhoto});
}

class EditBirthDateButtonPressed extends UserProfileEvent {
  final String birthDate;
  EditBirthDateButtonPressed({required this.birthDate});
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

class FollowButtonPressed extends UserProfileEvent {
  final userID;
  FollowButtonPressed({this.userID});
}

class UnFollowButtonPressed extends UserProfileEvent {
  final userID;
  UnFollowButtonPressed({this.userID});
}

class EditPostWithImageButtonPressed extends UserProfileEvent {
  final String post;
  final int postID;
  final File? postImage;
  EditPostWithImageButtonPressed(
      {required this.post, required this.postID, required this.postImage});
}

class EditPostButtonPressed extends UserProfileEvent {
  final String post;
  final int postID;
  EditPostButtonPressed({required this.post, required this.postID});
}

class DeletePostButtonPressed extends UserProfileEvent {
  final postID;
  DeletePostButtonPressed({this.postID});
}

class SharePostButtonPressed extends UserProfileEvent {
  final String post;
  final int postID;
  SharePostButtonPressed({required this.post, required this.postID});
}

class AddCommentButtonPressed extends UserProfileEvent {
  final int postID;
  final String comment;
  AddCommentButtonPressed({required this.postID, required this.comment});
}

class DeleteCommentButtonPressed extends UserProfileEvent {
  final int commentID;
  final int postID;
  DeleteCommentButtonPressed({required this.postID, required this.commentID});
}

class EditCommentButtonPressed extends UserProfileEvent {
  final String comment;
  final int commentID;
  EditCommentButtonPressed({required this.comment, required this.commentID});
}

class AddReplyButtonPressed extends UserProfileEvent {
  final int postID;
  final int commentID;
  final String reply;
  AddReplyButtonPressed(
      {required this.postID, required this.commentID, required this.reply});
}

class GettingHomePagePostsEvent extends UserProfileEvent {}

class DeleteMessageButtonPressed extends UserProfileEvent {
  final messageID;
  DeleteMessageButtonPressed({required this.messageID});
}

class AddCardButtonPressed extends UserProfileEvent {
  final country;
  final type;
  final category;
  final favorite;
  final mainPosition;
  final otherPosition;
  final height;
  final weight;
  final video;
  AddCardButtonPressed({
    this.country,
    this.type,
    this.category,
    this.favorite,
    this.mainPosition,
    this.otherPosition,
    this.height,
    this.weight,
    this.video,
  });
}
