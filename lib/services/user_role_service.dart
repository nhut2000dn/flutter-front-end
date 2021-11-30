import 'package:cloud_firestore/cloud_firestore.dart';

class UserRoleService {
  final FirebaseFirestore _firestore;
  //constructor

  UserRoleService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUsersRoles(String role, String description) async {
    await _firestore
        .collection('users_roles')
        .add({'role': role, 'description': description});
  }

  Future<String> getuserRoleId(String role) async {
    // String id = await _firestore
    //     .collection("users_roles")
    //     .where('role', isEqualTo: 'user')
    //     .get()
    //     .then((querySnapshot) => querySnapshot.docs[0].id);

    // await _firestore
    //     .collection("users_roles")
    //     .where('role', isEqualTo: 'user')
    //     .get()
    //     .then((querySnapshot) {
    //   for (var result in querySnapshot.docs) {
    //     id = result.id;
    //   }
    // });

    QuerySnapshot userData = await _firestore
        .collection('users_roles')
        .where('role', isEqualTo: role)
        .get();
    String documentId = userData.docs[0].id;

    return documentId;
  }
}
