import 'package:flutter/material.dart';

class StyledTextDark extends StatelessWidget {
  final String text;
  const StyledTextDark({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
