import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension BuildContextThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  ButtonStyle get textButtonStyle => theme.textButtonTheme.style!;
}

extension IfDebug on Object {
  get ifDebug => kDebugMode ? this : null;
}

extension LightenDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

const encoder = JsonEncoder.withIndent("     ");

extension PrettyJsonString on Object {
  String toPrettyJson() {
    return encoder.convert(this);
  }
}

extension ListExt<T> on List<T> {
  List<T> updated(int index, T item, [bool panic = false]) {
    if (index < 0 || index >= length && !panic) {
      debugPrint('ERROR: List.updated() error: not found at index $index.');
      return this;
    }

    return slice(0, index) + [item] + slice(index + 1);
  }

  List<T> replaceWhere(
    T item,
    bool Function(T item) predicate, [
    bool panic = false,
  ]) {
    final index = indexWhere(predicate);
    if (index == -1 && !panic) {
      debugPrint('ERROR: List.updatedWhere() error: not found.');
      return this;
    }

    return updated(index, item, panic);
  }

  List<T> updateWhere(
    T Function(T item) updateFn,
    bool Function(T item) predicate, [
    bool panic = false,
  ]) {
    final index = indexWhere(predicate);
    if (index == -1 && !panic) {
      debugPrint('ERROR: List.updatedWhere() error: not found.');
      return this;
    }

    return updated(index, updateFn(this[index]), panic);
  }

  List<T> upsertWhere(
    T item,
    bool Function(T item) predicate, [
    bool atStart = false,
  ]) {
    final index = indexWhere(predicate);

    if (index != -1) {
      return updated(index, item);
    } else {
      return atStart ? [item, ...this] : [...this, item];
    }
  }
}
