import 'package:flutter/material.dart';

class StyledTextLabel extends StatelessWidget {
  final String text;
  const StyledTextLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        color: Colors.white,
      ),
    );
  }
}
