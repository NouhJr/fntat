import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {}

class LodingState extends AuthState {}

class SignUpsuccessState extends AuthState {}

class SignInSuccessState extends AuthState {}

class SignOutSuccessState extends AuthState {}

class AuthenticationErrorState extends AuthState {
  final String message;
  AuthenticationErrorState(this.message);
}

class ResetPasswordSuccessState extends AuthState {
  final String message;
  ResetPasswordSuccessState(this.message);
}

class ResetPasswordErrorState extends AuthState {
  final String message;
  ResetPasswordErrorState(this.message);
}

class FindByPhoneSucessState extends AuthState {
  final int userID;
  final String userName;
  FindByPhoneSucessState({required this.userID, required this.userName});
}

class FindByPhoneErrorState extends AuthState {
  final String msg;
  FindByPhoneErrorState({required this.msg});
}
