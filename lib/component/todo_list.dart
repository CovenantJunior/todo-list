import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:todo_list/component/todo_list_options.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:vibration/vibration.dart';

class Todo extends StatefulWidget {

  final String category;
  const Todo({
    super.key,
    required this.category
  });

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  late SpeechToText _speech;
  Future<bool?> hasVibrate = Vibration.hasVibrator();
  bool requestedClipboard = false;
  
  @override
  void initState() {
    super.initState();
    readTodoLists();
    _speech = SpeechToText();
  }

  TextEditingController textController = TextEditingController();
  String hint = 'Task description';
  TextEditingController dateController = TextEditingController();
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Personal';
  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];
  List nonTrashedTodolistsState = [];
  List preference = [];
  List cardToRemove = [];
  bool _isListening = false;
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

  // Create
  void createTodoList(String data, context) {
    if (data != '') {
      textController.text = data;
    }
    dateController.text = date;
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
                      selectedCategory = 'Personal';
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
                      Navigator.pop(context);
                      int? id;
                      switch (selectedCategory) {
                        case 'Personal':
                          id = 1;
                          break;
                        case 'Work':
                          id = 2;
                          break;
                        case 'Study':
                          id = 3;
                          break;
                        case 'Shopping':
                          id = 4;
                          break;
                        case 'Wishlist':
                          id = 5;
                          break;
                        default:
                          id = 0; // Default to the first tab if the category is not recognized
                          break;
                      }
                      DefaultTabController.of(context).animateTo(id);
                      setState(() {
                        selectedDate = DateTime.now();
                        selectedCategory = 'Personal';
                      });
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
                      NotificationService().showNotification(
                          id: nonTrashedTodolistsState.first.id + 1,
                          title: "New Plan Recorded",
                          body: text,
                          payload: "Due by $due");
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

  @override
  Widget build(BuildContext context) {
    List nonTrashedTodolists =
        context.watch<TodoListDatabase>().nonTrashedTodolists;
    setState(() {
      nonTrashedTodolistsState = nonTrashedTodolists;
    });

    int? count;

    if (widget.category != 'All') {
      count = nonTrashedTodolists.where((e) => e.category == widget.category).length;
    } else {
      count = nonTrashedTodolists.length;
    }


    void deleteAction(id) {
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

    /* void deleteAllAction(nonTrashedTodolistsState) {
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
 */
    // Swipe Trash
    void swiptTrashTodoList(int id) {
      context.read<TodoListDatabase>().preferences.first.vibration == true
          ? Vibration.vibrate(duration: 50)
          : Void;
      context.read<TodoListDatabase>().preferences.first.autoDeleteOnDismiss ==
              false
          ? showDialog(
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
                          deleteAction(id);
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
                  ))
          : deleteAction(id);
    }

    /* void trashAllTodoLists() {
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
 */
    Orientation orientation = MediaQuery.of(context).orientation;
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double leftPadding = 0;
    double topHeight = 0;
    // Calculate the padding based on the screen width
    if (orientation == Orientation.portrait) {
      leftPadding = screenWidth * 0.6;
      topHeight = 200;
    } else {
      leftPadding = screenWidth * 0.75;
      topHeight = 20;
    }
    Widget pattern = SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: topHeight),
              const Center(
                  child: Text(
                "Click the + icon below to add a plan",
                style: TextStyle(fontFamily: "Quicksand"),
              )),
              const SizedBox(height: 10),
              const Center(
                  child: Text(
                "Double tap on plan to deactivate or flag completed",
                style: TextStyle(fontFamily: "Quicksand"),
              )),
              const SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.only(left: leftPadding),
                child: Transform.rotate(
                    angle: 1.5708,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'images/pointer.gif',
                          width: 100,
                        ),
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
    // If completed, text decoration will be crossed
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

    void planDetails(plan) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Details",
            style: TextStyle(
              fontFamily: "Quicksand", fontWeight: FontWeight.w500,
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
                            fontWeight: FontWeight.w700),
                      ),
                      Text(plan.plan,
                          style: const TextStyle(fontFamily: "Quicksand"))
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
                            fontWeight: FontWeight.w700),
                      ),
                      Text(plan.category,
                          style: const TextStyle(fontFamily: "Quicksand"))
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
                            fontWeight: FontWeight.w700),
                      ),
                      plan.completed == true
                          ? const Text("Proudly executed",
                              style: TextStyle(fontFamily: "Quicksand"))
                          : const Text("Uncompleted",
                              style: TextStyle(fontFamily: "Quicksand"))
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
                            fontWeight: FontWeight.w700),
                      ),
                      plan.starred == true
                          ? const Text("Starred",
                              style: TextStyle(fontFamily: "Quicksand"))
                          : const Text("Not starred",
                              style: TextStyle(fontFamily: "Quicksand"))
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
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                          DateFormat('EEE, MMM d yyyy HH:mm:ss')
                              .format(plan.created),
                          style: const TextStyle(fontFamily: "Quicksand"))
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
                            fontWeight: FontWeight.w700),
                      ),
                      plan.due != null
                          ? Text(
                              DateFormat('EEE, MMM d yyyy HH:mm:ss')
                                  .format(plan.due),
                              style: const TextStyle(fontFamily: "Quicksand"))
                          : const Text('Unset',
                              style: TextStyle(fontFamily: "Quicksand"))
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
                            fontWeight: FontWeight.w700),
                      ),
                      plan.modified != null
                          ? Text(
                              DateFormat('EEE, MMM d yyyy HH:mm:ss')
                                  .format(plan.modified),
                              style: const TextStyle(fontFamily: "Quicksand"))
                          : const Text('Not yet modified',
                              style: TextStyle(fontFamily: "Quicksand")),
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
                            fontWeight: FontWeight.w700),
                      ),
                      plan.achieved != null
                          ? Text(
                              DateFormat('EEE, MMM d yyyy HH:mm:ss')
                                  .format(plan.achieved),
                              style: const TextStyle(fontFamily: "Quicksand"))
                          : const Text('Not yet achieved',
                              style: TextStyle(fontFamily: "Quicksand")),
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  editTodoList(plan.id, plan);
                },
                icon: const Icon(Icons.edit))
          ],
        ),
      );
    }

    void mark(plan) {
      if (plan.completed == true) {
        context.read<TodoListDatabase>().replan(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Plan reactivated!',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500))));
      } else {
        context.read<TodoListDatabase>().completed(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Plan accomplished. You inspire!!!',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500))));
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          isSearch = false;
          isOfLength = false;
        });
        readTodoLists();
      },
      child: Scaffold(
        body: count > 0
            ? LiquidPullToRefresh(
                springAnimationDurationInMilliseconds: 200,
                onRefresh: () async {
                  readTodoLists();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: nonTrashedTodolists.length,
                      itemBuilder: (context, index) {
                        final plan = nonTrashedTodolists[index];
                        return plan.category == widget.category || widget.category == 'All' ? GestureDetector(
                          onDoubleTap: () {
                            mark(plan);
                          },
                          child: Builder(builder: (context) {
                            return GestureDetector(
                              onLongPress: () {
                                showPopover(
                                    direction: PopoverDirection.top,
                                    width: 290,
                                    context: context,
                                    bodyBuilder: (context) => TodoListOptions(
                                          id: plan.id,
                                          plan: plan.plan,
                                          Plan: plan,
                                          deleteAction: deleteAction,
                                        ));
                              },
                              onTap: () {
                                planDetails(plan);
                              },
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(Icons.delete,
                                                color: Colors.white),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(Icons.delete,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: Text(
                                                    plan.plan,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: "Quicksand",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      // fontSize: 16,
                                                      decoration: decorate(
                                                          plan.completed),
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
                                              plan.starred == true
                                                  ? const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Icon(
                                                          Icons.star_rounded,
                                                          color: Colors
                                                              .orangeAccent),
                                                    )
                                                  : const SizedBox()
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
                                  ), */
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ) : const SizedBox();
                      }),
                ),
              )
            : !isSearch
                ? pattern
                : const Center(child: Text("No result")),
        ),
    );
  }
}