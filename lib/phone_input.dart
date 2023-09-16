// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating/controller.dart';
import 'package:dating/countries.dart';

class PhoneInput extends StatefulWidget {
  const PhoneInput({super.key, required this.getter});

  final PhoneInputValueGetter getter;

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  String code = countriesInfo.first['dial_code']!;

  final values = StreamController<String>.broadcast();
  late PhoneInputController phoneController;
  final textController = TextEditingController(text: '');
  final focusNode = FocusNode();

  @override
  void initState() {
    phoneController = PhoneInputController(values.stream);
    phoneController.state.listen((state) {
      textController.text = state.text;
      widget.getter._set(state.text);
    });
    values.add('+');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: phoneController.state,
              builder: (context, snapshot) {
                if (snapshot.data == null) return Container();
                final state = snapshot.data!;
                print('STATE: ${state.toString()}');
                final isPopupShown = state.code == null &&
                    state.codes != null &&
                    state.codes!.length <= 10;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        if (state.code != null) Text(state.code!),
                        TextField(
                          autofocus: true,
                          controller: textController,
                          focusNode: focusNode,
                          onChanged: (value) {
                            setState(() {
                              values.add(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                          // inputFormatters: [
                          //   PhoneInputFormatter(),
                          // ],
                          style: TextStyle(),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                            hintText: '+',
                            labelText: 'Phone number',
                            errorText: snapshot.data?.error,
                          ),
                        ),
                        const SizedBox(
                          height: 300,
                        ),
                      ],
                    ),
                    if (isPopupShown)
                      Positioned(
                        top: 30,
                        child: Container(
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: state.codes!.map((info) {
                                return TextButton.icon(
                                  onPressed: () {
                                    phoneController
                                        .selectCode(info['dial_code']!);

                                    textController.selection =
                                        TextSelection.collapsed(
                                      offset: textController.text.length,
                                    );

                                    focusNode.requestFocus();
                                  },
                                  icon: Container(
                                    width: 24,
                                    height: 16,
                                    child: SvgPicture.asset(
                                      'assets/flags2/${info['code']}.svg',
                                    ),
                                  ),
                                  label: Text(
                                    '${info['name']} (${info['dial_code']})',
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// class PhoneInputFormatter extends TextInputFormatter {
//   static final regex = RegExp(r'^\+.*$');

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (!isValid(newValue.text)) return oldValue;
//     // if (!newValue.text.startsWith('+')) {
//     //   return newValue.copyWith(text: '+${newValue.text}');
//     // }
//     return newValue;
//     // if()
//   }

//   isValid(String input) {
//     return regex.hasMatch(input);
//   }
// }

class PhoneInputValueGetter {
  PhoneInputValueGetter();

  String _text = '';

  String get value => _text;
  void _set(String v) {
    _text = v;
  }
}