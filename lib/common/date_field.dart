import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateField extends StatefulWidget {
  const DateField({
    super.key,
    this.controller,
    this.style,
    this.hintStyle,
    this.decoration,
    this.autofocus,
    this.onChanged,
  });

  final TextStyle? style;
  final TextStyle? hintStyle;
  final DateFieldController? controller;
  final InputDecoration? decoration;
  final bool? autofocus;
  final Function(DateTime?)? onChanged;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late DateFieldController controller;
  bool selfControlled = false;

  @override
  void initState() {
    if (widget.controller == null) {
      selfControlled = true;
    }
    controller = widget.controller ?? DateFieldController();

    super.initState();
  }

  @override
  void dispose() {
    if (selfControlled) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _TextField(
            controller: controller._day,
            focusNode: controller._dayFocus,
            autofocus: widget.autofocus ?? false,
            onChanged: (value) {
              if (value.length == 2) {
                if (controller._month.text.isEmpty) {
                  controller._monthFocus.requestFocus();
                }

                if (controller._year.text.isEmpty) {
                  controller._monthFocus.requestFocus();
                }
              }
              widget.onChanged?.call(controller.date);
            },
            length: 2,
            min: 1,
            max: 31,
            style: widget.style,
            hint: 'DD',
            decoration: widget.decoration,
            hintStyle: widget.hintStyle,
          ),
        ),
        const SizedBox(width: 3),
        Text('/', style: widget.style),
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
              widget.onChanged?.call(controller.date);
            },
            length: 2,
            min: 1,
            max: 12,
            style: widget.style,
            hint: 'MM',
            decoration: widget.decoration,
            hintStyle: widget.hintStyle,
          ),
        ),
        const SizedBox(width: 3),
        Text('/', style: widget.style),
        const SizedBox(width: 3),
        Expanded(
          flex: 2,
          child: _TextField(
            controller: controller._year,
            focusNode: controller._yearFocus,
            autofocus: false,
            onChanged: (value) {
              widget.onChanged?.call(controller.date);
            },
            length: 4,
            min: 1901,
            max: DateTime.now().year,
            style: widget.style,
            hint: 'YYYY',
            decoration: widget.decoration,
            hintStyle: widget.hintStyle,
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

  DateTime? get date {
    return _getDate();
  }

  dispose() {
    _day.dispose();
    _month.dispose();
    _year.dispose();
    _dayFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
  }

  String get _dateString => '${_year.text}-${_month.text}-${_day.text}';

  DateTime? _getDate() => DateTime.tryParse(_dateString);
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
    if (newValue.text == '' || (newValue.text == '0' && length <= 2)) {
      return newValue;
    }

    if (newValue.text[0] == '0' && length > 2) {
      return oldValue;
    }

    final value = int.tryParse(newValue.text);

    if (value == null) return oldValue;

    final input =
        newValue.text[0] == '0' ? newValue.text.substring(1) : newValue.text;

    for (int i = min; i <= max; i++) {
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
      inputFormatters: [
        _Formatter(length: length, min: min, max: max),
        LengthLimitingTextInputFormatter(length),
      ],
    );
  }
}
