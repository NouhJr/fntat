import 'package:equatable/equatable.dart';

class PostsFeedState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostsFeedInitialState extends PostsFeedState {}

class PostsFeedSuccessState extends PostsFeedState {
  final posts;
  PostsFeedSuccessState({required this.posts});
}

class PostsFeedErrorState extends PostsFeedState {}
