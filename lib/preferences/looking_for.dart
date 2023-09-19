import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PrefenrecesLookingFor { longterm, longOrShort, justFun, friends, dontKnow }

extension Describe on PrefenrecesLookingFor {
  String display(BuildContext context) {
    switch (this) {
      case PrefenrecesLookingFor.longterm:
        AppLocalizations
      case PrefenrecesLookingFor.longOrShort:
      // TODO: Handle this case.
      case PrefenrecesLookingFor.justFun:
      // TODO: Handle this case.
      case PrefenrecesLookingFor.friends:
      // TODO: Handle this case.
      case PrefenrecesLookingFor.dontKnow:
        // TODO: Handle this case.
        return '';
    }
  }
}
