import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../globals.dart' as api_key;


class LocationHelper {
  static String generateLocationPreviewImage(
      {required double longitude, required double latitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=17&size=600x450&maptype=terrain&markers=color:red%7label:C%7C$latitude,$longitude&key=${api_key.GOOGLE_API_KEY}';
  }

  static Future<String> generateAdressString(LatLng cords) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(cords.latitude, cords.longitude);
    return "${placemarks.first.locality}, ${placemarks.first.street}";
  }
}
