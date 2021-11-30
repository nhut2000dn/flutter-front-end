import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_novel/models/novel.dart';
import 'package:my_novel/models/profile.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateSuccess extends AuthenticationState {
  final Profile? profile;
  final List<NovelModel>? novelsFollowed;
  const AuthenticationStateSuccess(
      {this.profile, required this.novelsFollowed});
  @override
  List<Object> get props => [profile!, novelsFollowed ?? []];
  @override
  String toString() => 'AuthenticationStateSuccess, email: ${profile!.email}';

  AuthenticationStateSuccess cloneWith(
      {Profile? profile, List<NovelModel>? novelsFollowed}) {
    return AuthenticationStateSuccess(
        profile: profile ?? this.profile,
        novelsFollowed: novelsFollowed ?? this.novelsFollowed);
  }
}

class AuthenticationStateFailure extends AuthenticationState {}
