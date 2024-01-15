import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TodoListOptions extends StatelessWidget {
  final int id;
  final String plan;
  final TodoList Plan;

  const TodoListOptions({
    super.key,
    required this.id,
    required this.plan,
    required this.Plan
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
              icon: const Tooltip(
                message: "Save Edit",
                child: Icon(Icons.save)
              ),
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

    // Copy to Clipboard
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

    void mark(plan) {
      if (plan.completed == true) {
        context.read<TodoListDatabase>().replan(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
            'Plan reactivated!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold
            )
          )));
      } else {
        context.read<TodoListDatabase>().completed(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
            'Plan accomplished. You inspire!!!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold
            )
          )));
      }
    }


    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            editTodoList(id, plan);
          },
          icon: const Tooltip(
            message: "Edit Plan",
            child: Icon(
              Icons.edit,
              color: Colors.blueGrey,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            copy(plan);
          },
          icon: const Tooltip(
            message: "Copy to Clipboard",
            child: Icon(
              Icons.copy,
              color: Colors.blueGrey,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            share(plan);
          },
          icon: const Tooltip(
            message: "Share Plan",
            child: Icon(
              Icons.share,
              color: Colors.blueGrey,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            mark(Plan);
          },
          icon: 
          Plan.completed! ?
          const Tooltip(
            message: "Reactivate Plan",
            child: Icon(
                Icons.bookmark_remove_rounded,
                color: Colors.blueGrey,
              ),
          ) :
            const Tooltip(
              message: "Mark Plan as Completed",
              child: Icon(
                Icons.bookmark_added_rounded,
                color: Colors.blueGrey,
              ),
            ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            deleteTodoList(id);
          },
          icon: const Tooltip(
            message: "Delete Plan",
            child: Icon(
              Icons.delete,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}