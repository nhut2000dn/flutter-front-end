import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_novel/models/chapter.dart';
import 'package:my_novel/models/genre.dart';
import 'package:my_novel/models/novel.dart';

class ChapterService {
  final FirebaseFirestore _firestore;

  //constructor
  ChapterService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createNovelGenre(
    String title,
    int numberChapter,
    String content,
    DateTime dayRelease,
    String novelId,
  ) async {
    await _firestore.collection('chapters').add(
      {
        'title': title,
        'number_chapter': numberChapter,
        'content': content,
        'day_release': dayRelease,
        'novel_id': novelId
      },
    );
  }

  Future<List<Chapter>> getChapters(String novelId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("chapters")
        .where(
          'novel_id',
          isEqualTo: novelId,
        )
        .get();

    List<Chapter> result = [];
    for (var doc in querySnapshot.docs) {
      result.add(Chapter(
          id: doc.id,
          numberChapter: doc["number_chapter"],
          title: doc["title"],
          content: doc["content"],
          dayRelease: doc["day_release"].toDate(),
          novelId: doc["novel_id"]));
    }
    return result;
  }
}
