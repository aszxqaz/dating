// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInput extends StatefulWidget {
  const PinInput({
    super.key,
    required this.controller,
    required this.length,
  });

  final PinInputController controller;
  final int length;

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    widget.controller._setPinInputState(this);
    for (int i = 0; i < widget.length; i++) {
      final controller = TextEditingController(text: '');
      controllers.add(controller);
      focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.length; i++) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length * 2 - 1,
        (index) {
          final isInput = index % 2 == 0;
          final pinIndex = index ~/ 2;
          return isInput
              ? _PinCell(
                  controller: controllers[pinIndex],
                  focusNode: focusNodes[pinIndex],
                  onChanged: (value) {
                    if (value.isNotEmpty && pinIndex < widget.length - 1) {
                      focusNodes[pinIndex + 1].requestFocus();
                    } else if (value.isEmpty && pinIndex > 0) {
                      focusNodes[pinIndex - 1].requestFocus();
                    }
                  },
                )
              : SizedBox(width: 16);
        },
      ),
    );
  }
}

class _PinCell extends StatelessWidget {
  const _PinCell({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: Center(
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          focusNode: focusNode,
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
          ),
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}

class PinInputController {
  late _PinInputState _pinInputState;

  void _setPinInputState(_PinInputState state) {
    _pinInputState = state;
  }

  String get text =>
      _pinInputState.controllers.map((controller) => controller.text).join();
}
