import 'package:flutter/material.dart';

class StyledTextLight extends StatelessWidget {
  final String text;
  const StyledTextLight({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.w400,
        fontSize: 11,
        color: Colors.white,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
