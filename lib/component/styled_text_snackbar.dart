import 'package:flutter/material.dart';

class StyledTextSnackBar extends StatelessWidget {
  final String text;
  const StyledTextSnackBar({
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
        color: Colors.black,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}