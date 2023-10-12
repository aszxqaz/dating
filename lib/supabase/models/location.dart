part of 'models.dart';

class UserLocation {
  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.city,
  });

  static const empty = UserLocation(
    latitude: null,
    longitude: null,
    country: null,
    city: null,
  );

  final double? latitude;
  final double? longitude;
  final String? country;
  final String? city;

  bool get isEmpty =>
      latitude == null || longitude == null || country == null || city == null;

  bool get isNotEmpty => !isEmpty;

  String get displayPair => '$city, $country';

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
        latitude: json['latitude'],
        longitude: json['longitude'],
        country: json['country'],
        city: json['city'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'country': country,
        'city': city,
      };

  UserLocation copyWith(
          {double? latitude,
          double? longitude,
          String? country,
          String? city}) =>
      UserLocation(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        country: country ?? this.country,
        city: city ?? this.city,
      );
}
