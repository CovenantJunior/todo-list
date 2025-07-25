import 'package:flutter/material.dart';

class StyledTitle extends StatelessWidget {
  final String text;
  const StyledTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16
      ),
    );
  }
}
