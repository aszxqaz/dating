import 'package:equatable/equatable.dart';

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
