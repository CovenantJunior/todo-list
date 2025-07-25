import 'package:flutter/material.dart';

class PaymentStyledTextWhite extends StatelessWidget {
  final String text;
  const PaymentStyledTextWhite({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w400,
        fontSize: 30,
        color: Colors.white,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
