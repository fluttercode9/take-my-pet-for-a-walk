import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:okolicznie/models/event.dart';
import 'package:okolicznie/screens/map_screen.dart';
import "../helpers/location_helper.dart";

class LocationInput extends StatefulWidget {
  final Function changeState;
  final Function editEvent;
  LocationInput({Key? key, required this.changeState, required this.editEvent})
      : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewUrl;
  bool _isLoading = false;

  Widget _mapBuilder() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_previewUrl != null) return Image.network(_previewUrl!);
    return const Center(
      child: Icon(
        Icons.location_on,
        color: Colors.indigo,
        size: 150,
        shadows: [Shadow(color: Colors.black, blurRadius: 10)],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final locData = await Location().getLocation();
      setState(
        () {
          _previewUrl = LocationHelper.generateLocationPreviewImage(
              longitude: locData.longitude!, latitude: locData.latitude!);
        },
      );
      String adress = await LocationHelper.generateAdressString(
          LatLng(locData.latitude!, locData.longitude!));

      widget.editEvent(
        location: EventLocation(
            latitude: locData.latitude!,
            longitude: locData.longitude!,
            address: adress),
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _getLocationFromMap() async {
    EventLocation? selectedLocation = await Navigator.of(context)
        .pushNamed(MapScreen.route) as EventLocation?;

    setState(() {
      if (selectedLocation != null) {
        _previewUrl = LocationHelper.generateLocationPreviewImage(
            latitude: selectedLocation.latitude,
            longitude: selectedLocation.longitude);
        setState(() {});
        widget.editEvent(
          location: selectedLocation,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          child: _mapBuilder(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.withOpacity(0.1),
                Colors.blue.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text(
                'Obecna lokalizacja',
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _getLocationFromMap,
              icon: const Icon(Icons.map),
              label: const Text(
                "Wskaż adres",
                textScaleFactor: 0.9,
              ),
            ),
          ],
        ),
        Container(
          height: 7,
        )
      ],
    );
  }
}
