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
