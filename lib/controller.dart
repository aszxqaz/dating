import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dating/countries.dart';

class PhoneInputController {
  PhoneInputController(Stream<String> values) {
    _start(values);
  }

  var _oldState = PhoneInputControllerState();

  final _stateStreamController =
      StreamController<PhoneInputControllerState>.broadcast();

  Stream<PhoneInputControllerState> get state => _stateStreamController.stream;

  var _oldCodes = countriesInfo;

  _start(Stream<String> values) {
    values.listen((newValue) {
      _stateStreamController.add(getNewState(newValue));
    });
  }

  PhoneInputControllerState getNewState(String newValue) {
    if (_isAddition(newValue)) {
      if (_oldState.error != null || !_checkIntLastChar(newValue)) {
        return _oldState;
      }
    }

    if (_oldState.code != null && newValue.length < _oldState.code!.length) {
      final newCodes = getCodes(newValue);

      final newState = PhoneInputControllerState(
        code: null,
        codes: newCodes.isEmpty ? null : newCodes,
        text: newValue,
      );

      _oldState = newState;
      return newState;
    }

    if (_oldState.code == null && newValue.length > 1 && newValue.length <= 5) {
      final newCodes = getCodes(newValue);

      if (newCodes.length == 1) {
        final code = newCodes.first['dial_code']!;
        final newState = PhoneInputControllerState(
          text: code,
          code: code,
          codes: null,
        );
        _oldState = newState;
        return newState;
      }

      if (newCodes.isEmpty) {
        print('Unknown country code');
        final newState = PhoneInputControllerState(
          error: 'Unknown country code',
          text: newValue,
        );
        _oldState = newState;
        return newState;
      } else {
        final newState = PhoneInputControllerState(
          codes: newCodes,
          text: newValue,
        );
        _oldState = newState;
        return newState;
      }
    }

    final newState = PhoneInputControllerState(
      text: newValue,
      code: _oldState.code,
    );
    _oldState = newState;
    return newState;
  }

  List<Map<String, String>> getCodes(String input) {
    return countriesInfo
        .where((info) => info['dial_code']!.startsWith(input))
        .toList();
  }

  void selectCode(String code) {
    print(code);
    final newState = PhoneInputControllerState(
      text: code,
      code: code,
      codes: null,
    );
    _oldState = newState;
    _stateStreamController.add(newState);
  }

  bool _isAddition(newValue) {
    return newValue.length > _oldState.text.length;
  }

  bool _checkIntLastChar(String input) {
    return input == '+' ||
        int.tryParse(input.substring(input.length - 1)) != null;
  }

  bool _checkCodeMaxLength(String input) {
    return input.length <= 5;
  }
}

final class PhoneInputControllerState {
  PhoneInputControllerState({
    this.codes,
    this.error,
    this.code,
    this.text = '+',
  });

  final String? error;
  final List<Map<String, String>>? codes;
  final String? code;
  final String text;
}
