import 'package:flutter/material.dart';

class TodoAbout extends StatelessWidget {
  const TodoAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
      )
    );
  }
}