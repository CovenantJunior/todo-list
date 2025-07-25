import 'package:flutter/material.dart';

class StyledTextLightCenter extends StatelessWidget {
  final String text;
  const StyledTextLightCenter({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
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
