import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_novel/models/genre.dart';

class GenreService {
  final FirebaseFirestore _firestore;

  //constructor
  GenreService({FirebaseFirestore? firestore, FirebaseStorage? firebaseStorage})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createGenre(
    String name,
    String image,
    String description,
  ) async {
    await _firestore.collection('genres').add(
      {
        'name': name,
        'image': image,
        'description': description,
      },
    );
  }

  Future<List<Genre>> getGenress() async {
    QuerySnapshot querySnapshot = await _firestore.collection("genres").get();

    List<Genre> result = [];
    for (var doc in querySnapshot.docs) {
      result.add(Genre(
          id: doc.id,
          name: doc["name"],
          image: doc["image"],
          description: doc["description"]));
    }
    return result;
  }

  // Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getGenres() async {
  //   final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
  //       _firestore.collection("Genres").snapshots();
  //   return snapshots;

  //   // DocumentSnapshot<Map<String, dynamic>> userData =
  //   //     await _firestore.collection('users').doc('PpBlD7y5CYVRGKqfTpND').get();
  //   // debugPrint(userData.data()!['fullName']);
  //   // Query<Map<String, dynamic>> query = _firestore.collection("Genres");
  //   // final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
  //   //     query.snapshots();

  //   // List<Map<String, String>> genreList = [];
  //   // Query<Map<String, dynamic>> query = _firestore.collection("Genres");
  //   // final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
  //   //     query.snapshots();
  //   // snapshots.forEach((element) {
  //   //   for (var element in element.docs) {
  //   //     Map<String, String> genre = {};
  //   //     genre['id'] = element.id;
  //   //     genre['name'] = element.data()['name'];
  //   //     genre['image'] = element.data()['image'];
  //   //     genre['description'] = element.data()['description'];
  //   //     genreList.add(genre);
  //   //   }
  //   // });
  //   // debugPrint('sss');
  //   // genreList.forEach((element) {
  //   //   debugPrint('sss');
  //   // });

  //   // return genreList;
  // }
}
