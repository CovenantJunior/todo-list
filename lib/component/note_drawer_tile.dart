import 'package:flutter/material.dart';

class NoteDrawerTile extends StatelessWidget {
  
  final String title;
  final Widget leading;
  final void Function()? onTap;


  const NoteDrawerTile({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        title: Text(title),
        leading: leading,
        onTap: onTap,
      ),
    );
  }
}