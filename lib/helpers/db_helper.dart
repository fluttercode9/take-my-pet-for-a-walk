import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../providers/auth.dart';

class DBhelper {
  static final firestore = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;

  static Future<void> addPetToFirestore(Map<String, dynamic> pet) async {
// Add a new document with a generated ID
    DocumentReference ref = await firestore.collection("pets").add(pet);
    GeoFirestore geoFirestore =
        GeoFirestore(DBhelper.firestore.collection('pets'));
    await geoFirestore.setLocation(ref.id, pet['location']);
  }

  static Future<String> uploadPhoto(File file, String storagePath) async {
    final String fileName =
        DateTime.now().toIso8601String() + path.basename(file.path);
    try {
      final Reference storageRef =
          storage.ref().child('$storagePath/$fileName');
      TaskSnapshot taskSnapshot = await storageRef.putFile(
        file,
      );
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<DocumentSnapshot<Object?>>> getPetsFromFirestore(
      double radiusInKm) async {
    try {
      GeoFirestore geoFirestore = GeoFirestore(firestore.collection('pets'));

      LocationData locData = await Location().getLocation();

      GeoPoint locPoint = GeoPoint(locData.latitude!, locData.longitude!);

      print(locData);

      final List<DocumentSnapshot> documents =
          await geoFirestore.getAtLocation(locPoint, radiusInKm);

          print(documents);
      return documents;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String> userName(userId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection('users').doc(userId).get();
    Map data = doc.data() as Map<String, dynamic>;
    return data['name'];
  }

  static String getChatRoomIdByUserId(String myId, String ownerId) {
    return myId.hashCode <= ownerId.hashCode
        ? myId + '_' + ownerId
        : ownerId + '_' + myId;
  }

  static Future<String> getUserNameById(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    return doc.data()!['name'];
  }

  static Future<String> getProfilePictureUrlById(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    return doc.data()!['profilePictureUrl'] ?? "";
  }

  static Future<DocumentSnapshot> getUser(String id) async {
    return await firestore.collection('users').doc(id).get();
  }

  static Future<void> updateUserLastSeenTime(String id) async {
    await firestore
        .collection('users')
        .doc(id)
        .update({"lastActive": DateTime.now().toUtc()});
  }

  static Future<void> markChatAsRead(chatId) async {
    await firestore
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('/chats')
        .doc(chatId)
        .set({'read': true});
  }

  static Future<bool> getCurrentUserChatReadStatus(chatId) async {
    DocumentSnapshot readSnap = await DBhelper.firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(chatId)
        .get();
    Map<String, dynamic> readData = readSnap.data() as Map<String, dynamic>;
    return readData['read'];
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getStreamForChat(chatId) {
    return DBhelper.firestore
        .collection('/chats/$chatId/messages')
        .orderBy('date')
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserChatStream(
      chatId) {
    return firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(chatId)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>
      getAmounOfUnreadMessages() async {
    return await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .where('read', isEqualTo: false)
        .get();
  }
}
