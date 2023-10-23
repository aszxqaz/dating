import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:phone_number/phone_number.dart';

final phoneNumberUtil = PhoneNumberUtil();

FutureOr<String?> validatePhoneNumber(String number) async {
  if (defaultTargetPlatform != TargetPlatform.windows) {
    final validated = await phoneNumberUtil.validate(number);

    if (!validated) {
      return 'Invalid phone number';
    }
  } else {
    if (number.length < 8) {
      return 'Invalid phone number';
    }
  }

  return null;
}

String? validatePassword(String password) {
  if (password.isEmpty) {
    return 'Field is empty';
  }

  if (password.length < 6) {
    return 'Minimum 6 characters';
  }

  return null;
}

String? validateBirthdate(DateTime? birthdate) {
  if (birthdate == null) {
    return 'Invalid date';
  }

  if (DateTime.now().difference(birthdate).inDays < 365) {
    return 'Too young to join us';
  }

  return null;
}

String? validateUsername(String? name) {
  if (name == null || name.trim().isEmpty) {
    return 'Field is empty';
  }

  return null;
}
