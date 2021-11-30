import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEventEmailChanged extends LoginEvent {
  final String email;
  //constructor
  const LoginEventEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'Email changed: $email';
}

class LoginEventPasswordChanged extends LoginEvent {
  final String password;
  //constructor
  const LoginEventPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'Password changed: $password';
}

//press "Sign in with Google"
class LoginEventWithGooglePressed extends LoginEvent {}

class LoginEventWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;
  const LoginEventWithEmailAndPasswordPressed(
      {required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() =>
      'LoginEventWithEmailAndPasswordPressed, email = $email, password = $password';
}
