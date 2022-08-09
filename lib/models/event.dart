import 'dart:io';

import 'package:flutter/foundation.dart';

class EventLocation {
  final double latitude;
  final double longitude;
  final String address;

  const EventLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Event {
  final String id;
  final String title;
  final EventLocation location;
  final String imageUrl;
  final String description;
  final String ownerId;
  //final String ownerName trze to dorobic czeby nei feczowalo tak ciagle

  Event(
      {required this.ownerId,
      required this.id,
      required this.title,
      required this.location,
      required this.imageUrl,
      required this.description});

  Event copyWith(
      {
      String? ownerId,
      String? id,
      String? title,
      String? description,
      EventLocation? location,
      String? imageUrl}) {
    return Event(
        ownerId: ownerId ?? this.ownerId,
        description: description ?? this.description,
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        location: location ?? this.location,
        title: title ?? this.title);
  }
}
