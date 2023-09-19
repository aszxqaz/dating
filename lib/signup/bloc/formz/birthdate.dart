import 'package:formz/formz.dart';

enum BirthdateValdiationError { empty, invalid, tooYoung }

class Birthdate extends FormzInput<String, BirthdateValdiationError> {
  const Birthdate.pure(super.value) : super.pure();

  static const initial = Birthdate.pure('');

  @override
  BirthdateValdiationError? validator(String value) {
    if (value.isEmpty) return BirthdateValdiationError.empty;

    final date = DateTime.tryParse(value);

    if (date == null) {
      return BirthdateValdiationError.invalid;
    }

    final diff = DateTime.now().difference(date).inDays;

    if (diff < 365) {
      return BirthdateValdiationError.tooYoung;
    }

    return null;
  }
}

extension BirthdateValdiationErrorExcplanation on BirthdateValdiationError {
  String? get description {
    switch (this) {
      case BirthdateValdiationError.empty:
        return 'Field is empty';

      case BirthdateValdiationError.tooYoung:
        return 'You\'re too young';

      case BirthdateValdiationError.invalid:
        return 'Invalid date format';
    }
  }
}
