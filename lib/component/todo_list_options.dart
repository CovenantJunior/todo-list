import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TodoListOptions extends StatefulWidget {
  final int id;
  final String plan;
  // ignore: non_constant_identifier_names
  final TodoList Plan;

  const TodoListOptions({
    super.key,
    required this.id,
    required this.plan,
    // ignore: non_constant_identifier_names
    required this.Plan
  });

  @override
  State<TodoListOptions> createState() => _TodoListOptionsState();
}

class _TodoListOptionsState extends State<TodoListOptions> {
  @override
  Widget build(BuildContext context) {
    // Access user input
    final textController = TextEditingController();
    final dateController = TextEditingController();
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DateTime selectedDate = DateTime.now();
    String? selectedCategory = widget.Plan.category;

    Future<void> selectDate(BuildContext context, due) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: due,
        firstDate: selectedDate,
        lastDate: DateTime(3000),
      );

      dateController.text = DateFormat('yyyy-MM-dd').format(picked!);
      if (mounted && picked != selectedDate) {
        setState(() {
          dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }

      // Update
      // ignore: non_constant_identifier_names
      void editTodoList(int id, Plan) {
        textController.text = Plan.plan;
        dateController.text = Plan.due != null ? DateFormat('yyyy-MM-dd').format(Plan.due) : date;
        showDialog (
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Add a plan",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          null;
                        },
                        child: const Icon(
                          Icons.mic
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          autocorrect: true,
                          autofocus: true,
                          maxLines: 1,
                          maxLength: 100,
                          controller: textController,
                          decoration: const InputDecoration(
                            hintText: 'Task description',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.category),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: InputBorder.none
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            onChanged: (value) {
                              selectedCategory = value;
                            },
                            items: ['Personal', 'Work', 'Study', 'Shopping', 'Sport', 'Wishlist']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            selectDate(context, Plan.due);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Due Date',
                              hintText: 'Select due date',
                              border: InputBorder.none
                            ),
                            child: TextField(
                              controller: dateController,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.undo_rounded),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  String text = textController.text;
                  String due = dateController.text;
                  String? category = selectedCategory;
                  if (text.isNotEmpty) {
                    context.read<TodoListDatabase>().updateTodoList(Plan.id, text, category, due);
                    Navigator.pop(context);
                    textController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(
                          'Plan saved',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(
                          'Oops, blank shot!',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          )
        );
      }

      // Trash
      void trashTodoList(int id) {
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
                  context.read<TodoListDatabase>().trashTodoList(id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(
                        'Trashed',
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
      // ignore: non_constant_identifier_names
      void share(Plan) {
        Share.share(Plan.plan);
      }

      // Copy to Clipboard
      // ignore: non_constant_identifier_names
      void copy(Plan) {
        Clipboard.setData (
          ClipboardData(
            text: Plan.plan
            )
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text(
              'Copied and locked! Paste at your leisure!',
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold
              )
            )));
      }

      // ignore: non_constant_identifier_names
      void mark(Plan) {
        if (Plan.completed == true) {
          context.read<TodoListDatabase>().replan(Plan.id);
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
          context.read<TodoListDatabase>().completed(Plan.id);
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {Navigator.pop(context);
              editTodoList(widget.Plan.id, widget.Plan);
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
              copy(widget.plan);
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
              share(widget.plan);
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
              mark(widget.Plan);
            },
            icon: 
            widget.Plan.completed! ?
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
              trashTodoList(widget.Plan.id);
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