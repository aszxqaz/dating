import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50),
      child: Center(
        child: OTPTextField(
          controller: otpController,
          length: 5,
          fieldWidth: 48,
          spaceBetween: 16,
        ),
      ),
    );
  }
}
