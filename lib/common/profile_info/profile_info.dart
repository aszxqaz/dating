import 'package:dating/assets/preferences.dart';
import 'package:dating/common/common.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/preferences/preferences.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';

part '_prefs_chips.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NameAgeInfo(profile),
        const SizedBox(height: 4),
        LocationInfo(location: profile.location),
        const SizedBox(height: 24),
        if (profile.prefs.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferences',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _ProfilePreferenceChips(prefs: profile.prefs),
            ],
          ),
      ],
    );
  }
}
