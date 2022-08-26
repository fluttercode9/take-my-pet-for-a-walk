import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import '../models/event.dart';
import 'auth.dart';

class Events with ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events {
    return [..._events];
  }

  Future<void> addEvent(Event event, File image) async {
    final imageUrl = await DBhelper.uploadPhoto(
        image, 'images/users/${FirebaseAuth.instance.currentUser!.uid}/petsImages');
    _events.add(event.copyWith(imageUrl: imageUrl));
    notifyListeners();

    await DBhelper.addPetToFirestore(
      {
        'ownerId': FirebaseAuth.instance.currentUser!.uid,
        'title': event.title,
        'description': event.description,
        'location': GeoPoint(event.location.latitude, event.location.longitude),
        'imageUrl': imageUrl,
        'adress': event.location.address
      },
    );
  }

  Future<void> fetchEventsFromFirebase(double radius) async {
    print(radius);
    _events = [];
    final pets = await DBhelper.getPetsFromFirestore(radius);
    
    pets.forEach((e) {
      final loc = e['location'] as GeoPoint;
      _events.add(
        Event(
          ownerId: e['ownerId'],
          id: e.id,
          title: e['title'],
          location: EventLocation(
              latitude: loc.latitude,
              longitude: loc.longitude,
              address: e['adress']),
          imageUrl: e['imageUrl'],
          description: e['description'],
        ),
      );
    });
    notifyListeners();
  }
}
