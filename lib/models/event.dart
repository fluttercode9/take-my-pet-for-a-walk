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

  Event(
      {required this.id,
      required this.title,
      required this.location,
      required this.imageUrl,
      required this.description});

  Event copyWith(
      {String? id,
      String? title,
      String? description,
      EventLocation? location,
      String? imageUrl}) {
    return Event(
        description: description ?? this.description,
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        location: location ?? this.location,
        title: title ?? this.title);
  }
}
