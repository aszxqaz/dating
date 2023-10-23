import 'package:dating/misc/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class ProfileQuote extends StatelessWidget {
  const ProfileQuote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/icons/quote3.svg', width: 28, height: 28),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 24,
            ),
            child: Text(
              text,
              // textAlign: TextAlign.center,
              style: context.textTheme.titleLarge!,
            ),
          ),
        ),
      ],
    );
  }
}

class EditableProfileQuote extends StatefulWidget {
  const EditableProfileQuote({
    super.key,
    required this.text,
    required this.onSubmit,
  });

  final String text;
  final ValueChanged<String> onSubmit;

  @override
  State<EditableProfileQuote> createState() => _EditableProfileQuoteState();
}

class _EditableProfileQuoteState extends State<EditableProfileQuote> {
  bool editMode = false;
  late TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    controller = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditableProfileQuote oldWidget) {
    controller.text = widget.text;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toEditMode() {
    setState(() {
      editMode = true;
    });
    focusNode.requestFocus();
  }

  void submit() {
    widget.onSubmit(controller.text.trim());
    setState(() {
      editMode = false;
    });
  }

  void cancel() {
    setState(() {
      editMode = false;
    });
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/icons/quote3.svg', width: 28, height: 28),
        if (!editMode && widget.text.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 8, 4),
            child: TextButton(
              onPressed: toEditMode,
              child: const Text('SET STATUS'),
            ),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 4),
              child: editMode
                  ? Column(
                      children: [
                        TextField(
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 100,
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          inputFormatters: [NoNewLineInputFormatter()],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: submit,
                              child: const Text('OK'),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: cancel,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: context.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.text,
                          // textAlign: TextAlign.center,
                          style: context.textTheme.titleLarge!,
                        ),
                        TextButton(
                          onPressed: toEditMode,
                          child: const Text('EDIT'),
                        ),
                      ],
                    ),
            ),
          ),
      ],
    );
  }
}

class NoNewLineInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.text.contains('\n') ? oldValue : newValue;
  }
}

// return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SvgPicture.asset('assets/icons/quote3.svg', width: 28, height: 28),
//         if (!editMode && widget.text.isEmpty)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 24, 8, 4),
//             child: TextButton(
//               onPressed: toEditMode,
//               child: const Text('SET STATUS'),
//             ),
//           )
//         else
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(8, 20, 8, 4),
//               child: editMode
//                   ? Column(
//                       children: [
//                         TextField(
//                           minLines: 1,
//                           maxLines: 5,
//                           maxLength: 100,
//                           controller: controller,
//                           focusNode: focusNode,
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             isDense: true,
//                           ),
//                           inputFormatters: [NoNewLineInputFormatter()],
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             TextButton(
//                               onPressed: submit,
//                               child: const Text('OK'),
//                             ),
//                             const SizedBox(width: 16),
//                             TextButton(
//                               onPressed: cancel,
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   color: context.colorScheme.error,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.text,
//                           // textAlign: TextAlign.center,
//                           style: context.textTheme.titleLarge!,
//                         ),
//                         TextButton(
//                           onPressed: toEditMode,
//                           child: const Text('EDIT'),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//       ],
//     );