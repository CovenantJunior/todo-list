import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:todo_list/component/todo_list_options.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/services/audio_service.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:vibration/vibration.dart';

class Todo extends StatefulWidget {

  final List list;
  final String category;
  final List cardToRemove;

  const Todo({
    super.key,
    required this.list,
    required this.category,
    required this.cardToRemove
  });

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  late final ConfettiController _completedController = ConfettiController();

  String interval = 'Every Minute';
  Future<bool?> hasVibrate = Vibration.hasVibrator();
  bool requestedClipboard = false;
  
  @override
  void initState() {
    super.initState();
    readTodoLists();
  }

  @override
  void dispose() {
    _completedController.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
  

  TextEditingController textController = TextEditingController();
  String hint = 'Task description';
  TextEditingController dateController = TextEditingController();
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedCategory = 'Personal';
  bool isSearch = false;
  bool isOfLength = false;
  List nonTrashedTodolistsState = [];
  List preference = [];
  List cardToRemove = [];
  Future<void> selectDate(BuildContext context, due) async {
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
                                child: TextFormField(
                                  onTap: () {
                                    selectDate(context, Plan.due);
                                  },
                                  controller: dateController,
                                  style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w500),
                                  readOnly:
                                      true, // Make the TextFormField read-only
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
                      if (Plan.completed == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)
                            ),
                            duration: const Duration(seconds: 1),
                            content: const Text(
                              'Plan is already completed',
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        context.read<TodoListDatabase>().updateTodoList(Plan.id, text, category, due, interval);
                        if ((Plan.interval != interval) || (Plan.plan != text)) {
                          NotificationService().cancelNotification(Plan.id);
                          NotificationService().scheduleNotification(
                            id: Plan.id,
                            title: "Reminder",
                            body: "TODO: $text",
                            interval: Plan.interval,
                            payload: jsonEncode({
                              'scheduledDate': DateTime.now().toIso8601String(),
                              'interval': Plan.interval
                            }),
                          );
                        } else {
                        }
                        Navigator.pop(context);
                        textController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)
                            ),
                            duration: const Duration(seconds: 1),
                            content: const Text(
                              'Plan saved',
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      context.watch<TodoListDatabase>().preferences.first.vibration == true
                          ? Vibration.vibrate(duration: 50)
                          : Void;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          duration: const Duration(seconds: 1),
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
            ));
  }

  void closeSearch() {
    readTodoLists();
    setState(() {
      isSearch = false;
      isOfLength = false;
    });
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
          NotificationService().cancelNotification(id);
          context.read<TodoListDatabase>().completed(id);
          context.read<TodoListDatabase>().trashTodoList(id);
          Future.delayed(const Duration(seconds: 4), () {
            cardToRemove.clear();
          });
          setState(() {
            undo = true;
          });
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
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
      topHeight = 150;
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
                          'assets/images/pointer.gif',
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
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reminder Interval",
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            // fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      plan.interval != null
                          ? Text(
                              "${plan.interval}",
                              style: const TextStyle(fontFamily: "Quicksand"))
                          : const Text('Not yet set',
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
            duration: const Duration(seconds: 1),
            content: const Text('Plan reactivated!',
                style: TextStyle(
                    fontFamily: "Quicksand", fontWeight: FontWeight.w500))));
        NotificationService().scheduleNotification(
          id: plan.id,
          title: "Reminder",
          body: "TODO: ${plan.plan}",
          interval: plan.interval,
          payload: jsonEncode({
            'scheduledDate': DateTime.now().toIso8601String(),
            'interval': plan.interval,
            'plan': plan.plan
          }),
        );
      } else {
        NotificationService().cancelNotification(plan.id);
        AudioService().play('pings/completed.mp3');
        context.read<TodoListDatabase>().completed(plan.id);
        _completedController.play();
        Future.delayed(const Duration(seconds: 5), () {
          _completedController.stop();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
            duration: const Duration(seconds: 1),
            content: const Text('Plan accomplished. You inspire!',
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
                springAnimationDurationInMilliseconds: 100,
                onRefresh: () async {
                  readTodoLists();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      ListView.builder(
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
                                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                  showPopover(
                                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                                    shadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10)],
                                    width: 290,
                                    height: 50,
                                    context: context,
                                    bodyBuilder: (context) => TodoListOptions(
                                          id: plan.id,
                                          plan: plan.plan,
                                          Plan: plan,
                                          deleteAction: deleteAction,
                                          completedController: _completedController
                                        ));
                                },
                                child: Visibility(
                                  visible: !widget.cardToRemove.contains(plan.id) && !cardToRemove.contains(plan.id),
                                  child: index != 0 ? Card(
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
                                      child: Row(
                                        children: [
                                          Checkbox(value: plan.completed != true ? false : true,
                                            onChanged: (value){
                                              mark(plan);
                                            }
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                planDetails(plan);
                                              },
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
                                                            height: 20,
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
                                        ],
                                      ),
                                    ),
                                  ) : Card(
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
                                      child: Row(
                                        children: [
                                          Checkbox(value: plan.completed != true ? false : true,
                                            onChanged: (value){
                                              mark(plan);
                                            }
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                planDetails(plan);
                                              },
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
                                                            height: 20,
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
                                        ],
                                      ),
                                    ),
                                  ).animate()
                                    .fadeIn() // uses `Animate.defaultDuration`
                                    .scale() // inherits duration from fadeIn
                                    .moveX(delay: 1000.ms, duration: 1000.ms),
                                ),
                              );
                            }) // runs after the above w/new duration,
                          ) : const SizedBox();
                        }
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: _completedController,
                          blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
                          shouldLoop: false,
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.pink,
                            Colors.orange,
                            Colors.purple
                          ], // manually specify the colors to be used
                          createParticlePath:
                              drawStar, // define a custom shape/path.
                        ),
                      ),
                    ]
                  ),
                ),
              )
            : !isSearch
                ? pattern
                : const Center(child: Text("No result")),
        ),
    );
  }
}