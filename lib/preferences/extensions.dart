part of 'preferences.dart';

extension PrefsLookingForDescribe on PrefsLookingFor {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsLookingFor.longterm:
        return AppLocalizations.of(context)!.longterm;
      case PrefsLookingFor.longOrShort:
        return AppLocalizations.of(context)!.longOrShort;
      case PrefsLookingFor.justFun:
        return AppLocalizations.of(context)!.justFun;
      case PrefsLookingFor.friends:
        return AppLocalizations.of(context)!.friends;
      case PrefsLookingFor.dontKnow:
        return AppLocalizations.of(context)!.dontKnow;
      case PrefsLookingFor.empty:
        return '';
    }
  }
}

extension PrefsAlcoholDescribe on PrefsAlcohol {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsAlcohol.never:
        return AppLocalizations.of(context)!.never;
      case PrefsAlcohol.rarely:
        return AppLocalizations.of(context)!.rarely;
      case PrefsAlcohol.occassionally:
        return AppLocalizations.of(context)!.occassionally;
      case PrefsAlcohol.regularly:
        return AppLocalizations.of(context)!.regularly;
      case PrefsAlcohol.empty:
        return '';
    }
  }
}

extension PrefsNutritionDescribe on PrefsNutrition {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsNutrition.vegan:
        return AppLocalizations.of(context)!.vegan;
      case PrefsNutrition.vegetarian:
        return AppLocalizations.of(context)!.vegetarian;
      case PrefsNutrition.pescatarian:
        return AppLocalizations.of(context)!.pescatarian;
      case PrefsNutrition.kosher:
        return AppLocalizations.of(context)!.kosher;
      case PrefsNutrition.halal:
        return AppLocalizations.of(context)!.halal;
      case PrefsNutrition.meat:
        return AppLocalizations.of(context)!.meat;
      case PrefsNutrition.everything:
        return AppLocalizations.of(context)!.everything;
      case PrefsNutrition.empty:
        return '';
    }
  }
}

extension PrefsLoveLanguageDescribe on PrefsLoveLanguage {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsLoveLanguage.attention:
        return AppLocalizations.of(context)!.attention;
      case PrefsLoveLanguage.gifts:
        return AppLocalizations.of(context)!.gifts;
      case PrefsLoveLanguage.touchings:
        return AppLocalizations.of(context)!.touchings;
      case PrefsLoveLanguage.compliments:
        return AppLocalizations.of(context)!.compliments;
      case PrefsLoveLanguage.hangAround:
        return AppLocalizations.of(context)!.hangAround;
      case PrefsLoveLanguage.empty:
        return '';
    }
  }
}

extension PrefsPetsDescribe on PrefsPets {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsPets.dog:
        return AppLocalizations.of(context)!.petsDog;
      case PrefsPets.cat:
        return AppLocalizations.of(context)!.petsCat;
      case PrefsPets.reptile:
        return AppLocalizations.of(context)!.petsReptile;
      case PrefsPets.bird:
        return AppLocalizations.of(context)!.petsBird;
      case PrefsPets.fish:
        return AppLocalizations.of(context)!.fish;
      case PrefsPets.planning:
        return AppLocalizations.of(context)!.planning;
      case PrefsPets.rabbit:
        return AppLocalizations.of(context)!.petsRabbit;
      case PrefsPets.hamster:
        return AppLocalizations.of(context)!.hamster;
      case PrefsPets.never:
        return AppLocalizations.of(context)!.never;
      case PrefsPets.allergy:
        return AppLocalizations.of(context)!.allergy;
      case PrefsPets.various:
        return AppLocalizations.of(context)!.various;
      case PrefsPets.empty:
        return '';
    }
  }
}

extension PrefsSmokingDescribe on PrefsSmoking {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsSmoking.drinking:
        return AppLocalizations.of(context)!.smokerDrinking;
      case PrefsSmoking.none:
        return AppLocalizations.of(context)!.smokerNone;
      case PrefsSmoking.quitting:
        return AppLocalizations.of(context)!.smokerQuitting;
      case PrefsSmoking.smoker:
        return AppLocalizations.of(context)!.smokerSmoker;
      case PrefsSmoking.social:
        return AppLocalizations.of(context)!.smokerSocial;
      case PrefsSmoking.empty:
        return '';
    }
  }
}

extension PrefsChildrenDescribe on PrefsChildren {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsChildren.dontWant:
        return AppLocalizations.of(context)!.childrenDontWant;
      case PrefsChildren.dontWantMore:
        return AppLocalizations.of(context)!.childrenDontWantMore;
      case PrefsChildren.notSure:
        return AppLocalizations.of(context)!.childrenNotSure;
      case PrefsChildren.want:
        return AppLocalizations.of(context)!.childrenWant;
      case PrefsChildren.wantMore:
        return AppLocalizations.of(context)!.childrenWantMore;
      case PrefsChildren.empty:
        return '';
    }
  }
}

extension PrefsWorkoutDescribe on PrefsWorkout {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsWorkout.everyday:
        return AppLocalizations.of(context)!.workoutEveryday;
      case PrefsWorkout.never:
        return AppLocalizations.of(context)!.workoutNever;
      case PrefsWorkout.often:
        return AppLocalizations.of(context)!.workoutOften;
      case PrefsWorkout.sometimes:
        return AppLocalizations.of(context)!.workoutSometimes;
      case PrefsWorkout.empty:
        return '';
    }
  }
}

extension PrefsEducationDescribe on PrefsEducation {
  String get type => toString().split('.').first;
  String get stringVal => toString().split('.').elementAt(1);

  String display(BuildContext context) {
    switch (this) {
      case PrefsEducation.bachelors:
        return AppLocalizations.of(context)!.educationBachelors;
      case PrefsEducation.inCollege:
        return AppLocalizations.of(context)!.educationInCollege;
      case PrefsEducation.masters:
        return AppLocalizations.of(context)!.educationMasters;
      case PrefsEducation.phd:
        return AppLocalizations.of(context)!.educationPhD;
      case PrefsEducation.empty:
        return '';
    }
  }
}
