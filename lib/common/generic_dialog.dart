import 'package:flutter/material.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required Map<String, T?> actions,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.keys
            .map(
              (key) => TextButton(
                onPressed: () {
                  if (actions[key] != null) {
                    Navigator.of(context).pop(actions[key]);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(key),
              ),
            )
            .toList(),
      );
    },
  );
}
