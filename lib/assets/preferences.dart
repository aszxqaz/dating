import 'package:dating/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

extension PrefsLookingForIcon on PrefsLookingFor {
  Widget icon([double? size]) {
    return Icon(Ionicons.search_outline, size: size);
  }
}

extension PrefsLoveLanguageIcon on PrefsLoveLanguage {
  Widget icon([double? size]) {
    return Icon(Ionicons.heart_outline, size: size);
  }
}

extension PrefsAlcoholIcon on PrefsAlcohol {
  Widget icon([double? size]) {
    return Icon(Ionicons.wine_outline, size: size);
  }
}

extension PrefsNutritionIcon on PrefsNutrition {
  Widget icon([double? size]) {
    return Icon(Ionicons.restaurant_outline, size: size);
  }
}

extension PrefsPetsIcon on PrefsPets {
  Widget icon([double? size]) {
    return SvgPicture.asset(
      'assets/icons/custom/dog1.svg',
      width: size ?? 26,
      height: size ?? 26,
    );
  }
}

extension PrefsSmokingIcon on PrefsSmoking {
  Widget icon([double? size]) {
    return SvgPicture.asset(
      'assets/icons/custom/smoking.svg',
      width: size ?? 26,
      height: size ?? 26,
    );
  }
}

extension PrefsEducationIcon on PrefsEducation {
  Widget icon([double? size]) {
    return SvgPicture.asset(
      'assets/icons/custom/education.svg',
      width: size ?? 26,
      height: size ?? 26,
    );
  }
}

extension PrefsChildrenIcon on PrefsChildren {
  Widget icon([double? size]) {
    return SvgPicture.asset(
      'assets/icons/custom/children.svg',
      width: size ?? 24,
      height: size ?? 24,
    );
  }
}

extension PrefsWorkoutIcon on PrefsWorkout {
  Widget icon([double? size]) {
    return SvgPicture.asset(
      'assets/icons/custom/dumbbell.svg',
      width: size ?? 26,
      height: size ?? 26,
    );
  }
}
