import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  const StyledText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.w900,
        fontSize: 12,
        color: Colors.white,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}