import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.controller,
    this.style,
    this.hintStyle,
    this.decoration,
  });

  final TextStyle? style;
  final TextStyle? hintStyle;
  final DateFieldController controller;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _TextField(
            controller: controller._day,
            focusNode: controller._dayFocus,
            autofocus: false,
            onChanged: (value) {
              if (value.length == 2) {
                if (controller._month.text.isEmpty) {
                  controller._monthFocus.requestFocus();
                }

                if (controller._year.text.isEmpty) {
                  controller._monthFocus.requestFocus();
                }
              }
            },
            length: 2,
            min: 1,
            max: 31,
            style: style,
            hint: 'DD',
            decoration: decoration,
            hintStyle: hintStyle,
          ),
        ),
        const SizedBox(width: 3),
        Text('/', style: style),
        const SizedBox(width: 3),
        Expanded(
          flex: 1,
          child: _TextField(
            controller: controller._month,
            focusNode: controller._monthFocus,
            autofocus: false,
            onChanged: (value) {
              if (value.length == 2 && controller._year.text.isEmpty) {
                controller._yearFocus.requestFocus();
              }
            },
            length: 2,
            min: 1,
            max: 12,
            style: style,
            hint: 'MM',
            decoration: decoration,
            hintStyle: hintStyle,
          ),
        ),
        const SizedBox(width: 3),
        Text('/', style: style),
        const SizedBox(width: 3),
        Expanded(
          flex: 2,
          child: _TextField(
            controller: controller._year,
            focusNode: controller._yearFocus,
            autofocus: false,
            onChanged: (value) {},
            length: 2,
            min: 1901,
            max: DateTime.now().year,
            style: style,
            hint: 'YYYY',
            decoration: decoration,
            hintStyle: hintStyle,
          ),
        ),
      ],
    );
  }
}

class DateFieldController {
  DateFieldController()
      : _day = TextEditingController(),
        _month = TextEditingController(),
        _year = TextEditingController(),
        _dayFocus = FocusNode(),
        _monthFocus = FocusNode(),
        _yearFocus = FocusNode();

  final TextEditingController _day;
  final TextEditingController _month;
  final TextEditingController _year;

  final FocusNode _dayFocus;
  final FocusNode _monthFocus;
  final FocusNode _yearFocus;

  DateTime? get date => _getDate();

  dispose() {
    _day.dispose();
    _month.dispose();
    _year.dispose();
    _dayFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
  }

  _getDate() => DateTime.tryParse('${_year.text}-${_month.text}-${_day.text}');
}

class _Formatter extends TextInputFormatter {
  const _Formatter({
    required this.length,
    required this.min,
    required this.max,
  }) : super();

  final int length;
  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') return newValue;

    final value = int.tryParse(newValue.text);

    if (value == null) return oldValue;

    for (int i = min; i <= max; i++) {
      final input = newValue.text;
      final possible = i.toString();

      if (input.length > possible.length) {
        continue;
      }

      if (input == possible.substring(0, input.length)) {
        return newValue;
      }
    }

    return oldValue;
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.onChanged,
    required this.focusNode,
    required this.hint,
    required this.length,
    required this.min,
    required this.max,
    this.decoration,
    this.hintStyle,
    this.style,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;

  final String hint;
  final int length;
  final int min;
  final int max;

  final InputDecoration? decoration;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: (style ?? const TextStyle()).copyWith(
        letterSpacing: 2,
      ),
      decoration: (decoration ?? const InputDecoration()).copyWith(
        hintText: hint,
        hintStyle: (hintStyle ?? const TextStyle()).copyWith(
          letterSpacing: 2,
        ),
      ),
      maxLines: 1,
      inputFormatters: [_Formatter(length: length, min: min, max: max)],
    );
  }
}
