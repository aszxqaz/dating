import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { empty, mismatch }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure({
    this.other = '',
  }) : super.pure('');

  const ConfirmedPassword.dirty({
    required String value,
    required this.other,
  }) : super.dirty(value);

  final String other;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmedPasswordValidationError.empty;
    }
    if (value != other) {
      return ConfirmedPasswordValidationError.mismatch;
    }
    return null;
  }

  ConfirmedPassword copyWith({String? value, String? other}) {
    if (isPure) {
      if (value != null) {
        return ConfirmedPassword.dirty(
          other: other ?? this.other,
          value: value,
        );
      } else if (other != null) {
        return ConfirmedPassword.pure(other: other);
      }
    } else {
      return ConfirmedPassword.dirty(
        other: other ?? this.other,
        value: value ?? this.value,
      );
    }

    return this;
  }
}

extension ConfirmedPasswordValidationErrorExplanation
    on ConfirmedPasswordValidationError {
  String? get description {
    switch (this) {
      case ConfirmedPasswordValidationError.empty:
        return 'Field is empty';

      case ConfirmedPasswordValidationError.mismatch:
        return 'Passwords do not match';
    }
  }
}
