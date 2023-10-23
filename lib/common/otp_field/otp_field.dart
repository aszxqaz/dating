import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.controller,
  });

  final OtpFieldController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: controller._controllers
          .mapIndexed(
            (index, textController) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: textController,
                  autofocus: index == 0,
                  keyboardType: TextInputType.number,
                  focusNode: controller._focusNodes[index],
                  style: const TextStyle(fontSize: 32),
                  decoration: const InputDecoration(),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    controller._handleChange(index, value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class OtpFieldController {
  OtpFieldController(int length)
      : _controllers = List.generate(length, (_) => TextEditingController()),
        _focusNodes = List.generate(length, (_) => FocusNode());

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  String get text => _controllers.map((controller) => controller.text).join();

  _handleChange(int from, String text) {
    text = text.replaceAll(RegExp(r'\D'), '');

    final end = min(text.length, _controllers.length);
    text = text.substring(0, end);

    for (int i = from; i < text.length + from; i++) {
      _controllers[i].text = text[i - from];
    }

    if (text.isNotEmpty) {
      _focusNext(text.length - 1);
    }
  }

  setText(String text, [int from = 0]) {
    for (int i = from; i < _controllers.length; i++) {
      final index = i - from;
      _controllers[i].text = index < text.length ? text[index] : '';
    }
  }

  _focusNext(int index) {
    final empty = _controllers
        .skip(index + 1)
        .toList()
        .indexWhere((controller) => controller.text.isEmpty);

    if (empty != -1) {
      final focusIndex = empty + index + 1;
      _focusNodes[focusIndex].requestFocus();
    } else {
      for (int i = 0; i < _focusNodes.length; i++) {
        _focusNodes[i].unfocus();
      }
    }
  }

  dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
  }
}
