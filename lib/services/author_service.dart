import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_novel/models/author.dart';

class AuthorService {
  final FirebaseFirestore _firestore;

  //constructor
  AuthorService(
      {FirebaseFirestore? firestore, FirebaseStorage? firebaseStorage})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createAuthor(
      String name, String description, String avatar) async {
    await _firestore.collection('authors').add(
      {'name': name, 'description': description, 'avatar': avatar},
    );
  }

  Future<Author> getAuthor(String id) async {
    DocumentSnapshot<Map<String, dynamic>> authorData =
        await _firestore.collection('authors').doc(id).get();
    return Author(
      id: authorData.id,
      name: authorData.data()!['name'],
      image: authorData.data()!['avatar'],
      description: authorData.data()!['description'],
    );
  }
}
