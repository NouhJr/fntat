import 'package:equatable/equatable.dart';

class UserProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileInitialState extends UserProfileState {}

class UserProfileLoadingState extends UserProfileState {}

class GettingFollowingAndFollowersCountSuccessState extends UserProfileState {
  final followingCount;
  final followersCount;
  final postsCount;
  GettingFollowingAndFollowersCountSuccessState(
      {required this.followingCount,
      required this.followersCount,
      required this.postsCount});
}

class GettingFollowingAndFollowersCountErrorState extends UserProfileState {}

class UpdatePhoneSuccessState extends UserProfileState {
  final String message;
  UpdatePhoneSuccessState({required this.message});
}

class UpdatePhoneErrorState extends UserProfileState {
  final String message;
  UpdatePhoneErrorState({required this.message});
}

class UpdateNameSuccessState extends UserProfileState {
  final String message;
  UpdateNameSuccessState({required this.message});
}

class UpdateNameErrorState extends UserProfileState {
  final String message;
  UpdateNameErrorState({required this.message});
}

class UpdateEmailSuccessState extends UserProfileState {
  final String message;
  UpdateEmailSuccessState({required this.message});
}

class UpdateEmailErrorState extends UserProfileState {
  final String message;
  UpdateEmailErrorState({required this.message});
}

class GettingUserProfileDataSuccessState extends UserProfileState {
  final name;
  final email;
  final phone;
  final image;
  final coverPhoto;
  final type;
  final category;
  final country;
  final legOrHand;
  final birthDate;
  final height;
  final weight;
  final mainPosition;
  final otherPosition;
  GettingUserProfileDataSuccessState({
    this.name,
    this.email,
    this.phone,
    this.image,
    this.coverPhoto,
    this.type,
    this.category,
    this.country,
    this.legOrHand,
    this.birthDate,
    this.height,
    this.weight,
    this.mainPosition,
    this.otherPosition,
  });
}

class GettingUserProfileDataErrorState extends UserProfileState {
  final String msg;
  GettingUserProfileDataErrorState({required this.msg});
}

class ChangePasswordSuccessState extends UserProfileState {
  final String message;
  ChangePasswordSuccessState({required this.message});
}

class ChangePasswordErrorState extends UserProfileState {
  final String message;
  ChangePasswordErrorState({required this.message});
}

class GettingOtherUserProfileDataSuccessState extends UserProfileState {
  final name;
  final email;
  final phone;
  final image;
  GettingOtherUserProfileDataSuccessState(
      {required this.name,
      required this.email,
      required this.phone,
      required this.image});
}

class GettingOtherUserProfileDataErrorState extends UserProfileState {
  final String msg;
  GettingOtherUserProfileDataErrorState({required this.msg});
}

class GettingOtherFollowingAndFollowersCountSuccessState
    extends UserProfileState {
  final followingCount;
  final followersCount;
  final postsCount;
  GettingOtherFollowingAndFollowersCountSuccessState(
      {required this.followingCount,
      required this.followersCount,
      required this.postsCount});
}

class GettingOtherFollowingAndFollowersCountErrorState
    extends UserProfileState {}

class UpdatePictureSuccessState extends UserProfileState {
  final String message;
  UpdatePictureSuccessState({required this.message});
}

class UpdatePictureErrorState extends UserProfileState {
  final String message;
  UpdatePictureErrorState({required this.message});
}

class UpdateCoverPhotoSuccessState extends UserProfileState {}

class UpdateCoverPhotoErrorState extends UserProfileState {}

class UpdateBirthDateSuccessState extends UserProfileState {
  final String message;
  UpdateBirthDateSuccessState({required this.message});
}

class UpdateBirthDateErrorState extends UserProfileState {
  final String message;
  UpdateBirthDateErrorState({required this.message});
}

class AddPostSuccessState extends UserProfileState {}

class AddPostErrorState extends UserProfileState {}

class FollowUserSuccessState extends UserProfileState {}

class FollowUserErrorState extends UserProfileState {
  final msg;
  FollowUserErrorState({this.msg});
}

class UnFollowUserSuccessState extends UserProfileState {}

class UnFollowUserErrorState extends UserProfileState {}

class DeletePostSuccessState extends UserProfileState {}

class DeletePostErrorState extends UserProfileState {}

class EditPostSuccessState extends UserProfileState {}

class EditPostErrorState extends UserProfileState {}

class SharePostSuccessState extends UserProfileState {}

class SharePostErrorState extends UserProfileState {}

class AddCommentSuccessState extends UserProfileState {}

class AddCommentErrorState extends UserProfileState {}

class DeleteCommentSuccessState extends UserProfileState {}

class DeleteCommentErrorState extends UserProfileState {}

class EditCommentSuccessState extends UserProfileState {}

class EditCommentErrorState extends UserProfileState {}

class AddReplySuccessState extends UserProfileState {}

class AddReplyErrorState extends UserProfileState {}

class GettingHomePagePostsSuccessState extends UserProfileState {
  final List<dynamic> posts;
  GettingHomePagePostsSuccessState({required this.posts});
}

class GettingHomePagePostsErrorState extends UserProfileState {
  final String error;
  GettingHomePagePostsErrorState({required this.error});
}

class DeleteMessageSuccessState extends UserProfileState {}

class DeleteMessageErrorState extends UserProfileState {}

class AddCardSuccessState extends UserProfileState {}

class AddCardErrorState extends UserProfileState {}
