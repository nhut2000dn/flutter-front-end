import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_novel/models/profile.dart';
import 'user_service.dart';

class ProfileService {
  final FirebaseFirestore _firestore;

  //constructor
  ProfileService(
      {FirebaseFirestore? firestore, FirebaseStorage? firebaseStorage})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> updatePersonalInformation(
      String id, String name, String gender) async {
    bool check = false;
    await _firestore
        .collection('profiles')
        .doc(id)
        .update({'fullName': name, 'gender': gender}).then((result) {
      check = true;
    });
    return check;
  }

  Future<bool> updateAvatar(String id, String avatar) async {
    bool check = false;
    await _firestore
        .collection('profiles')
        .doc(id)
        .update({'avatar': avatar}).then((result) {
      check = true;
    });
    return check;
  }

  Future<String> getId() async {
    final String idUser = await UserService().getUserId();
    QuerySnapshot profileData = await _firestore
        .collection('profiles')
        .where('user_id', isEqualTo: idUser)
        .get();
    return profileData.docs.first.id;
  }

  Future<Profile> getProfile() async {
    final String idUser = await UserService().getUserId();
    Profile profile = Profile();
    await _firestore
        .collection('profiles')
        .where('user_id', isEqualTo: idUser)
        .get()
        .then((value) {
      profile = Profile(
        id: value.docs.first.id,
        email: value.docs.first['email'],
        avatar: value.docs.first['avatar'],
        fullName: value.docs.first['fullName'],
        gender: value.docs.first['gender'],
        userId: value.docs.first['user_id'],
      );
    });
    return profile;
  }
}
