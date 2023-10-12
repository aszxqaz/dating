import 'package:collection/collection.dart';
import 'package:dating/misc/countries.dart';
import 'package:dating/misc/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part '_controller.dart';
part '_popup.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.controller,
  });

  final PhoneFieldController controller;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final FocusNode focusNode = FocusNode();
  OverlayEntry? overlayEntry;

  void createOverlay() {
    overlayEntry = OverlayEntry(builder: (context) {
      return _CountriesSelectPopup(onChanged: (val) {
        widget.controller._notifier.value = val;
        removeOverlay();
      });
    });

    focusNode.unfocus();

    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    focusNode.requestFocus();
    overlayEntry = null;
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = widget.controller._notifier;

    return TextField(
      focusNode: focusNode,
      autofocus: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ],
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 20, letterSpacing: 2),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: OutlinedButton(
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 20),
              ),
              elevation: MaterialStatePropertyAll(0),
              textStyle: MaterialStatePropertyAll(
                TextStyle(fontSize: 20, letterSpacing: 2),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                ),
              ),
            ),
            onPressed: () {
              createOverlay();
            },
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, value, __) => Text(value),
            ),
          ),
        ),
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
