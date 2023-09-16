import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty(String value) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 6) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}

extension PasswordValidationErrorExplanation on PasswordValidationError {
  String? get description {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Field is empty';

      case PasswordValidationError.tooShort:
        return 'Minimum 6 characters';
    }
  }
}
