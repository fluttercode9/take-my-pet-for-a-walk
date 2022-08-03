import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:okolicznie/helpers/location_helper.dart';
import '../models/event.dart';
import 'dart:async';
import '../globals.dart' as api_key;

class MapScreen extends StatefulWidget {
  static const route = '/map';
  MapScreen(
      {Key? key,
      this.initialLocation = const EventLocation(
          longitude: 19.93, latitude: 50.06, address: "Kraków"),
      this.isSelecting = true})
      : super(key: key);
  final EventLocation initialLocation;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  String locationString = "Wyszukaj";
  LatLng? _pickedLocation;

  Future<void> _selectLocation(LatLng coordinates) async {
    String placeName;

    setState(
      () {
        _pickedLocation = coordinates;
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _pickedLocation!, zoom: 17),
          ),
        );
      },
    );
    // transform coordinates to adress

    placeName = await LocationHelper.generateAdressString(_pickedLocation!);
    setState(() {
      locationString = placeName;
    });
  }

  GoogleMapController? _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isSelecting
            ? const Text("Wybierz lokalizację")
            : const Text('Lokalizacja zwierzaka'),
      ),
      floatingActionButton: _pickedLocation != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop(EventLocation(
                    latitude: _pickedLocation!.latitude,
                    longitude: _pickedLocation!.longitude,
                    address: locationString));
              },
              child: Icon(Icons.add))
          : null,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.initialLocation.latitude,
                    widget.initialLocation.longitude),
                zoom: widget.isSelecting ? 10.0 : 18),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: widget.isSelecting == false
                ? {
                    Marker(
                        markerId: const MarkerId('m1'),
                        position: LatLng(widget.initialLocation.latitude,
                            widget.initialLocation.longitude)),
                  }
                : _pickedLocation == null
                    ? <Marker>{}
                    : {
                        Marker(
                            markerId: const MarkerId('m1'),
                            position: _pickedLocation!),
                      },
            myLocationEnabled: true,
          ),
          widget.isSelecting == true
              ? Positioned(
                  //search input bar
                  top: -9,
                  right: 45,
                  child: InkWell(
                      onTap: () async {
                        var place = await PlacesAutocomplete.show(
                          context: context,

                          apiKey: api_key.GOOGLE_API_KEY,
                          mode: Mode.overlay,
                          types: [],
                          strictbounds: false,
                          components: [Component(Component.country, 'pl')],
                          //google_map_webservice package
                          onError: (err) {
                            print(err);
                          },
                          language: 'pl',
                        );

                        if (place != null) {
                          setState(() {
                            locationString = place.description.toString();
                          });

                          //form google_maps_webservice package
                          final plist = GoogleMapsPlaces(
                            apiKey: api_key.GOOGLE_API_KEY,
                            apiHeaders: await GoogleApiHeaders().getHeaders(),

                            //from google_api_headers package
                          );
                          String placeid = place.placeId ?? "0";
                          final detail =
                              await plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          final lat = geometry.location.lat;
                          final lang = geometry.location.lng;
                          var newlatlang = LatLng(lat, lang);

                          //move map camera to selected place with animation
                          _controller?.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: newlatlang, zoom: 17)));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width - 80,
                            child: ListTile(
                              title: Text(
                                locationString,
                                style: const TextStyle(fontSize: 18),
                              ),
                              trailing: const Icon(Icons.search),
                              dense: true,
                            ),
                          ),
                        ),
                      )))
              : Container(),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = (controller);
    setState(() {});
  }
}
