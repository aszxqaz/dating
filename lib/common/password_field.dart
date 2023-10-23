import 'package:flutter/material.dart';

class ObscureTextField extends StatelessWidget {
  const ObscureTextField({
    super.key,
    this.controller,
    this.errorText,
    this.onChanged,
    required this.labelText,
  });

  final TextEditingController? controller;
  final String? errorText;
  final String labelText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: const TextStyle(
        fontSize: 18,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        // hintText: 'Password',
        labelText: labelText,
        helperText: ' ',
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    super.key,
    this.controller,
    this.errorText,
    this.onChanged,
    required this.labelText,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? errorText;
  final String labelText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      autofocus: autofocus,
      keyboardType: TextInputType.text,
      style: const TextStyle(
        fontSize: 18,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        labelText: labelText,
        helperText: ' ',
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
