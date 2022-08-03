import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import '../models/event.dart';

class Events with ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events {
    return [..._events];
  }

  Future<void> addEvent(Event event, File image) async {
    final imageUrl = await DBhelper.uploadFile(image);
    _events.add(event.copyWith(imageUrl: imageUrl));
    notifyListeners();
    await DBhelper.addToFirestore(
      {
        'title': event.title,
        'description': event.description,
        'location': GeoPoint(event.location.latitude, event.location.longitude),
        'imageUrl': imageUrl,
        'adress': event.location.address
      },
    );
  }

  Future<void> fetchEventsFromFirebase() async {
    final pets = await DBhelper.getData('pets');
    if (pets.isEmpty) {
      return;
    }
    pets.forEach((e) {
      final loc = e['location'] as GeoPoint;
      _events.add(Event(
          id: e.id,
          title: e['title'],
          location:
              EventLocation(latitude: loc.latitude, longitude: loc.longitude, address: e['adress']),
          imageUrl: e['imageUrl'],
          description: e['description']));
    });
    notifyListeners();
  }
}
