import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_novel/models/genre.dart';
import 'package:my_novel/models/slideshow.dart';

class SlideshowService {
  final FirebaseFirestore _firestore;

  //constructor
  SlideshowService(
      {FirebaseFirestore? firestore, FirebaseStorage? firebaseStorage})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createSlideshow(
    String title,
    String image,
    int index,
    String novelId,
  ) async {
    await _firestore.collection('slideshows').add(
      {
        'title': title,
        'image': image,
        'index': index,
        'novel_id': novelId,
      },
    );
  }

  Future<List<SlideshowModel>> getSlideshows() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("slideshows").get();

    List<SlideshowModel> result = [];
    for (var doc in querySnapshot.docs) {
      result.add(SlideshowModel(
          id: doc.id,
          title: doc["title"],
          image: doc["image"],
          index: doc["index"],
          novelId: doc["novel_id"]));
    }
    return result;
  }
}
