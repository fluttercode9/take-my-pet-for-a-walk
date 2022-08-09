import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DBhelper {
  static final firestore = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;
  static final auth = FirebaseAuth.instance;

  static Future<void> addToFirestore(Map<String, dynamic> pet) async {
// Add a new document with a generated ID
    firestore.collection("pets").add(pet).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  static Future<void> authenticateUser(
      {required String email,
      required String password,
      name,
      required BuildContext context,
      required bool loginMode}) async {
    UserCredential res;
    try {
      if (loginMode) {
        res = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        res = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        firestore.collection('users').doc(res.user!.uid).set({"name": name});
      }
    } on FirebaseAuthException catch (e) {
      var message;
      if (e.code == 'weak-password') {
        message = "za slabe haslo";
      } else if (e.code == 'email-already-in-use') {
        message = ('email w uzyciu');
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = ('Wrong password provided for that user.');
      } else {
        message = "Błąd! Sprawdź poprawność danych";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      print(e);
    }
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
      rethrow;
    }
  }

  static Future<List<QueryDocumentSnapshot>> getData(String collection) async {
    final collection = await firestore.collection('pets').get();
    final data = collection.docs;
    return data;
  }

  static Future<void> logout() async {
    await auth.signOut();
  }

  static Future<String> userName(userId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection('users').doc(userId).get();
        print('uhuhuhu');
    Map data = doc.data() as Map<String, dynamic>;
    return data['name'];
  }
}
