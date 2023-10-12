extension MessageDateTime on DateTime {
  String get shortStringDateTime {
    final now = DateTime.now();

    if (now.day == day && now.month == month && now.year == year) {
      return shortStringTime;
    }

    if (difference(now).inDays < 7 && weekday < now.weekday) {
      return shortStringWeekdayAndTime;
    }

    if (now.year == year) {
      return shortStringMonthAndDay;
    }

    return '$day/$month/$year';
  }
}

extension ToLocalTime on DateTime {
  String get shortStringTime {
    final local = toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get shortStringMonthAndDay => '${_months[month - 1]} $day';

  String get shortStringWeekdayAndTime =>
      '${_weekdays[weekday - 1]}, $shortStringTime';
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
