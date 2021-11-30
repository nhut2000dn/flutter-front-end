import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'user_role_service.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  //constructor

  UserService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email.trim(), password: password)
        .then((dynamic user) async {
      String uid = user.user.uid;
      String email = user.user.email;
      _firestore.collection('profiles').add({
        'email': email,
        'fullName': '',
        'gender': '',
        'avatar': '',
        'user_role_id': await UserRoleService().getuserRoleId('user'),
        'user_id': uid
      });
    }).catchError((error) {});
  }

  Future<void> signOut() async {
    Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser!;
  }

  Future<String> getUserId() async {
    var uid = validateToken(await _firebaseAuth.currentUser!.getIdToken());
    return uid;
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    late bool check = false;
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    try {
      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(newPassword).then((_) {
          check = true;
          debugPrint('done');
        }).catchError((error) {
          check = false;
          debugPrint('wrong');
        });
      });
    } on FirebaseAuthException {
      check = false;
    }
    return check;
  }

  String validateToken(String token) {
    bool isExpired = Jwt.isExpired(token);

    if (isExpired) {
      return 'null';
    } else {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      return payload['user_id'];
    }
  }
}
