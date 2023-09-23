import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PrefenrecesLookingFor { longterm, longOrShort, justFun, friends, dontKnow }

extension Describe on PrefenrecesLookingFor {
  String display(BuildContext context) {
    switch (this) {
      case PrefenrecesLookingFor.longterm:
        return AppLocalizations.of(context)!.longterm;
      case PrefenrecesLookingFor.longOrShort:
        return AppLocalizations.of(context)!.longOrShort;
      case PrefenrecesLookingFor.justFun:
        return AppLocalizations.of(context)!.justFun;
      case PrefenrecesLookingFor.friends:
        return AppLocalizations.of(context)!.friends;
      case PrefenrecesLookingFor.dontKnow:
        return AppLocalizations.of(context)!.dontKnow;
    }
  }
}
