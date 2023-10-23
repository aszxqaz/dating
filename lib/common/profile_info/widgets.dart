import 'package:dating/misc/extensions.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class NameAgeInfo extends StatelessWidget {
  const NameAgeInfo(this.profile, {super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final birthdate = profile.birthdate;
    final gender = profile.gender;
    final name = profile.name;

    final age = DateTime.now().difference(birthdate).inDays ~/ 365;
    return Text.rich(
      TextSpan(
        style: context.textTheme.titleLarge!.copyWith(
          fontSize: 28,
        ),
        children: [
          TextSpan(text: '$name, $age'),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                gender == Gender.male ? Ionicons.male : Ionicons.female,
              ),
            ),
          ),
        ],
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
