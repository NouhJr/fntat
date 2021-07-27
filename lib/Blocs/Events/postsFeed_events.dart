import 'package:equatable/equatable.dart';

class PostsFeedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends PostsFeedEvent {}

class GettingPosts extends PostsFeedEvent {
  // final String userID;
  // GettingPosts({required this.userID});
}
