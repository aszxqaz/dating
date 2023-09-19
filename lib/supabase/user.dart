import 'package:equatable/equatable.dart';

final class AppUser extends Equatable {
  const AppUser({
    required this.id,
  });

  final String id;

  static const empty = AppUser(id: '');

  bool get isEmpty => this == AppUser.empty;

  bool get isNotEmpty => this != AppUser.empty;

  @override
  List<Object?> get props => [id];
}
