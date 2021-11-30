import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_novel/models/genre.dart';
import 'package:my_novel/models/novel.dart';

class NovelGenreService {
  final FirebaseFirestore _firestore;

  //constructor
  NovelGenreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createNovelGenre(
    String novelId,
    String genreId,
  ) async {
    await _firestore.collection('novels_genres').add(
      {
        'novel_id': novelId,
        'genre_id': genreId,
      },
    );
  }

  Future<List<NovelModel>> getNovels(String genreId) async {
    List<String> novelIdList = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection("novels_genres")
        .where('genre_id', isEqualTo: genreId)
        .get();
    for (var doc in querySnapshot.docs) {
      novelIdList.add(doc['novel_id']);
    }

    QuerySnapshot querySnapshot2 = await _firestore
        .collection("novels")
        .where(
          '__name__',
          whereIn: novelIdList,
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
