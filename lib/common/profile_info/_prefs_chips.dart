part of 'profile_info.dart';

class _PrefChip extends StatelessWidget {
  const _PrefChip({required this.icon, required this.text});

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: const ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(
              // color: Color.fromRGBO(0, 104, 116, 1),
              ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _ProfilePreferenceChips extends StatelessWidget {
  const _ProfilePreferenceChips({required this.prefs});

  final Preferences prefs;

  @override
  Widget build(BuildContext context) {
    // final prefsList = [
    //   prefs.lookingFor,
    //   prefs.children,
    //   prefs.lovelang,
    //   prefs.education,
    //   prefs.smoking,
    //   prefs.alcohol,
    //   prefs.nutrition,
    //   prefs.pets,
    //   prefs.workout,
    // ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      // children: prefsList.whereNotNull().map((pref) {
      //   // ignore: no_leading_underscores_for_local_identifiers

      //   return _PrefChip(
      //     icon: _pref.icon(16),
      //     text: _pref.display(context),
      //   );
      // }).toList(),

      children: [
        if (prefs.lookingFor != PrefsLookingFor.empty)
          _PrefChip(
            icon: prefs.lookingFor.icon(16),
            text: prefs.lookingFor.display(context),
          ),
        if (prefs.children != PrefsChildren.empty)
          _PrefChip(
            icon: prefs.children.icon(16),
            text: prefs.children.display(context),
          ),
        if (prefs.lovelang != PrefsLoveLanguage.empty)
          _PrefChip(
            icon: prefs.lovelang.icon(16),
            text: prefs.lovelang.display(context),
          ),
        if (prefs.education != PrefsEducation.empty)
          _PrefChip(
            icon: prefs.education.icon(16),
            text: prefs.education.display(context),
          ),
        if (prefs.smoking != PrefsSmoking.empty)
          _PrefChip(
            icon: prefs.smoking.icon(16),
            text: prefs.smoking.display(context),
          ),
        if (prefs.alcohol != PrefsAlcohol.empty)
          _PrefChip(
            icon: prefs.alcohol.icon(16),
            text: prefs.alcohol.display(context),
          ),
        if (prefs.nutrition != PrefsNutrition.empty)
          _PrefChip(
            icon: prefs.nutrition.icon(16),
            text: prefs.nutrition.display(context),
          ),
        if (prefs.pets != PrefsPets.empty)
          _PrefChip(
            icon: prefs.pets.icon(16),
            text: prefs.pets.display(context),
          ),
        if (prefs.workout != PrefsWorkout.empty)
          _PrefChip(
            icon: prefs.workout.icon(16),
            text: prefs.workout.display(context),
          ),
      ],
    );
  }
}
