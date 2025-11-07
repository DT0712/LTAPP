import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterSubmitted(this.name, this.email, this.password);

  @override
  List<Object?> get props => [name, email, password];
}
