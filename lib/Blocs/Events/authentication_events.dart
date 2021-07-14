import 'dart:io';

import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends AuthEvent {}

class SignInButtonPressed extends AuthEvent {
  final String phone;
  final String password;
  SignInButtonPressed({required this.phone, required this.password});
}

class SignOutButtonPressed extends AuthEvent {}

class SignUpButtonPressed extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final int type;
  final int category;
  final File image;
  final String description;

  SignUpButtonPressed({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.type,
    required this.category,
    required this.image,
    required this.description,
  });
}

class ResetPasswordButtonPressed extends AuthEvent {
  final String newPassword;
  final String confirmPassword;

  ResetPasswordButtonPressed(
      {required this.newPassword, required this.confirmPassword});
}
