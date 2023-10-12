part of 'phone_field.dart';

class PhoneFieldController {
  PhoneFieldController({String? countryCode}) {
    var dialCode = '+1';

    if (countryCode != null) {
      final country = countriesList.firstWhereOrNull(
        (country) => country.code == countryCode,
      );

      if (country != null) {
        dialCode = country.dialCode;
      }
    }

    _notifier = ValueNotifier(dialCode);
  }

  late final ValueNotifier<String> _notifier;

  dispose() {
    _notifier.dispose();
  }
}
