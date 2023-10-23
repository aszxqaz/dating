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
    this.errorText,
  });

  final PhoneFieldController controller;
  final String? errorText;

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
      controller: widget.controller._controller,
      focusNode: focusNode,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ],
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 19, letterSpacing: 1.2),
      decoration: InputDecoration(
        errorText: widget.errorText,
        helperText: ' ',
        hintText: '9876543210',
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(0),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 80),
            child: Material(
              color: context.colorScheme.primary,
              type: MaterialType.button,
              child: InkWell(
                onTap: () {
                  createOverlay();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 11),
                  child: ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (_, value, __) => Center(
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ElevatedButton(
//             style = const ButtonStyle(
//               padding: MaterialStatePropertyAll(
//                 EdgeInsets.symmetric(horizontal: 20),
//               ),
//               elevation: MaterialStatePropertyAll(0),
//               textStyle: MaterialStatePropertyAll(
//                 TextStyle(fontSize: 20, letterSpacing: 2),
//               ),
//               shape: MaterialStatePropertyAll(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(6),
//                     bottomLeft: Radius.circular(6),
//                   ),
//                 ),
//               ),
//             ),
//             onPressed = () {
//               createOverlay();
//             },
//             child = ValueListenableBuilder(
//               valueListenable: notifier,
//               builder: (_, value, __) => Text(value),
//             ),
//           ),
//         );