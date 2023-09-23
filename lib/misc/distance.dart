import 'dart:math';

import 'package:dating/supabase/models/location.dart';
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
  if (l1.isEmpty || l2.isEmpty) return null;

  final km = acos(sin(l1.latitude!) * sin(l2.latitude!) +
          cos(l1.latitude!) *
              cos(l2.latitude!) *
              cos(l2.longitude! - l1.longitude!)) *
      6371;

  if (km > 1) return Distance(unit: DistanceUnit.kilometer, amount: km.round());

  return Distance(unit: DistanceUnit.meter, amount: (km * 1000).round());
}
