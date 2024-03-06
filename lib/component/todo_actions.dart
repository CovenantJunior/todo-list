import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:vibration/vibration.dart';

// ignore: must_be_immutable
class TodoActions extends StatefulWidget {
  final String category;
  final List nonTrashedTodolists;
  final Function() isSearch;

  const TodoActions({
    super.key,
    required this.category,
    required this.nonTrashedTodolists, 
    required this.isSearch 
  });

  @override
  State<TodoActions> createState() => _TodoActionsState();
}

class _TodoActionsState extends State<TodoActions> with TickerProviderStateMixin {

  List nonTrashedTodolists = [];

  @override
  Widget build(BuildContext context) {
    if (widget.category == 'All') {
      nonTrashedTodolists = widget.nonTrashedTodolists;
    } else {
      setState(() {
        nonTrashedTodolists = widget.nonTrashedTodolists.where((e) => e.category == widget.category).toList();
      });
    }

    void search() {
      widget.isSearch();
    }

    void multiEdit(List nonTrashedTodolists) {
    List selectedLists = [];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Edit Plans",
          style: TextStyle(
              fontFamily: "Quicksand", fontWeight: FontWeight.w500),
        ),
        content: SingleChildScrollView(
          child: MultiSelectDialogField(
            buttonText: const Text(
              "Tap to select plans",
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500),
            ),
            buttonIcon: const Icon(Icons.waving_hand_rounded),
            cancelText: const Text("Leave"),
            confirmText: const Text("Done"),
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            selectedItemsTextStyle: const TextStyle(color: Colors.white),
            selectedColor: Colors.grey,
            items: nonTrashedTodolists
                .where((e) => e.trashed != true)
                .map((e) => MultiSelectItem(e, e.plan))
                .toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              selectedLists = values;
            },
            searchable: true,
          ),
        ),
        actions: [
          Tooltip(
            message: "Cancel search",
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.undo_rounded)),
          ),
          Tooltip(
            message: "Reactivate Plan",
            child: IconButton(
                icon: const Icon(
                  Icons.star_rounded,
                ),
                // color: Colors.blueGrey,
                onPressed: () {
                  if (selectedLists.isEmpty) {
                    context
                                .watch<TodoListDatabase>()
                                .preferences
                                .first
                                .vibration ==
                            true
                        ? Vibration.vibrate(duration: 50)
                        : Void;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                                'Please select a plan to deal with',
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500))));
                  } else {
                    for (var selectedList in selectedLists) {
                      context
                          .read<TodoListDatabase>()
                          .star(selectedList.id);
                    }
                    if (selectedLists.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                              'Starring ${selectedLists.length} plans',
                              style: const TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w500))));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Starring plan',
                                  style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500))));
                    }
                    Navigator.pop(context);
                  }
                }),
          ),
          Tooltip(
            message: "Reactivate Plan",
            child: IconButton(
                icon: const Icon(
                  Icons.bookmark_remove_rounded,
                ),
                // color: Colors.blueGrey,
                onPressed: () {
                  if (selectedLists.isEmpty) {
                    context
                                .watch<TodoListDatabase>()
                                .preferences
                                .first
                                .vibration ==
                            true
                        ? Vibration.vibrate(duration: 50)
                        : Void;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                                'Please select a plan to deal with',
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500))));
                  } else {
                    for (var selectedList in selectedLists) {
                      context
                          .read<TodoListDatabase>()
                          .replan(selectedList.id);
                    }
                    if (selectedLists.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                              'Reactivating ${selectedLists.length} plans',
                              style: const TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w500))));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Reactivating plan',
                                  style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500))));
                    }
                    Navigator.pop(context);
                  }
                }),
          ),
          Tooltip(
            message: "Mark as completed",
            child: IconButton(
                icon: const Icon(
                  Icons.bookmark_added_rounded,
                ),
                // color: Colors.blueGrey,
                onPressed: () {
                  if (selectedLists.isEmpty) {
                    context
                                .watch<TodoListDatabase>()
                                .preferences
                                .first
                                .vibration ==
                            true
                        ? Vibration.vibrate(duration: 50)
                        : Void;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                                'Please select a plan to deal with',
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500))));
                  } else {
                    for (var selectedList in selectedLists) {
                      context
                          .read<TodoListDatabase>()
                          .completed(selectedList.id);
                    }
                    if (selectedLists.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                              'Marking ${selectedLists.length} plans as completed',
                              style: const TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w500))));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Marking plan as completed',
                                  style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500))));
                    }
                    Navigator.pop(context);
                  }
                }),
          ),
          Tooltip(
            message: "Trash selected plan(s)",
            child: IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                // color: Colors.blueGrey,
                onPressed: () {
                  if (selectedLists.isEmpty) {
                    context
                                .watch<TodoListDatabase>()
                                .preferences
                                .first
                                .vibration ==
                            true
                        ? Vibration.vibrate(duration: 50)
                        : Void;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                                'Please select a plan to deal with',
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500))));
                  } else {
                    context
                                .watch<TodoListDatabase>()
                                .preferences
                                .first
                                .vibration ==
                            true
                        ? Vibration.vibrate(duration: 50)
                        : Void;
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: const Text(
                                "Move selected plan(s) to Trash?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    for (var selectedList
                                        in selectedLists) {
                                      context
                                          .read<TodoListDatabase>()
                                          .trashTodoList(selectedList.id);
                                    }
                                    if (selectedLists.length > 1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: const Duration(
                                                  seconds: 2),
                                              content: Text(
                                                  'Deleting ${selectedLists.length} selected plans',
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          "Quicksand",
                                                      fontWeight:
                                                          FontWeight
                                                              .w500))));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(seconds: 2),
                                              content: Text(
                                                  'Deleting selected plan',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Quicksand",
                                                      fontWeight:
                                                          FontWeight
                                                              .w500))));
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context);
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
                            ));
                  }
                }),
          )
        ],
      ));
  }


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tooltip(
                message: "Search Plans",
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    search();
                  },
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                    )
                  )
                )
            ),
            const SizedBox(height: 20),
            Tooltip(
                message: "Edit Plans",
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    multiEdit(nonTrashedTodolists);
                  },
                  child: const Text(
                    'Edit Plans',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                    )
                  )
                )
            ),
          ],
        ),
      ),
    );
  }
}