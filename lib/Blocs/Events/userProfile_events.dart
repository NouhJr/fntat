import 'package:equatable/equatable.dart';

class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends UserProfileEvent {}

class GettingFollowingAndFollowersCount extends UserProfileEvent {
  final int id;
  GettingFollowingAndFollowersCount({required this.id});
}

class EditPhoneButtonPressed extends UserProfileEvent {
  final String newPhone;
  EditPhoneButtonPressed({required this.newPhone});
}
