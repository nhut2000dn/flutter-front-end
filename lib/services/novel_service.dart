import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_novel/models/novel.dart';

class NovelService {
  final FirebaseFirestore _firestore;

  //constructor
  NovelService({FirebaseFirestore? firestore, FirebaseStorage? firebaseStorage})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createNovel(
      String name,
      String image,
      String description,
      bool status,
      int chapter,
      int reader,
      int follower,
      int yearRelease,
      String authorId) async {
    await _firestore.collection('novels').add(
      {
        'name': name,
        'image': image,
        'description': description,
        'status': status,
        'chapter': chapter,
        'reader': reader,
        'follower': follower,
        'year_release': yearRelease,
        'author_id': authorId
      },
    );
  }

  Future<List<NovelModel>> getNovelsNew() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('novels')
        .orderBy('year_release', descending: true)
        .get();

    List<NovelModel> novels = [];
    for (var doc in querySnapshot.docs) {
      novels.add(NovelModel(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          description: doc['description'],
          status: doc['status'],
          chapter: doc['chapter'],
          reader: doc['reader'],
          follower: doc['follower'],
          yearRelease: doc['year_release'],
          authorId: doc['author_id']));
    }
    return novels;
  }

  Future<NovelModel> getNovelById(String id) async {
    late NovelModel novel;
    await _firestore.collection('novels').doc(id).get().then((value) {
      novel = NovelModel(
          id: value.id,
          name: value['name'],
          image: value['image'],
          description: value['description'],
          status: value['status'],
          chapter: value['chapter'],
          reader: value['reader'],
          follower: value['follower'],
          yearRelease: value['year_release'],
          authorId: value['author_id']);
    });
    return novel;
  }

  Future<List<NovelModel>> getTop10Novels() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('novels')
        .orderBy('reader', descending: true)
        .limit(10)
        .get();

    List<NovelModel> novels = [];
    for (var doc in querySnapshot.docs) {
      novels.add(NovelModel(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          description: doc['description'],
          status: doc['status'],
          chapter: doc['chapter'],
          reader: doc['reader'],
          follower: doc['follower'],
          yearRelease: doc['year_release'],
          authorId: doc['author_id']));
    }
    return novels;
  }

  Future<List<NovelModel>> get5NovelsNew() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('novels')
        .orderBy('year_release', descending: true)
        .limit(5)
        .get();

    List<NovelModel> novels = [];
    for (var doc in querySnapshot.docs) {
      novels.add(NovelModel(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          description: doc['description'],
          status: doc['status'],
          chapter: doc['chapter'],
          reader: doc['reader'],
          follower: doc['follower'],
          yearRelease: doc['year_release'],
          authorId: doc['author_id']));
    }
    return novels;
  }

  Future<List<NovelModel>> getTop5NovelsFollower() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('novels')
        .orderBy('follower', descending: true)
        .limit(10)
        .get();

    List<NovelModel> novels = [];
    for (var doc in querySnapshot.docs) {
      novels.add(NovelModel(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          description: doc['description'],
          status: doc['status'],
          chapter: doc['chapter'],
          reader: doc['reader'],
          follower: doc['follower'],
          yearRelease: doc['year_release'],
          authorId: doc['author_id']));
    }
    return novels;
  }

  Future<List<NovelModel>> getTopNovelsFollower() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('novels')
        .orderBy('follower', descending: true)
        .get();

    List<NovelModel> novels = [];
    for (var doc in querySnapshot.docs) {
      novels.add(NovelModel(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          description: doc['description'],
          status: doc['status'],
          chapter: doc['chapter'],
          reader: doc['reader'],
          follower: doc['follower'],
          yearRelease: doc['year_release'],
          authorId: doc['author_id']));
    }
    return novels;
  }

  Future<List<NovelModel>> search(String query) async {
    List<NovelModel> novels = [];
    // var queryNew = query.split('');
    // int i = 0;
    // for (var element in queryNew) {
    //   queryNew[i] = element + '~';
    //   i++;
    // }
    // debugPrint(queryNew.toString());
    QuerySnapshot querySnapshot = await _firestore
        .collection('novels')
        .where('name', isGreaterThanOrEqualTo: query.toUpperCase())
        .where('name', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
        .get();
    for (var doc in querySnapshot.docs) {
      novels.add(NovelModel(
          id: doc.id,
          name: doc['name'],
          image: doc['image'],
          description: doc['description'],
          status: doc['status'],
          chapter: doc['chapter'],
          reader: doc['reader'],
          follower: doc['follower'],
          yearRelease: doc['year_release'],
          authorId: doc['author_id']));
    }
    return novels;
  }

  Future updateView(String id) async {
    await _firestore
        .collection('novels')
        .doc(id)
        .update({"reader": FieldValue.increment(1)});
  }

  Future<bool> updateFollowerIncrement(String id) async {
    bool check = false;
    await _firestore.collection('novels').doc(id).update(
        {"follower": FieldValue.increment(1)}).then((value) => check = true);
    return check;
  }

  Future<bool> updateFollowerDecrement(String id) async {
    bool check = false;
    await _firestore.collection('novels').doc(id).update(
        {"follower": FieldValue.increment(-1)}).then((value) => check = true);
    return check;
  }
}
