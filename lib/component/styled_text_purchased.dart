import 'package:flutter/material.dart';

class StyledTextPurchased extends StatelessWidget {
  final String text;
  const StyledTextPurchased({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: Colors.white,
        overflow: TextOverflow.visible,
        decoration: TextDecoration.underline,
        decorationColor: Colors.white
      ),
    );
  }
}
