import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadImage({
    required String filePath,
    required File imageFile,
  }) async {
    try {
      await _firebaseStorage.ref(filePath).putFile(imageFile);
      return await _firebaseStorage.ref(filePath).getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String?>> uploadImages({
    required String filePath,
    required List<File> imageFiles,
  }) async {
    List<String?> urls = [];
    for (int i = 0; i < imageFiles.length; i++) {
      try {
        await _firebaseStorage
            .ref(filePath + i.toString())
            .putFile(imageFiles[i]);
        urls.add(await _firebaseStorage
            .ref(filePath + i.toString())
            .getDownloadURL());
      } on FirebaseException catch (e) {
        print(e);
        urls.add(null);
      }
    }
    return urls;
  }

  Future<void> deleteImage({required String filePath}) async {
    try {
      await _firebaseStorage.ref(filePath).delete();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
