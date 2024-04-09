import 'dart:ffi';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/todo_list_options.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:vibration/vibration.dart';

class TodoStarred extends StatefulWidget {
  const TodoStarred({super.key});

  @override
  State<TodoStarred> createState() => _TodoStarredState();
}

class _TodoStarredState extends State<TodoStarred> {
  late final ConfettiController _completedController = ConfettiController();
  Future<bool?> hasVibrate = Vibration.hasVibrator();

  @override
  void initState() {
    super.initState();
    readTodoLists();
  }

  Future<void> readTodoLists() async {
    context.read<TodoListDatabase>().fetchStarredTodoList();
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

  String interval = 'Every Minute';

  TextEditingController dateController = TextEditingController();

  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedCategory = 'Personal';

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

  // ignore: non_constant_identifier_names
  void editTodoList(int id, Plan) {
    Navigator.pop(context);
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
                            selectedCategory = value!;
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
                  SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
                    duration: const Duration(seconds: 2),
                    content: const Text(
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
                  SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
                    duration: const Duration(seconds: 2),
                    content: const Text(
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

  List cardToRemove = [];

  void dismissAction (id) {
      bool undo = true;
      setState(() {
        cardToRemove.add(id);
      });
      Future.delayed(const Duration(seconds: 5), () {
        if (undo == true) {
          context.read<TodoListDatabase>().trashTodoList(id);
          Future.delayed(const Duration(seconds: 2), () {
            cardToRemove.clear();
          });
          setState(() {
            undo = true;
          });
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: const Text('Trashed',
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500
              )
            ),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() {
                  undo = false;
                });
                cardToRemove.clear();
              }
          )
        ),
      );
    }

    // Swipe Trash
    void swiptTrashTodoList(int id) {
      context.read<TodoListDatabase>().preferences.first.vibration == true
          ? Vibration.vibrate(duration: 50)
          : Void;
      context.read<TodoListDatabase>().preferences.first.autoDeleteOnDismiss ==
        false ? showDialog(
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
                dismissAction(id);
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
      ) : dismissAction(id);
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
        content: SingleChildScrollView(
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
        actions: [
          IconButton(
            onPressed: () {
              editTodoList(plan.id, plan);
            },
            icon: const Icon(Icons.edit)
          )
        ],
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

  void multiEdit(List starredTodoLists) {
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
              items: starredTodoLists.map((e) => MultiSelectItem(e, e.plan)).toList(),
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
              message: "Unstar Plan",
              child: IconButton(
                icon: const Icon(
                  Icons.star_outline_rounded,
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
                      context.read<TodoListDatabase>().star(selectedList.id);
                    }
                    if (selectedLists.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                          'Unstarring ${selectedLists.length} plans',
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
                          'Unstarring plan',
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
          ],
        )
      );
    }


  TextEditingController textController = TextEditingController();
  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];

  @override
  Widget build(BuildContext context) {
    List starredTodoLists = context.watch<TodoListDatabase>().starredTodoLists;
    
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
            context.read<TodoListDatabase>().searchStarred(q.toLowerCase());
          } else {
            setState(() {
              isOfLength = false;
              searchResults = [];
            });
            context.read<TodoListDatabase>().fetchTodoList();
          }
          for (var plans in starredTodoLists) {
            if (plans.plan.toLowerCase().contains(q.toLowerCase())) {
              searchResults.add(starredTodoLists);
              setState(() {
                searchResults = searchResults;
              });
            }
          }
        },
      );
    }

    void mark(plan) {
      if (plan.completed == true) {
        context.read<TodoListDatabase>().replan(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
            duration: const Duration(seconds: 2),
            content: const Text(
            'Plan reactivated!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500
            )
          )));
      } else {
        context.read<TodoListDatabase>().completed(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
            duration: const Duration(seconds: 2),
            content: const Text(
            'Plan accomplished. You inspire!!!',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500
            )
          )));
      }
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
            'Starred',
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
            !isSearch && starredTodoLists.isNotEmpty ?
              Tooltip(
                message: "Search Plans",
                child: IconButton(
                  onPressed: search, 
                  icon: const Icon(
                    Icons.search
                  )
                ),
              ) : const SizedBox(),
            !isSearch && starredTodoLists.isNotEmpty ?
              Tooltip(
                message: "Bulk Edit Plans",
                child: IconButton(
                  onPressed: () {
                    multiEdit(starredTodoLists);
                  },
                  icon: const Icon(
                    Icons.edit
                  )
                ),
              ) : const SizedBox(),
          ],
        ),

        body: starredTodoLists.isNotEmpty || isSearch ? LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 200,
          onRefresh: () async {
            readTodoLists();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: starredTodoLists.length,
              itemBuilder: (context, index) {
              final plan = starredTodoLists[index];
              return GestureDetector(
                onDoubleTap: () {
                  mark(plan);
                },
                child: Builder(
                  builder: (context) {
                    return plan.starred == true ? GestureDetector(
                      onLongPress: () {
                        showPopover(
                          direction: PopoverDirection.top,
                          width: 290,
                          context: context,
                          bodyBuilder: (context) => TodoListOptions(
                            id: plan.id,
                            plan: plan.plan,
                            Plan: plan,
                            deleteAction: dismissAction,
                            completedController: _completedController
                          )
                        );
                      },
                      onTap: () {
                        planDetails(plan);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Visibility(
                          visible: !cardToRemove.contains(plan.id),
                          child: Card(
                            surfaceTintColor: tint(plan.completed),
                            child: Dismissible(
                              key: Key("${plan.id}"),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                swiptTrashTodoList(plan.id);
                                return null;
                              },
                              background: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(Icons.delete, color: Colors.white),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(Icons.delete, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 40,
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
                                        /* Builder(
                                          builder: (context) {
                                            return IconButton(
                                              onPressed: () {
                                                showPopover(
                                                  width: 370,
                                                  context: context,
                                                  bodyBuilder: (context) => TodoListOptions(id: plan.id, plan: plan.plan, Plan: plan)
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.more_vert, 
                                                color:Colors.blueGrey
                                              )
                                            );
                                          }
                                        ), */
                                        /* TodoListOptions(
                                          id: plan.id,
                                          plan: plan.plan
                                        ) */
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.star_rounded, color: Colors.orangeAccent),
                                        )
                                      ],
                                    ),
                                    /* const Divider(height: 25),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.rocket_launch_outlined,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          DateFormat('EEE, MMM d yyyy').format(plan.due),
                                          style: const TextStyle(
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500,
                                            // fontSize: 10
                                          ),
                                        ),
                                      ],
                                    ) */
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ) : const SizedBox();
                  }
                ),
              );
            }),
          ),
        ) : !isSearch ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/star.gif', height: 70),
              const Text(
                "No starred plan yet",
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
              Image.asset('assets/images/star.gif', height: 70),
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
        ) : const SizedBox(),
      ),
    );
  }
}