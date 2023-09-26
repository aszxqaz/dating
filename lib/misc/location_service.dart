import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class CurrentCoords {
  const CurrentCoords({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

Future<CurrentCoords?> getLocationCoords() async {
  if (defaultTargetPlatform == TargetPlatform.windows) return null;

  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData data;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  data = await location.getLocation();

  if (data.latitude == null || data.longitude == null) {
    return null;
  }

  return CurrentCoords(latitude: data.latitude!, longitude: data.longitude!);
}
