import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/screens/auth_screen.dart';
import 'package:okolicznie/screens/home_screen.dart';

import '../helpers/navigation_helper.dart';
import '../models/app_user.dart';

class Auth extends ChangeNotifier {
  late AppUser? user;
  late final NavigationHelper _navigator;
  static late final FirebaseAuth auth;

  Auth() {
    _navigator = GetIt.instance.get<NavigationHelper>();
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
      if (user != null) {
        DBhelper.updateUserLastSeenTime(user.uid);
        DBhelper.getUser(user.uid).then(
          (userSnap) {
            Map<String, dynamic> userData =
                userSnap.data() as Map<String, dynamic>;
            this.user = AppUser.fromFirestore(
              {
                "uid": user.uid,
                "name": userData["name"],
                "email": userData["email"],
                "phoneNumber": userData["phoneNumber"],
                "lastActive": userData["lastActive"],
                "profilePictureUrl": userData["profilePictureUrl"]
              },
            );
            _navigator.pushReplacementNamed(HomeScreen.route);
          },
        );
      } else {
        _navigator.pushReplacementNamed(AuthScreen.route);
      }
    });
  }

  static Future<void> authenticateUser(
      {required String email,
      required String password,
      required File? profilePicture,
      required String phoneNumber,
      required String name,
      required BuildContext context,
      required bool loginMode}) async {
    UserCredential res;
    try {
      if (loginMode) {
        res = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        res = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await DBhelper.firestore.collection('users').doc(res.user!.uid).set({
          "uid": res.user!.uid,
          "name": name,
          "email": email,
          "phoneNumber": phoneNumber,
          "profilePictureUrl": profilePicture != null
              ? await DBhelper.uploadPhoto(profilePicture,
                  '/images/users/${res.user!.uid}/profilePicture/')
              : 'https://i.pravatar.cc/300',
          "lastActive": DateTime.now().toUtc(),
        });
        // here is problematic part becouse photo may not be in firestore yet and we are fetching it in listener in Auth, BEWARE
        await auth.signOut();
        await auth.signInWithEmailAndPassword(email: email, password: password);
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
}
