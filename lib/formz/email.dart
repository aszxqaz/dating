import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure(String value) : super.pure(value);
  const Email.dirty(String value) : super.pure(value);

  static final validationRegex =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

  static const initial = Email.pure('');

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    if (!validationRegex.hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}

extension EmailValidationErrorExplanation on EmailValidationError {
  String? get description {
    switch (this) {
      case EmailValidationError.empty:
        return 'Field is empty';
      case EmailValidationError.invalid:
        return 'Invalid email format';
    }
  }
}
