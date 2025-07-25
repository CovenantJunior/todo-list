import 'package:flutter/material.dart';

class StyledTextRed extends StatelessWidget {
  final String text;
  const StyledTextRed({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.red,
      ),
    );
  }
}
