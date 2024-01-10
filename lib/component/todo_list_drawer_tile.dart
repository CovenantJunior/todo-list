import 'package:flutter/material.dart';

class TodoListDrawerTile extends StatelessWidget {
  
  final String title;
  final Widget leading;
  final void Function()? onTap;


  const TodoListDrawerTile({
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