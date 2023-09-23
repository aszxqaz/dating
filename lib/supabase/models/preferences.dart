import 'package:dating/preferences/preferences.dart';

class Preferences {
  const Preferences({
    required this.children,
    required this.lookingFor,
    required this.alcohol,
    required this.education,
    required this.lovelang,
    required this.nutrition,
    required this.pets,
    required this.smoking,
    required this.workout,
  });

  static const empty = Preferences(
    children: null,
    lookingFor: null,
    alcohol: null,
    education: null,
    lovelang: null,
    nutrition: null,
    pets: null,
    smoking: null,
    workout: null,
  );

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        alcohol: json['alcohol'] != null
            ? PrefsAlcohol.values[json['alcohol']]
            : null,
        children: json['children'] != null
            ? PrefsChildren.values[json['children']]
            : null,
        lookingFor: json['looking_for'] != null
            ? PrefsLookingFor.values[json['looking_for']]
            : null,
        education: json['education'] != null
            ? PrefsEducation.values[json['education']]
            : null,
        workout: json['workout'] != null
            ? PrefsWorkout.values[json['workout']]
            : null,
        pets: json['pets'] != null ? PrefsPets.values[json['pets']] : null,
        lovelang: json['love_lang'] != null
            ? PrefsLoveLanguage.values[json['love_lang']]
            : null,
        smoking: json['smoking'] != null
            ? PrefsSmoking.values[json['smoking']]
            : null,
        nutrition: json['nutrition'] != null
            ? PrefsNutrition.values[json['nutrition']]
            : null,
      );

  final PrefsChildren? children;
  final PrefsLookingFor? lookingFor;
  final PrefsAlcohol? alcohol;
  final PrefsEducation? education;
  final PrefsLoveLanguage? lovelang;
  final PrefsNutrition? nutrition;
  final PrefsPets? pets;
  final PrefsSmoking? smoking;
  final PrefsWorkout? workout;

  copyWith({
    PrefsAlcohol? alcohol,
    PrefsChildren? children,
    PrefsEducation? education,
    PrefsLookingFor? lookingFor,
    PrefsLoveLanguage? lovelang,
    PrefsNutrition? nutrition,
    PrefsPets? pets,
    PrefsSmoking? smoking,
    PrefsWorkout? workout,
  }) =>
      Preferences(
        children: children ?? this.children,
        lookingFor: lookingFor ?? this.lookingFor,
        alcohol: alcohol ?? this.alcohol,
        education: education ?? this.education,
        lovelang: lovelang ?? this.lovelang,
        nutrition: nutrition ?? this.nutrition,
        pets: pets ?? this.pets,
        smoking: smoking ?? this.smoking,
        workout: workout ?? this.workout,
      );

  Map<String, dynamic> toJson() => {
        'alcohol': alcohol?.index,
        'children': children?.index,
        'education': education?.index,
        'looking_for': lookingFor?.index,
        'love_lang': lovelang?.index,
        'nutrition': nutrition?.index,
        'pets': pets?.index,
        'smoking': smoking?.index,
        'workout': workout?.index,
      };
}
