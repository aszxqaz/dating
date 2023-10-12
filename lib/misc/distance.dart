import 'dart:math';

import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DistanceUnit { meter, kilometer }

class Distance {
  const Distance({required this.unit, required this.amount});

  final DistanceUnit unit;
  final int amount;

  displayText(BuildContext context) {
    return switch (unit) {
      DistanceUnit.kilometer =>
        '$amount ${AppLocalizations.of(context)!.distanceKilometer}',
      DistanceUnit.meter =>
        '$amount ${AppLocalizations.of(context)!.distanceMeter}'
    };
  }
}

Distance? getDistance(UserLocation l1, UserLocation l2) {
  if (l1.latitude == null ||
      l1.longitude == null ||
      l2.latitude == null ||
      l2.longitude == null) return null;

  debugPrint('L1: (${l1.latitude}, ${l1.longitude})');
  debugPrint('L2: (${l2.latitude}, ${l2.longitude})');

  final km = _getDistanceImpl(
    l1.latitude!,
    l1.longitude!,
    l2.latitude!,
    l2.longitude!,
  );

  debugPrint(km.toString());

  if (km > 1) return Distance(unit: DistanceUnit.kilometer, amount: km.round());

  return Distance(unit: DistanceUnit.meter, amount: (km * 1000).round());
}

String? getLocationDistanceText(
  UserLocation user,
  UserLocation profile,
  BuildContext context,
) {
  String text = '';

  if (profile.city != null) {
    text += '${profile.city}';

    if (profile.country != null && user.country != profile.country) {
      text += ', ${profile.country}';
    }

    final distance = getDistance(user, profile);
    if (distance != null) {
      text += ', ${distance.displayText(context)}';
    }
    return text;
  }
  return null;
}

_getDistanceImpl(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const rad = pi / 180;

  final dLat = (lat2 - lat1) * rad;
  final dLon = (lon2 - lon1) * rad;

  final halfdLon = dLon / 2;
  final halfdLat = dLat / 2;

  final a = sin(halfdLat) * sin(halfdLat) +
      cos(lat1 * rad) * cos(lat2 * rad) * sin(halfdLon) * sin(halfdLon);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return c * 6371;
}
