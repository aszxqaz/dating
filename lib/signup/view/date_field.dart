import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class DateField extends StatefulWidget {
  const DateField({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<DateTime?> onChanged;

  @override
  State<DateField> createState() => DateFieldState();
}

class DateFieldState extends State<DateField> {
  final dayController = TextEditingController(text: '20');
  final yearController = TextEditingController(text: '1992');
  final _yearInputFormatter = _YearInputFormatter();
  int month = 1;

  @override
  void initState() {
    super.initState();
    dateChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: TextField(
            controller: dayController,
            onChanged: (_) {
              dateChanged();
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [_DayInputFormatter()],
            decoration: const InputDecoration(
              hintText: 'Day',
            ),
          ),
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: month,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                month = value;
              });
              dateChanged();
            }
          },
          items: months.mapIndexed(
            (idx, monthName) {
              return DropdownMenuItem(value: idx + 1, child: Text(monthName));
            },
          ).toList(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            onChanged: (_) {
              dateChanged();
            },
            textAlign: TextAlign.center,
            controller: yearController,
            inputFormatters: [_yearInputFormatter],
            decoration: const InputDecoration(
              hintText: 'Year',
            ),
          ),
        ),
      ],
    );
  }

  void dateChanged() {
    final day = int.tryParse(dayController.text);
    final year = int.tryParse(yearController.text);
    if (day != null && year != null && year > _yearInputFormatter.start) {
      final date = DateTime(year, month, day);
      widget.onChanged(date);
    } else {
      widget.onChanged(null);
    }
  }
}

class _DayInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final day = int.tryParse(newValue.text);
    if (day != null && day >= 1 && day <= 31) {
      return newValue;
    }

    return oldValue;
  }
}

class _YearInputFormatter extends TextInputFormatter {
  final int now = DateTime.now().year;
  late int start = now - 115;
  late int end = now - 18;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final input = int.tryParse(newValue.text);

    if (input == null) return oldValue;

    for (int i = start; i <= end; i++) {
      final part = i ~/ pow(10, 4 - newValue.text.length);
      if (input == part) return newValue;
    }

    return oldValue;
  }
}
