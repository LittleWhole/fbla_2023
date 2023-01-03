import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection('students');

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  Future<String> get name => userCollection
      .doc(uid)
      .get()
      .then((doc) => (doc.get('firstname') ?? '') + ' ' + doc.get('lastname'));

  Future<String> get accountType =>
      userCollection.doc(uid).get().then((doc) => doc.get('type') ?? 'Parent');

  Future<List<dynamic>> get usersStudents =>
      userCollection.doc(uid).get().then((doc) => doc.get('students'));

  Future<String> fetchStudentName(id) => studentCollection
      .doc(id)
      .get()
      .then((doc) => (doc.get('first') ?? '') + ' ' + doc.get('last'));

  Future<String> fetchUserName(id) => userCollection
      .doc(id)
      .get()
      .then((doc) => (doc.get('firstname') ?? '') + ' ' + doc.get('lastname'));

  Future<List<dynamic>> get posts => postCollection
      //.orderBy('timestamp', descending: true)
      .get()
      .then((value) => value.docs);

  Future updateUserData(String firstname, String lastname, String type) async {
    return await userCollection.doc(uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'type': type,
    });
  }

  Future newPost(String user, String caption, List<String?> images,
      DateTime timestamp) async {
    return await postCollection.add({
      'user': user,
      'caption': caption,
      'images': images,
      'timestamp': timestamp,
      'likes': 0,
      'comments': <String, String>{},
    });
  }

  Future updatePost(String id, String user, String caption,
      List<String?> images, DateTime timestamp) async {
    return await postCollection.doc(id).set({
      'user': user,
      'caption': caption,
      'images': images,
      'timestamp': timestamp,
      'likes': 0,
      'comments': <String, String>{},
    });
  }

  // brew list from snapshot
  /*List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.data()['name'] ?? '',
        strength: doc.data()['strength'] ?? 0,
        sugars: doc.data()['sugars'] ?? '0',
      );
    }).toList();
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }*/
}
