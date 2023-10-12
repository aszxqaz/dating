import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class NameAgeInfo extends StatelessWidget {
  const NameAgeInfo({
    super.key,
    required this.name,
    required this.birthdate,
  });

  final String name;
  final DateTime birthdate;

  @override
  Widget build(BuildContext context) {
    final age = DateTime.now().difference(birthdate).inDays ~/ 365;
    return Text(
      '$name, $age',
      style: context.textTheme.titleLarge!.copyWith(
        fontSize: 28,
      ),
    );
  }
}

class LocationInfo extends StatelessWidget {
  const LocationInfo({super.key, required this.location});

  final UserLocation location;

  @override
  Widget build(BuildContext context) {
    return location.isNotEmpty
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Ionicons.location_outline, size: 22),
              Text(location.displayPair),
            ],
          )
        : const SizedBox.shrink();
  }
}
