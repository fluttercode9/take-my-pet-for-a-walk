import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String name;
  final String uid;
  final String? profilePictureUrl;
  final String email;
  final String phoneNumber;
  late DateTime lastActive;

  AppUser(
      {required this.email,
      required this.uid,
      required this.name,
      required this.phoneNumber,
      required this.profilePictureUrl,
      required this.lastActive});

  //  User.fromFirestore(Map<String, dynamic> json) :

  //   uid = json['id'],
  //   name = json['name'],
  //   phone= json['phone'],
  //   profileImageUrl = json['profileImageUrl'],
  //   email = json['email'],
  //   lastActive = json['lastActive'];

  factory AppUser.fromFirestore(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profilePictureUrl: json['profilePictureUrl'],
      email: json['email'],
      lastActive: json['lastActive'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "phoneNumber": phoneNumber,
      "profilePictureUrl": profilePictureUrl,
      "uid": uid,
      "lastActive": lastActive
    };
  }

  String lastDayActive() =>
      "${lastActive.month} ${lastActive.day} ${lastActive.year}";

  bool wasRecentlyActive() =>
      (DateTime.now().difference(lastActive) < Duration(hours: 1));
}
