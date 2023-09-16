import 'package:formz/formz.dart';

enum PhoneValidationError { empty, invalid }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure() : super.pure('');

  const Phone.dirty(String value) : super.dirty(value);

  static final validationRegex = RegExp(r'^\+\d{6,}$');

  @override
  PhoneValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneValidationError.empty;
    }
    if (!validationRegex.hasMatch(value)) {
      return PhoneValidationError.invalid;
    }
    return null;
  }
}

extension PhoneValidationErrorExplanation on PhoneValidationError {
  String? get description {
    switch (this) {
      case PhoneValidationError.empty:
        return 'Field is empty.';
      case PhoneValidationError.invalid:
        return 'Invalid phone format. Should be like +1234567890.';
    }
  }
}
