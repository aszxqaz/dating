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
    _controller = TextEditingController();
  }

  late final ValueNotifier<String> _notifier;
  late final TextEditingController _controller;

  String get number => _notifier.value + _controller.text;

  dispose() {
    _notifier.dispose();
    _controller.dispose();
  }
}
