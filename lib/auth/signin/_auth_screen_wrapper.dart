import 'package:dating/common/wrapper_builder.dart';
import 'package:flutter/material.dart';

class AuthScreenWrapper extends StatelessWidget {
  const AuthScreenWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WrapperBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: child,
          ),
        );
      },
    );
  }
}
