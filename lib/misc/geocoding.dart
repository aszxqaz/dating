//  https://geocode.maps.co/
//  https://geocode.maps.co/
//  https://geocode.maps.co/
//  https://geocode.maps.co/
//  https://geocode.maps.co/
//  https://geocode.maps.co/

import 'dart:convert';
import 'dart:io';

import 'package:dating/misc/location_service.dart';
import 'package:flutter/material.dart';

class GeocodeLocation {
  const GeocodeLocation({required this.country, required this.city});

  final String country;
  final String city;

  @override
  String toString() {
    return 'GeocodeLocation { country: $country, city: $city }';
  }
}

const _host = 'geocode.maps.co';

var httpClient = HttpClient();

Future<GeocodeLocation?> fetchLocation(CurrentCoords curCoords) async {
  try {
    final query = {
      'lat': curCoords.latitude.toString(),
      'lon': curCoords.longitude.toString(),
    };

    final url = Uri.https(_host, '/reverse', query);

    final request = await httpClient.getUrl(url);

    final response = await request.close();

    final data = await response.transform(utf8.decoder).join();

    final json = jsonDecode(data);
    final address = json['address'];
    if (address == null) return null;

    final country = address['country'];
    if (country == null) return null;

    final city = address['city'] ?? address['county'];
    if (city == null) return null;

    final location = GeocodeLocation(
      country: country,
      city: city,
    );

    debugPrint(location.toString());
    return location;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
