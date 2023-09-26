import 'package:dating/preferences/preferences.dart';

class _PrefsHSMap {
  static const children = '0';
  static const lookingFor = '1';
  static const alcohol = '2';
  static const education = '3';
  static const lovelang = '4';
  static const nutrition = '5';
  static const pets = '6';
  static const smoking = '7';
  static const workout = '8';
}

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

  factory Preferences.fromHydratedJson(Map<String, dynamic> json) =>
      Preferences(
        alcohol: json[_PrefsHSMap.alcohol] != null
            ? PrefsAlcohol.values[json[_PrefsHSMap.alcohol]]
            : null,
        children: json[_PrefsHSMap.children] != null
            ? PrefsChildren.values[json[_PrefsHSMap.children]]
            : null,
        lookingFor: json[_PrefsHSMap.lookingFor] != null
            ? PrefsLookingFor.values[json[_PrefsHSMap.lookingFor]]
            : null,
        education: json[_PrefsHSMap.education] != null
            ? PrefsEducation.values[json[_PrefsHSMap.education]]
            : null,
        workout: json[_PrefsHSMap.workout] != null
            ? PrefsWorkout.values[json[_PrefsHSMap.workout]]
            : null,
        pets: json[_PrefsHSMap.pets] != null
            ? PrefsPets.values[json[_PrefsHSMap.pets]]
            : null,
        lovelang: json[_PrefsHSMap.lovelang] != null
            ? PrefsLoveLanguage.values[json[_PrefsHSMap.lovelang]]
            : null,
        smoking: json[_PrefsHSMap.smoking] != null
            ? PrefsSmoking.values[json[_PrefsHSMap.smoking]]
            : null,
        nutrition: json[_PrefsHSMap.nutrition] != null
            ? PrefsNutrition.values[json[_PrefsHSMap.nutrition]]
            : null,
      );

  Map<String, dynamic> toHydratedJson() => {
        _PrefsHSMap.alcohol: alcohol?.index,
        _PrefsHSMap.children: children?.index,
        _PrefsHSMap.education: education?.index,
        _PrefsHSMap.lookingFor: lookingFor?.index,
        _PrefsHSMap.lovelang: lovelang?.index,
        _PrefsHSMap.nutrition: nutrition?.index,
        _PrefsHSMap.pets: pets?.index,
        _PrefsHSMap.smoking: smoking?.index,
        _PrefsHSMap.workout: workout?.index,
      };

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
