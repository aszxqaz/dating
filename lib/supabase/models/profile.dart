part of 'models.dart';

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
    required this.lastSeen,
  });

  final String userId;
  final String name;
  final DateTime birthdate;
  final bool male;
  final int orientation;
  final List<Photo> photos;
  final UserLocation location;
  final Preferences prefs;
  final DateTime lastSeen;

  Iterable<String> get photoUrls => photos.map((photo) => photo.url);
  String? get avatarUrl => hasPhotos ? photos.first.url : null;
  bool get hasAvatar => avatarUrl != null;
  bool get hasPhotos => photos.isNotEmpty;
  bool get isOnline =>
      DateTime.now().difference(lastSeen) < const Duration(minutes: 1);
  int get age => DateTime.now().difference(birthdate).inDays ~/ 365;

  factory Profile.fromJson(Map<String, dynamic> json) {
    final location = json['locations'] != null
        ? UserLocation.fromJson(json['locations'])
        : UserLocation.empty;

    final photos = (json['photos'] as List)
        .cast<Map<String, dynamic>>()
        .map(
          (photo) => Photo.fromJson(photo),
        )
        .toList();

    final prefs = json['preferences'] != null
        ? Preferences.fromJson(json['preferences'])
        : Preferences.empty;

    return Profile(
      userId: json['user_id'],
      name: json['name'],
      birthdate: DateTime.parse(json['birthdate']),
      lastSeen: DateTime.parse(json['last_seen']).toLocal(),
      male: json['male'] ?? false,
      orientation: json['orientation'] ?? 0,
      photos: photos,
      location: location,
      prefs: prefs,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'birthdate': birthdate.toIso8601String(),
        'male': male,
        'orientation': orientation,
        'photos': photos.map((photo) => photo.toJson()).toList(),
        'location': location.toJson(),
        'preferences': prefs.toJson(),
        'last_seen': lastSeen.toIso8601String(),
      };

  Profile copyWith({
    String? name,
    DateTime? birthdate,
    DateTime? lastSeen,
    bool? male,
    int? orientation,
    List<Photo>? photos,
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
        lastSeen: lastSeen ?? this.lastSeen,
      );

  @override
  toString() =>
      'Profile (userId: *, name: $name, birthdate: *, male: $male, orientation: $orientation,'
      'photos: (length: ${photos.length}), location: ${location.displayPair})';

  Photo? getPhoto(String photoId) =>
      photos.firstWhereOrNull((photo) => photo.id == photoId);
}
