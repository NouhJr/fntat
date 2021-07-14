import 'package:equatable/equatable.dart';

class UserProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileInitialState extends UserProfileState {}

class UserProfileLoadingState extends UserProfileState {}

class GettingFollowingAndFollowersCountSuccessState extends UserProfileState {
  final int followingCount;
  final int followersCount;
  GettingFollowingAndFollowersCountSuccessState(
      {required this.followingCount, required this.followersCount});
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
