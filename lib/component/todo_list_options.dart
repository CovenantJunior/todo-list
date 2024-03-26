import 'dart:ffi';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';

class TodoListOptions extends StatefulWidget {
  final int id;
  final String plan;
  // ignore: non_constant_identifier_names
  final TodoList Plan;
  final Function(int) deleteAction;
  late final ConfettiController completedController = ConfettiController();

  TodoListOptions({
    super.key,
    required this.id,
    required this.plan,
    // ignore: non_constant_identifier_names
    required this.Plan,
    required this.deleteAction,
    required completedController
  });

  @override
  State<TodoListOptions> createState() => _TodoListOptionsState();
}

class _TodoListOptionsState extends State<TodoListOptions> {
  
  @override
  void dispose() {
    widget.completedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String interval = 'Every Minute';
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
            "Edit plan",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
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
                          minLines: 1,
                          maxLines: 20,
                          controller: textController,
                          decoration: const InputDecoration(
                            hintText: 'Task description',
                            hintStyle: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500
                              ),
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
                            labelStyle: TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500
                            ),
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
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
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
                              labelStyle: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500
                              ),
                              hintText: 'Select due date',
                              hintStyle: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500
                              ),
                              border: InputBorder.none
                            ),
                            child: TextField(
                              controller: dateController,
                              style: const TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputDecorator(
                          decoration: const InputDecoration(
                              labelText: 'Interval',
                              labelStyle: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none),
                          child: DropdownButtonFormField<String>(
                            value: Plan.interval,
                            onChanged: (value) {
                              interval = value!;
                            },
                            items: [
                              'Every Minute',
                              'Hourly',
                              'Daily',
                              'Weekly'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            isExpanded: true,
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.undo_rounded),
            ),
            IconButton(
              icon: const Icon(Icons.add_task_rounded),
              onPressed: () {
                String text = textController.text;
                String due = dateController.text;
                String? category = selectedCategory;
                if (text.isNotEmpty) {
                  context.read<TodoListDatabase>().updateTodoList(Plan.id, text, category, due, interval);
                  Navigator.pop(context);
                  textController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                        'Plan saved',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                } else {
                  context.watch<TodoListDatabase>().preferences.first.vibration == true ? Vibration.vibrate(duration: 50) : Void;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                        'Oops, blank shot!',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w500,
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
      context.watch<TodoListDatabase>().preferences.first.vibration == true ? Vibration.vibrate(duration: 50) : Void;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "Move plan to Trash?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Quicksand',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                widget.deleteAction(id);
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
    void share(plan) {
      Share.share(plan);
    }

    // Copy to Clipboard
    // ignore: non_constant_identifier_names
    void copy(plan) {
      Clipboard.setData (
        ClipboardData(
          text: plan
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
            'Copied and locked! Paste at your leisure!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500
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
              fontWeight: FontWeight.w500
            )
          )));
      } else {
        context.read<TodoListDatabase>().completed(Plan.id);
        widget.completedController.play();
        Future.delayed(const Duration(seconds: 5), () {
          widget.completedController.stop();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
            'Plan accomplished. You inspire!!!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500
            )
          )));
      }
    }


    return Scaffold(
      body: Row(
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
              context.read<TodoListDatabase>().star(widget.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: widget.Plan.starred != true ?
                  const Text(
                    'Starred!',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500
                    )
                ) : const Text(
                    'Unstarred!',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500
                    )
                )
              )
            );
            },
            icon: Tooltip(
              message: widget.Plan.starred != true ? "Star" : "Unstar",
              child: widget.Plan.starred != true ? const Icon(
                  Icons.star_outlined,
                  color: Colors.orangeAccent
                ) : const Icon(
                  Icons.star_outline_rounded,
                  color: Colors.blueGrey,
                )
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
                  Icons.bookmark_remove_outlined,
                  color: Colors.blueGrey,
                ),
            ) :
              const Tooltip(
                message: "Mark Plan as Completed",
                child: Icon(
                  Icons.bookmark_added_outlined,
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
              message: "Trash Plan",
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}