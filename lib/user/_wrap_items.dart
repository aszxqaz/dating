part of 'user_view.dart';

class _LookingForChipsWrap extends StatelessWidget {
  const _LookingForChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsLookingFor? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.lookingFor,
      labels: PrefsLookingFor.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsLookingFor.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: const Icon(Ionicons.search_outline),
    );
  }
}

class _LoveLanguageChipsWrap extends StatelessWidget {
  const _LoveLanguageChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsLoveLanguage? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.loveLanguage,
      labels: PrefsLoveLanguage.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsLoveLanguage.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: const Icon(Ionicons.heart_outline),
    );
  }
}

class _AlcoholChipsWrap extends StatelessWidget {
  const _AlcoholChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsAlcohol? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.alcohol,
      labels: PrefsAlcohol.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsAlcohol.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: const Icon(Ionicons.wine_outline),
    );
  }
}

class _NutritionChipsWrap extends StatelessWidget {
  const _NutritionChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsNutrition? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.nutrition,
      labels: PrefsNutrition.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsNutrition.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: const Icon(Ionicons.restaurant_outline),
    );
  }
}

class _PetsChipsWrap extends StatelessWidget {
  const _PetsChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsPets? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.pets,
      labels: PrefsPets.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsPets.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: SvgPicture.asset(
        'assets/icons/custom/dog1.svg', // 28
        width: 26,
        height: 26,
      ),
    );
  }
}

class _SmokingChipsWrap extends StatelessWidget {
  const _SmokingChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsSmoking? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.smoking,
      labels: PrefsSmoking.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsSmoking.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: SvgPicture.asset(
        'assets/icons/custom/smoking.svg',
        width: 26,
        height: 26,
      ),
    );
  }
}

class _EducationChipsWrap extends StatelessWidget {
  const _EducationChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsEducation? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.education,
      labels: PrefsEducation.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsEducation.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: SvgPicture.asset(
        'assets/icons/custom/education.svg',
        width: 26,
        height: 26,
      ),
    );
  }
}

class _ChildrenChipsWrap extends StatelessWidget {
  const _ChildrenChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsChildren? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.children,
      labels: PrefsChildren.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsChildren.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: SvgPicture.asset(
        'assets/icons/custom/children.svg', // 28
        width: 24,
        height: 24,
      ),
    );
  }
}

class _WorkoutChipsWrap extends StatelessWidget {
  const _WorkoutChipsWrap({
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsWorkout? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return _ChipsWrap(
      title: AppLocalizations.of(context)!.workout,
      labels: PrefsWorkout.values.map((v) => v.display(context)),
      selected: (index) => groupValue == PrefsWorkout.values[index],
      onSelected: (index) {
        onSelected(index);
      },
      onDeselected: onDeselected,
      icon: SvgPicture.asset(
        'assets/icons/custom/dumbbell.svg', // 28
        width: 26,
        height: 26,
      ),
    );
  }
}
