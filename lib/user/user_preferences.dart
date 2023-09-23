part of 'user_view.dart';

class _LookingForChipsWrap extends StatelessWidget {
  const _LookingForChipsWrap({
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsLookingFor? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.lookingFor,
      labels: PrefsLookingFor.values.map((v) => v.display(context)),
      values: PrefsLookingFor.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsLoveLanguage? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.loveLanguage,
      labels: PrefsLoveLanguage.values.map((v) => v.display(context)),
      values: PrefsLoveLanguage.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsAlcohol? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.alcohol,
      labels: PrefsAlcohol.values.map((v) => v.display(context)),
      values: PrefsAlcohol.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsNutrition? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.nutrition,
      labels: PrefsNutrition.values.map((v) => v.display(context)),
      values: PrefsNutrition.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsPets? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.pets,
      labels: PrefsPets.values.map((v) => v.display(context)),
      values: PrefsPets.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsSmoking? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.smoking,
      labels: PrefsSmoking.values.map((v) => v.display(context)),
      values: PrefsSmoking.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsEducation? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.education,
      labels: PrefsEducation.values.map((v) => v.display(context)),
      values: PrefsEducation.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsChildren? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.children,
      labels: PrefsChildren.values.map((v) => v.display(context)),
      values: PrefsChildren.values.map((v) => v.stringVal),
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
    super.key,
    required this.groupValue,
    required this.onSelected,
    required this.onDeselected,
  });

  final PrefsWorkout? groupValue;
  final void Function(int index) onSelected;
  final VoidCallback onDeselected;

  @override
  Widget build(BuildContext context) {
    return ChipsWrap(
      title: AppLocalizations.of(context)!.workout,
      labels: PrefsWorkout.values.map((v) => v.display(context)),
      values: PrefsWorkout.values.map((v) => v.stringVal),
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

class ChipsWrap extends StatelessWidget {
  const ChipsWrap({
    super.key,
    required this.title,
    required this.labels,
    required this.icon,
    required this.onSelected,
    required this.onDeselected,
    required this.selected,
    required this.values,
  });

  final String title;
  final Widget icon;

  final Iterable<String> labels;
  final Iterable<String> values;

  final Function(int index) onSelected;
  final VoidCallback onDeselected;
  final bool Function(int index) selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: labels
                    .mapIndexed(
                      (index, label) => AppChip(
                        label: label,
                        selected: selected(index),
                        onSelected: (boolsel) {
                          if (boolsel) {
                            onSelected(index);
                          } else {
                            onDeselected();
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      return context.colorScheme.primary;
    }

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.transparent,
      color: MaterialStateProperty.resolveWith(getColor),
      labelStyle: TextStyle(
        color: selected ? Colors.white : context.colorScheme.primary,
      ),
      selectedColor: context.colorScheme.primary,
      side: BorderSide(color: context.colorScheme.primary),
    );

    // return Container(
    //   clipBehavior: Clip.antiAlias,
    //   decoration: BoxDecoration(
    //     color: active ? color : Colors.transparent,
    //     borderRadius: BorderRadius.circular(24),
    //     border: Border.all(
    //       width: 1,
    //       color: color,
    //     ),
    //   ),
    //   child: Padding(
    //     padding: const EdgeInsets.fromLTRB(12, 4, 12, 5),
    //     child: Text(
    //       text,
    //       style: context.textTheme.bodyMedium!.copyWith(
    //         color: active ? Colors.white : color,
    //       ),
    //     ),
    //   ),
    // );
  }
}
