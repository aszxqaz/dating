import 'package:dating/supabase/models/models.dart';
import 'package:dating/supabase/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

@immutable
class HotCard {
  const HotCard({
    required this.photo,
    required this.name,
    required this.age,
    required this.from,
    required this.distance,
    required this.lastSeen,
  });

  final Photo? photo;
  final String name;
  final int age;
  final String from;
  final String distance;
  final String lastSeen;

  factory HotCard.fromProfile(Profile profile) {
    return HotCard(
      photo: profile.photos.elementAtOrNull(0),
      name: profile.name,
      age: DateTime.now().difference(profile.birthdate).inDays ~/ 365,
      from: 'Moscow',
      distance: '10 km',
      lastSeen: timeago.format(
        DateTime.now().subtract(
          const Duration(minutes: 15),
        ),
      ),
    );
  }
}
