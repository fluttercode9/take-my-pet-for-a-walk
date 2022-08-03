import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DBhelper {
  static final firestore = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;

  static Future<void> addToFirestore(Map<String, dynamic> pet) async {
// Add a new document with a generated ID
    firestore.collection("pets").add(pet).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  static Future<String> uploadFile(File file) async {
    final String fileName =
        DateTime.now().toIso8601String() + path.basename(file.path);
    try {
      final Reference storageRef = storage.ref(fileName);
      TaskSnapshot taskSnapshot = await storageRef.putFile(
        file,
        SettableMetadata(
          customMetadata: {
            'uploaded_by': 'A bad guy',
            'description': 'Some description...'
          },
        ),
      );

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<QueryDocumentSnapshot>> getData(String collection) async {
    final collection = await firestore.collection('pets').get();
    final data = collection.docs;
    return data;
  }
}
