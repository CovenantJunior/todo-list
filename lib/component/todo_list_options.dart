import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TodoListOptions extends StatelessWidget {
  final int id;
  final String plan;

  const TodoListOptions({
    super.key,
    required this.id,
    required this.plan
  });

  @override
  Widget build(BuildContext context) {
    // Access user input
    final textController = TextEditingController();

    // Update
    void editTodoList(int id, plan) {
      textController.text = plan;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                String text = textController.text;
                if (text.isNotEmpty) {
                  context.read<TodoListDatabase>().updateTodoList(id, text);
                  Navigator.pop(context);
                  textController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Updated and fresh!',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                }
              }
            )
          ],
        )
      );
    }

    // Delete
    void deleteTodoList(int id) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "Delete Plan?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Quicksand',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<TodoListDatabase>().deleteTodoList(id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Poof! Gone like the wind',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
              },
              icon: const Icon(
                Icons.done,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel_outlined,
              ),
            ),
          ],
        ) 
      );
    }

    // Miscellaneous

    // Share TodoList
    void share(String plan) {
      Share.share(plan);
    }

    void copy(String plan) {
      Clipboard.setData (
        ClipboardData(
          text: plan
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Copied and locked! Paste at your leisure!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold
            )
          )));
    }
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            editTodoList(id, plan);
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            copy(plan);
          },
          icon: const Icon(
            Icons.copy,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            share(plan);
          },
          icon: const Icon(
            Icons.share,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            deleteTodoList(id);
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}