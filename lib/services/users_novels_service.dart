import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_novel/models/novel.dart';

class UsersNovelsService {
  final FirebaseFirestore _firestore;

  //constructor
  UsersNovelsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createUserNovel(String userId, String novelId) async {
    String status = 'error';
    await _firestore
        .collection('users_novels')
        .where('user_id', isEqualTo: userId)
        .where('novel_id', isEqualTo: novelId)
        .get()
        .then(
          (value) async => {
            if (value.docs.isNotEmpty)
              {
                await _firestore
                    .collection('users_novels')
                    .doc(value.docs.first.id)
                    .delete()
                    .then(
                  (result) {
                    status = 'deleted';
                  },
                )
              }
            else
              {
                await _firestore.collection('users_novels').add({
                  'user_id': userId,
                  'novel_id': novelId,
                }).then(
                  (result) {
                    status = 'created';
                  },
                )
              }
          },
        );
    return status;
  }

  Future<bool> checkIsFollowed(String userId, String novelId) async {
    bool isFollow = false;
    await _firestore
        .collection('users_novels')
        .where('user_id', isEqualTo: userId)
        .where('novel_id', isEqualTo: novelId)
        .get()
        .then(
          (value) async => {
            if (value.docs.isNotEmpty) {isFollow = true}
          },
        );
    return isFollow;
  }

  Future<List<NovelModel>?> getNovels(String userId) async {
    List<String> novelIds = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection("users_novels")
        .where('user_id', isEqualTo: userId)
        .get();
    for (var doc in querySnapshot.docs) {
      novelIds.add(doc['novel_id']);
    }

    if (novelIds.isNotEmpty) {
      QuerySnapshot querySnapshot2 = await _firestore
          .collection("novels")
          .where(
            '__name__',
            whereIn: novelIds,
          )
          .get();

      List<NovelModel> result = [];
      for (var doc in querySnapshot2.docs) {
        result.add(
          NovelModel(
              id: doc.id,
              name: doc["name"],
              image: doc["image"],
              description: doc["description"],
              status: doc["status"],
              chapter: doc["chapter"],
              reader: doc["reader"],
              follower: doc["follower"],
              yearRelease: doc["year_release"],
              authorId: doc["author_id"]),
        );
      }
      return result;
    }
  }
}
