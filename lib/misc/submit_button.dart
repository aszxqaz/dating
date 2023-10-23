import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.submitting,
    required this.label,
  });

  final VoidCallback onPressed;
  final bool submitting;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(180, 60)),
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        ),
      ),
      onPressed: submitting ? null : onPressed,
      child: submitting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(),
            )
          : Text(label),
    );
  }
}
