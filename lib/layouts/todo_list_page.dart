import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:todo_list/component/todo_actions.dart';
import 'package:todo_list/component/todo_list.dart';
import 'package:todo_list/component/todo_list_drawer.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:vibration/vibration.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with SingleTickerProviderStateMixin {
  
  late SpeechToText _speech;
  Future<bool?> hasVibrate = Vibration.hasVibrator();
  String clipboard = '';
  bool requestedClipboard = false;
  bool preState = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
    readTodoLists();
    _speech = SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  TextEditingController textController = TextEditingController();
  String hint = 'Task description';
  TextEditingController dateController = TextEditingController();
  late AnimationController _animationController;
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Personal';
  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];
  List nonTrashedTodolists = [];
  List nonTrashedTodolistsState = [];
  List preference = [];
  List cardToRemove = [];
  bool _isListening = false;
  
  Widget searchTextField() {
    //add
    return TextField(
      controller: textController,
      autofocus: true,
      autocorrect: true,
      decoration: InputDecoration(
          labelText: 'Search Plans / $selectedCategory',
          labelStyle: const TextStyle(fontFamily: "Quicksand")),
      onChanged: (q) {
        if (q.isNotEmpty) {
          setState(() {
            isOfLength = true;
            searchResults = [];
          });
          context.read<TodoListDatabase>().search(q.toLowerCase());
        } else {
          setState(() {
            isOfLength = false;
            searchResults = [];
          });
          readTodoLists();
        }
        for (var plans in nonTrashedTodolists) {
          if (plans.plan.toLowerCase().contains(q.toLowerCase())) {
            searchResults.add(plans);
            setState(() {
              searchResults = searchResults;
            });
          }
        }
      },
    );
  }

  void search() {
    setState(() {
      isSearch = !isSearch;
      isOfLength = false;
      searchResults.clear();
    });
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
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

  Future<void> actionSelectDate(BuildContext context, due) async {
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
      createTodoList('', context);
    }
  }

  void deleteAllAction(nonTrashedTodolistsState) {
    bool undo = true;
    for (var list in nonTrashedTodolistsState) {
      setState(() {
        cardToRemove.add(list.id);
      });
    }
    Future.delayed(const Duration(seconds: 5), () {
      if (undo == true) {
        context
            .read<TodoListDatabase>()
            .trashAllTodoLists(nonTrashedTodolistsState);
        Future.delayed(const Duration(seconds: 3), () {
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
          content: const Text('Moved all to Trash',
              style: TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
          action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() {
                  undo = false;
                });
                cardToRemove.clear();
              })),
    );
  }

  void trashAllTodoLists() {
    context.watch<TodoListDatabase>().preferences.first.vibration == true
        ? Vibration.vibrate(duration: 50)
        : Void;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text(
                "Move all plans to Trash?",
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
                    deleteAllAction(nonTrashedTodolistsState);
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

  // Create
  void createTodoList(String data, BuildContext context) {
    if (data != '') {
      textController.text = data;
    }
    dateController.text == '' ? dateController.text = date : dateController.text= dateController.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Add a plan",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.list_rounded),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            autocorrect: true,
                            autofocus: true,
                            minLines: 1,
                            maxLines: 20,
                            controller: textController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: hint,
                              suffixIcon: context
                                          .watch<TodoListDatabase>()
                                          .preferences
                                          .first
                                          .stt ==
                                      true
                                  ? (IconButton(
                                      onPressed: _listen,
                                      icon: Icon(_isListening == true
                                          ? Icons.mic_off
                                          : Icons.mic)))
                                  : const SizedBox(),
                              hintStyle: const TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w500),
                              labelStyle: const TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w500),
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
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none),
                            child: DropdownButtonFormField<String>(
                              value: selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value!;
                                });
                              },
                              items: [
                                'Personal',
                                'Work',
                                'Study',
                                'Shopping',
                                'Sport',
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  labelText: 'Tap here to choose due date',
                                  labelStyle: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500),
                                  hintText: 'Select due date',
                                  border: InputBorder.none),
                              child: GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: TextField(
                                  readOnly: true,
                                  controller: dateController,
                                  style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500),
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
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    textController.clear();
                    setState(() {
                      selectedDate = DateTime.now();
                      requestedClipboard = true;
                    });
                  },
                  icon: const Icon(Icons.undo_rounded),
                ),
                IconButton(
                  icon: const Icon(Icons.add_task_rounded),
                  onPressed: () {
                    String text = textController.text.trim();
                    String due = dateController.text;
                    String category = selectedCategory;
                    if (text.isNotEmpty) {
                      context
                          .read<TodoListDatabase>()
                          .addTodoList(text, category, due);
                      setState(() {
                        selectedDate = DateTime.now();
                      });
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
                      context.read<TodoListDatabase>().preferences.first.notification == true ? NotificationService().showNotification(
                          id: nonTrashedTodolistsState.first.id + 1,
                          title: "New Plan Recorded",
                          body: text,
                          payload: "Due by $due") : Void;
                    } else {
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
            ));
  }

  // ignore: non_constant_identifier_names
  void editTodoList(int id, Plan) {
    Navigator.pop(context);
    textController.text = Plan.plan;
    dateController.text =
        Plan.due != null ? DateFormat('yyyy-MM-dd').format(Plan.due) : date;
    showDialog(
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
                            child: const Icon(Icons.mic),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              autocorrect: true,
                              autofocus: true,
                              minLines: 1,
                              maxLines: 10,
                              maxLength: 100,
                              controller: textController,
                              decoration: const InputDecoration(
                                hintText: 'Task description',
                                hintStyle: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w500),
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
                                      fontWeight: FontWeight.w500),
                                  border: InputBorder.none),
                              child: DropdownButtonFormField<String>(
                                value: Plan.category,
                                onChanged: (value) {
                                  selectedCategory = value!;
                                },
                                items: [
                                  'Personal',
                                  'Work',
                                  'Study',
                                  'Shopping',
                                  'Sport',
                                  'Wishlist'
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
                                        fontWeight: FontWeight.w500),
                                    hintText: 'Select due date',
                                    hintStyle: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w500),
                                    border: InputBorder.none),
                                child: TextField(
                                  controller: dateController,
                                  style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500),
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
                      context
                          .read<TodoListDatabase>()
                          .updateTodoList(Plan.id, text, category, due);
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
            ));
  }

  void closeSearch() {
    readTodoLists();
    setState(() {
      isSearch = false;
      isOfLength = false;
    });
    _animationController.reverse();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          // print('Speech recognition status: $status');
          if (status == 'listening') {
            setState(() {
              _isListening = true;
              hint = 'Listening...';
            });
          } else {
            setState(() {
              _isListening = false;
              hint = 'Task description';
            });
          }
        },
        onError: (errorNotification) {
          // print('Speech recognition error: $errorNotification');
          setState(() {
            _isListening = false;
            _speech.stop();
            hint = 'Task description';
          });
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
          hint = 'Listening...';
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              hint = 'Task description';
              textController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
        hint = 'Task description';
        textController.text = '';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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

  // Read
  Future<void> readTodoLists() async {
    context.read<TodoListDatabase>().fetchUntrashedTodoList();
    context.read<TodoListDatabase>().fetchPreferences();
  }

  void getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      clipboard = data!.text!;
    });
  }

  void initClipboard() {
    getClipBoardData();
    Future.delayed(const Duration(seconds: 3), () {
      if (requestedClipboard == false) {
        // Prevent pasting in similar plans
        for (var list in nonTrashedTodolistsState) {
          if (list.plan == clipboard) {
            preState = true;
          }
        }
        setState(() {
          requestedClipboard = preState;
        });
        if ((context
              .read<TodoListDatabase>()
              .preferences
              .first
              .accessClipboard ==
                true) &&
            (requestedClipboard == false)) {
          fetchClipboard(context, nonTrashedTodolistsState);
        }
      }
    });
  }

  Future<void> fetchClipboard(context, nonTrashedTodolists) async {
    if (clipboard != '') {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(days: 1),
          content: Text(clipboard.characters.take(100).string,
              style: const TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
          action: SnackBarAction(
              label: 'ADD',
              onPressed: () {
                createTodoList(clipboard, context);
              }),
          showCloseIcon: true,
        ),
      );
      setState(() {
        requestedClipboard = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List nonTrashedTodolists = context.watch<TodoListDatabase>().nonTrashedTodolists;
    setState(() {
      nonTrashedTodolistsState = nonTrashedTodolists;
    });

    initClipboard();

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: isSearch
              ? searchTextField()
              : const SizedBox(),
          centerTitle: true,
          actions: [
            !isSearch ? Tooltip(
              message: "Add a Date",
              child: IconButton(
                onPressed: () { 
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  actionSelectDate(context, selectedDate);
                },
                icon: const Icon(Icons.calendar_month_outlined),
                ),
            ) : const SizedBox(),
            !isSearch ? Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    showPopover(
                      shadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10)],
                      arrowHeight: 0,
                      arrowWidth: 0,
                      contentDxOffset: -80,
                      width: 110,
                      height: 100,
                      direction: PopoverDirection.bottom,
                      context: context,
                      bodyBuilder: (context) => TodoActions(
                        isSearch: () {
                          setState(() {
                            isSearch = true;
                          });
                        },
                        category: selectedCategory,
                        nonTrashedTodolists: nonTrashedTodolists
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert)
                );
              }
            ) : const SizedBox(),
          ],
        ),
        drawer: const TodoListDrawer(),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Todo List",
                    style: TextStyle(
                      fontFamily: "DM serif Display",fontWeight: FontWeight.w500,
                      fontSize: 30
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.bookmark_added_rounded),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                Todo(
                  list: nonTrashedTodolists,
                  category: 'All'
                ),
                Todo(
                  list: nonTrashedTodolists,
                  category: 'Personal'
                ),
                Todo(
                  list: nonTrashedTodolists,
                  category: 'Work'
                ),
                Todo(
                  list: nonTrashedTodolists,
                  category: 'Study'
                ),
                Todo(
                  list: nonTrashedTodolists,
                  category: 'Shopping'
                ),
                Todo(
                  list: nonTrashedTodolists,
                  category: 'Sport'
                ),
              ]),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            nonTrashedTodolists.isNotEmpty && !isSearch && (count > 0)
                ? Tooltip(
                    message: "Move plans to trash",
                    child: FloatingActionButton(
                      onPressed: trashAllTodoLists,
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      child: const Icon(Icons.delete_sweep_outlined),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 8),
            Tooltip(
              message: "Add a plan",
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: isSearch ? 0.25 : 0.0)
                    .animate(_animationController),
                child: FloatingActionButton(
                  onPressed: () {
                    if (isSearch == true) {
                      closeSearch();
                    } else {
                      createTodoList('', context);
                    }
                  },
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  child: Transform.rotate(
                    angle: isSearch
                        ? 45 * (3.141592653589793238 / 180)
                        : 0.0, // Rotate 45 degrees if isSearch is true
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ],
        ),
        persistentFooterButtons: [
          TabBar(
            // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            indicatorWeight: 1,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (value) {
              switch (value) {
                case 0:
                  setState(() {
                    selectedCategory = 'Personal';
                    count = nonTrashedTodolists.length;
                  });
                  break;
                case 1:
                  setState(() {
                    selectedCategory = 'Personal';
                    count = nonTrashedTodolists
                        .where((e) => e.category == selectedCategory)
                        .length;
                  });
                  break;
                case 2:
                  setState(() {
                    selectedCategory = 'Work';
                    count = nonTrashedTodolists
                        .where((e) => e.category == selectedCategory)
                        .length;
                  });
                  break;
                case 3:
                  setState(() {
                    selectedCategory = 'Study';
                    count = nonTrashedTodolists
                        .where((e) => e.category == selectedCategory)
                        .length;
                  });
                  break;
                case 4:
                  setState(() {
                    selectedCategory = 'Shopping';
                    count = nonTrashedTodolists
                        .where((e) => e.category == selectedCategory)
                        .length;
                  });
                  break;
                case 5:
                  setState(() {
                    selectedCategory = 'Sport';
                    count = nonTrashedTodolists
                        .where((e) => e.category == selectedCategory)
                        .length;
                  });
                  break;
                default:
              }
            },
            tabs: const [
              Tooltip(
                message: 'All',
                child: Tab(
                  icon: Icon(Icons.home_outlined),
                ),
              ),
              Tooltip(
                message: 'Personal',
                child: Tab(
                  icon: Icon(Icons.person_2_outlined),
                ),
              ),
              Tooltip(
                message: 'Work',
                child: Tab(
                  icon: Icon(Icons.work_outline_rounded),
                ),
              ),
              Tooltip(
                message: 'Study',
                child: Tab(
                  icon: Icon(Icons.book_outlined),
                ),
              ),
              Tooltip(
                message: 'Shopping',
                child: Tab(
                  icon: Icon(Icons.shopping_basket_outlined),
                ),
              ),
              Tooltip(
                message: 'Sport',
                child: Tab(
                  icon: Icon(Icons.sports_soccer_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
