import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;
  final String confirmPassword;
  final String phone;
  final String birthDate;

  RegisterEvent({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.birthDate,
  });

  @override
  List<Object?> get props => [
    username,
    password,
    confirmPassword,
    phone,
    birthDate,
  ];
}

class GoogleSignInEvent extends AuthEvent {}
