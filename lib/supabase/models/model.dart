import 'package:dating/supabase/models/location.dart';
import 'package:dating/supabase/models/preferences.dart';
import 'package:equatable/equatable.dart';

import 'photo.dart';

class PhotoTable extends Equatable {
  const PhotoTable({
    required this.id,
    required this.userId,
    required this.link,
  });

  final String id;
  final String userId;
  final String link;

  @override
  List<Object?> get props => [id, userId, link];

  factory PhotoTable.fromJson(Map<String, dynamic> json) => PhotoTable(
        id: json['id'],
        userId: json['user_id'],
        link: json['link'],
      );
}

class ProfileTable {
  const ProfileTable(
      {required this.userId,
      required this.name,
      required this.birthdate,
      required this.male,
      required this.orientation});

  final String userId;
  final String name;
  final DateTime birthdate;
  final bool male;
  final int orientation;

  factory ProfileTable.fromJson(Map<String, dynamic> json) => ProfileTable(
        userId: json['user_id'],
        name: json['name'],
        birthdate: DateTime.parse(json['birthdate']),
        male: json['male'],
        orientation: json['orientation'],
      );
}

class Profile {
  const Profile({
    required this.userId,
    required this.name,
    required this.birthdate,
    required this.male,
    required this.orientation,
    required this.photos,
    required this.location,
    required this.prefs,
  });

  final String userId;
  final String name;
  final DateTime birthdate;
  final bool male;
  final int orientation;
  final Iterable<Photo> photos;
  final UserLocation location;
  final Preferences prefs;

  Iterable<String> get photoUrls => photos.map((photo) => photo.url);

  factory Profile.fromJson(Map<String, dynamic> json) {
    final location = json['locations'] != null
        ? UserLocation.fromJson(json['locations'])
        : UserLocation.empty;

    final photos = (json['photos'] as List).cast<Map<String, dynamic>>().map(
          (photo) => Photo.fromJson(photo),
        );

    final prefs = json['prefs'] != null
        ? Preferences.fromJson(json['prefs'])
        : Preferences.empty;

    return Profile(
      userId: json['user_id'],
      name: json['name'],
      birthdate: DateTime.parse(json['birthdate']),
      male: json['male'] ?? false,
      orientation: json['orientation'] ?? 0,
      photos: photos,
      location: location,
      prefs: prefs,
    );
  }

  Profile copyWith({
    String? name,
    DateTime? birthdate,
    bool? male,
    int? orientation,
    Iterable<Photo>? photos,
    UserLocation? location,
    Preferences? prefs,
  }) =>
      Profile(
        userId: userId,
        name: name ?? this.name,
        birthdate: birthdate ?? this.birthdate,
        male: male ?? this.male,
        orientation: orientation ?? this.orientation,
        photos: photos ?? this.photos,
        location: location ?? this.location,
        prefs: prefs ?? this.prefs,
      );

  @override
  toString() =>
      'Profile (userId: *, name: $name, birthdate: *, male: $male, orientation: $orientation,'
      'photos: (length: ${photos.length}), location: ${location.displayPair})';
}
