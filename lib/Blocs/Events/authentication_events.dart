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
  final String birthDate;
  final File profilePicture;
  final File coverPhoto;

  SignUpButtonPressed({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.birthDate,
    required this.profilePicture,
    required this.coverPhoto,
  });
}

class SignUpButtonPressedWeb extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String birthDate;
  final List<int> profilePicture;
  final String profilePictureName;
  final List<int> coverPhoto;
  final String coverPhotoName;

  SignUpButtonPressedWeb({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.birthDate,
    required this.profilePicture,
    required this.profilePictureName,
    required this.coverPhoto,
    required this.coverPhotoName,
  });
}

class ResetPasswordButtonPressed extends AuthEvent {
  final String newPassword;
  final String confirmPassword;
  final int userID;

  ResetPasswordButtonPressed(
      {required this.newPassword,
      required this.confirmPassword,
      required this.userID});
}

class FindByPhoneButtonPressed extends AuthEvent {
  final String phone;
  FindByPhoneButtonPressed({required this.phone});
}
