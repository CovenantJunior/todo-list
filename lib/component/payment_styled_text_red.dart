import 'package:flutter/material.dart';

class PaymentStyledTextRed extends StatelessWidget {
  final String text;
  const PaymentStyledTextRed({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w400,
        fontSize: 30,
        color: Colors.red,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
