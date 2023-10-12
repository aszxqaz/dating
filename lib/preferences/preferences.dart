import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'extensions.dart';

enum PrefsAlcohol {
  empty,
  never,
  rarely,
  occassionally,
  regularly,
}

enum PrefsChildren {
  empty,
  want,
  dontWant,
  wantMore,
  dontWantMore,
  notSure,
}

enum PrefsEducation {
  empty,
  bachelors,
  inCollege,
  phd,
  masters,
}

enum PrefsLookingFor {
  empty,
  longterm,
  longOrShort,
  justFun,
  friends,
  dontKnow
}

enum PrefsLoveLanguage {
  empty,
  attention,
  gifts,
  touchings,
  compliments,
  hangAround
}

enum PrefsNutrition {
  empty,
  everything,
  vegan,
  vegetarian,
  pescatarian,
  kosher,
  halal,
  meat
}

enum PrefsPets {
  empty,
  dog,
  cat,
  reptile,
  bird,
  fish,
  rabbit,
  hamster,
  various,
  planning,
  never,
  allergy,
}

enum PrefsSmoking {
  empty,
  social,
  drinking,
  none,
  smoker,
  quitting,
}

enum PrefsWorkout {
  empty,
  everyday,
  often,
  sometimes,
  never,
}
