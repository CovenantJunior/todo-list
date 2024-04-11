import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/todo_list_trash_options.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:vibration/vibration.dart';

class TodoTrash extends StatefulWidget {
  const TodoTrash({super.key});

  @override
  State<TodoTrash> createState() => _TodoTrashState();
}

class _TodoTrashState extends State<TodoTrash> {
  
  @override
  void initState() {
    super.initState();
    readTodoLists();
  }

  Future<void> readTodoLists() async {
    context.read<TodoListDatabase>().fetchTrashedTodoList();
  }

  void search () {
    setState(() {
      isSearch = !isSearch;
      isOfLength = false;
      searchResults.clear();
    });
  }

  void closeSearch() {
    readTodoLists();
    setState(() {
      isSearch = false;
      isOfLength = false;
    });
  }

  void restoreAll() {
      context.watch<TodoListDatabase>().preferences.first.vibration == true ? Vibration.vibrate(duration: 50) : Void;
      setState(() {
        isSearch = false;
        isOfLength = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "Restore all plans?",
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
                context.read<TodoListDatabase>().restoreAllTodoLists(trashedTodoListState);
                String message = trashedTodoListState.length > 1 ? 'Restoring ${trashedTodoListState.length} plans' : 'Restoring plan';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 4),
                    content: Text(message,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500
                      )
                    ),
                  ),
                );
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

  void planDetails(plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Details",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w500,
            // fontSize: 25
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(plan.plan, style: const TextStyle(fontFamily: "Quicksand"))
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(plan.category, style: const TextStyle(fontFamily: "Quicksand"))
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    plan.completed == true ? const Text("Proudly executed", style: TextStyle(fontFamily: "Quicksand")) : const Text("Uncompleted", style: TextStyle(fontFamily: "Quicksand"))
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Starred",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    plan.starred == true ? const Text("Starred", style: TextStyle(fontFamily: "Quicksand")) : const Text("Not starred", style: TextStyle(fontFamily: "Quicksand"))
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Date Created",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(DateFormat('EEE, MMM d yyyy HH:mm:ss').format(plan.created), style: const TextStyle(fontFamily: "Quicksand"))
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Due Date",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    plan.due != null ? Text(DateFormat('EEE, MMM d yyyy HH:mm:ss').format(plan.due), style: const TextStyle(fontFamily: "Quicksand")) : const Text('Unset', style: TextStyle(fontFamily: "Quicksand"))
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Date Modified",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    plan.modified != null ?
                      Text(DateFormat('EEE, MMM d yyyy HH:mm:ss').format(plan.modified), style: const TextStyle(fontFamily: "Quicksand"))
                    : const Text('Not yet modified', style: TextStyle(fontFamily: "Quicksand")),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Date Achieved",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        // fontSize: 15,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    plan.achieved != null ?
                      Text(DateFormat('EEE, MMM d yyyy HH:mm:ss').format(plan.achieved), style: const TextStyle(fontFamily: "Quicksand"))
                    : const Text('Not yet achieved', style: TextStyle(fontFamily: "Quicksand")),
                  ],
                )
              ],
            ),
          ),
        )
      )
    );
  }

  TextDecoration decorate(bool completed) {
    if (completed == true) {
      return TextDecoration.lineThrough;
    } else {
      return TextDecoration.none;
    }
  }

  Color? tint(bool completed) {
    if (completed == true) {
      return Colors.yellow;
    } else {
      return null;
    }
  }

  void multiEdit(List trashedTodoList) {
      List selectedLists = [];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Edit Plans",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500
            ),
          ),
          content: SingleChildScrollView(
            child: MultiSelectDialogField(
              buttonText: const Text(
                "Tap to select plans",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500
                ),
              ),
              buttonIcon: const Icon(
                Icons.waving_hand_rounded
              ),
              cancelText: const Text("Leave"),
              confirmText: const Text("Done"),
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              selectedItemsTextStyle: const TextStyle(
                color: Colors.white
              ),
              selectedColor: Colors.grey,
              items: trashedTodoList.map((e) => MultiSelectItem(e, e.plan)).toList(),
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
                icon: const Icon(
                  Icons.undo_rounded
                )
              ),
            ),
            Tooltip(
              message: "Restore Plan",
              child: IconButton(
                icon: const Icon(
                  Icons.restart_alt_rounded,
                ),
                // color: Colors.blueGrey,
                onPressed: () {
                  if (selectedLists.isEmpty) {
                    context.watch<TodoListDatabase>().preferences.first.vibration == true ? Vibration.vibrate(duration: 50) : Void;
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
                      duration: const Duration(seconds: 2),
                      content: const Text(
                      'Please select a plan to deal with',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500
                      )
                    )));
                  } else {
                    for (var selectedList in selectedLists) {
                      context.read<TodoListDatabase>().restoreTodoLists(selectedList.id);
                    }
                    if (selectedLists.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                          'Restoring ${selectedLists.length} plans',
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w500
                          )
                        )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                          duration: const Duration(seconds: 2),
                          content: const Text(
                          'Restoring plan',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w500
                          )
                        )));
                    }
                    Navigator.pop(context);
                  }
                }
              ),
            ),
             Tooltip(
              message: "Delete selected plan(s)",
              child: IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                // color: Colors.blueGrey,
                onPressed: () {
                  context.watch<TodoListDatabase>().preferences.first.vibration == true ? Vibration.vibrate(duration: 50) : Void;
                  if (selectedLists.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                      ),
                      duration: const Duration(seconds: 2),
                      content: const Text(
                      'Please select a plan to deal with',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500
                      )
                    )));
                  } else {
                    context.watch<TodoListDatabase>().preferences.first.vibration == true ? Vibration.vibrate(duration: 50) : Void;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text(
                          "Delete Selected Plan(s) Forever?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              for (var selectedList in selectedLists) {
                                context.read<TodoListDatabase>().deleteTodoList(selectedList.id);
                              }
                              if (selectedLists.length > 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    content: Text(
                                    'Deleting ${selectedLists.length} selected plans',
                                    style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500
                                    )
                                  )));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)
                                    ),
                                    duration: const Duration(seconds: 2),
                                    content: const Text(
                                    'Deleting selected plan',
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500
                                    )
                                  )));
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
                      ) 
                    );
                  }
                }
              ),
            )
          ],
        )
      );
    }


  TextEditingController textController = TextEditingController();
  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];
  List trashedTodoListState = [];

  @override
  Widget build(BuildContext context) {
    List trashedTodoList = context.watch<TodoListDatabase>().trashedTodoLists;
    setState(() {
      trashedTodoListState = trashedTodoList;
    });
    
    Widget searchTextField() { //add
      return TextField(
        controller: textController,
        autofocus: true,
        autocorrect: true,
        decoration:
          const InputDecoration(
            labelText: 'Search Plans',
            labelStyle: TextStyle(
              fontFamily: "Quicksand"
            )
          ),
        onChanged: (q) {
          if (q.isNotEmpty) {
            setState(() {
              isOfLength = true;
              searchResults = [];
            });
            context.read<TodoListDatabase>().searchTrash(q.toLowerCase());
          } else {
            setState(() {
              isOfLength = false;
              searchResults = [];
            });
            context.read<TodoListDatabase>().fetchTodoList();
          }
          for (var plans in trashedTodoList) {
            if (plans.plan.toLowerCase().contains(q.toLowerCase())) {
              searchResults.add(trashedTodoList);
              setState(() {
                searchResults = searchResults;
              });
            }
          }
        },
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          isSearch = false;
          isOfLength = false;
        });
        context.read<TodoListDatabase>().fetchTodoList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: isSearch ?
          searchTextField() :
          const Text(
            'Trash',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500
            ),
          ),
          centerTitle: true,
          actions: [
            isOfLength ? IconButton(
              onPressed: () {
                textController.clear();
                setState(() {
                  searchResults.clear();
                  isOfLength = false;
                });
              },
              icon: const Icon(
                  Icons.close,
                ),
              tooltip: 'Search Plans',
              style: TextButton.styleFrom(
                shape: const CircleBorder(),
              ),
            ) : const SizedBox(),
            !isSearch && trashedTodoList.isNotEmpty ?
              Tooltip(
                message: "Search Plans",
                child: IconButton(
                  onPressed: search, 
                  icon: const Icon(
                    Icons.search
                  )
                ),
              ) : const SizedBox(),
            !isSearch && trashedTodoList.isNotEmpty ?
              Tooltip(
                message: "Bulk Edit Plans",
                child: IconButton(
                  onPressed: () {
                    multiEdit(trashedTodoList);
                  },
                  icon: const Icon(
                    Icons.edit
                  )
                ),
              ) : const SizedBox(),
          ],
        ),

        body: trashedTodoList.isNotEmpty ? LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 200,
          onRefresh: () async {
            readTodoLists();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_delete_outlined),
                      SizedBox(width: 5),
                      Text(
                        "Plans here are deleted forever after 30 days.",
                        style: TextStyle(
                          fontFamily: "Quicksand"
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: trashedTodoList.length,
                    itemBuilder: (context, index) {
                    final plan = trashedTodoList[index];
                    return Builder(
                      builder: (context) {
                        return plan.trashed == true ? GestureDetector(
                          onLongPress: () {
                            showPopover(
                              arrowDxOffset: 50,
                              direction: PopoverDirection.top,
                              width: 100,
                              context: context,
                              bodyBuilder: (context) => TodoListTrashOptions(id: plan.id, plan: plan.plan, Plan: plan)
                            );
                          },
                          onTap: () {
                            planDetails(plan);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              surfaceTintColor: tint(plan.completed),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Text(
                                              plan.plan,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                decoration: decorate(plan.completed),
                                              ),
                                            ),
                                          ),
                                        ),
                                        plan.starred ? const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Icon(Icons.star_rounded, color: Colors.orangeAccent),
                                    ) : const SizedBox()
                                      ],
                                    ),
                                    const Divider(height: 25),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.delete_sweep_outlined,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          plan.trashedDate != null ? DateFormat('EEE, MMM d yyyy').format(plan.due) : "Something went wrong",
                                          style: const TextStyle(
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ) : const SizedBox();
                      }
                    );
                  }),
                ),
              ],
            ),
          ),
        ) : !isSearch ?
          Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/trash.gif', height: 70),
              const Text(
                "You have no trash",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ))
          : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/trash.gif', height: 70),
              const Text(
                "No result",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          )),

        floatingActionButton: isSearch ? Tooltip(
          message: "Close Search",
          child: FloatingActionButton(
              onPressed: closeSearch,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              child: Transform.rotate(
                angle: 45 * (3.141592653589793238 / 180), // Rotate 45 degrees if isSearch is true
                child: const Icon(Icons.add),
              ),
            ),
        ) : trashedTodoListState.isNotEmpty ? Tooltip(
          message: "Restore all Plans",
          child: FloatingActionButton(
              onPressed: restoreAll,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.restart_alt_rounded),
            ),
        ) : const SizedBox(),
      ),
    );
  }
}