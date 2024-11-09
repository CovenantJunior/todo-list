// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:todo_list/component/todo_actions.dart';
import 'package:todo_list/component/todo_list_drawer.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:todo_list/services/audio_service.dart';
import 'package:todo_list/services/backup_service.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:todo_list/services/sync_service.dart';
import 'package:todo_list/shell.dart';
import 'package:vibration/vibration.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with SingleTickerProviderStateMixin {
  
  Future<void> requestPermissions() async {
    // Request the necessary permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothConnect,
      Permission.calendarFullAccess,
      Permission.ignoreBatteryOptimizations,
      Permission.microphone,
      Permission.notification,
      Permission.speech,
      Permission.scheduleExactAlarm,
      // Add other permissions you need here
    ].request();

    // Check if all permissions are granted
    if (statuses.containsValue(PermissionStatus.denied)) {
      Fluttertoast.showToast(
        msg: "App may malfunctoin without granted permissions",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1
      );
    }
  }

  
  late SpeechToText _speech;
  Future<bool?> hasVibrate = Vibration.hasVibrator();
  String clipboard = '';
  bool requestedClipboard = false;
  bool preState = false;
  int count = 0;
  bool animate = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
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
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)));
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedCategory = 'Personal';
  String interval = 'Every Minute';
  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];
  List nonTrashedTodolists = [];
  List nonTrashedTodolistsState = [];
  List preference = [];
  List cardToRemove = [];
  bool _isListening = false;
  bool backingUp = false;
  
  Widget searchTextField() {
    //add
    return TextField(
      controller: textController,
      autofocus: true,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Search Plans / $selectedCategory',
        labelStyle: const TextStyle(fontFamily: "Quicksand")
      ),
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

      // Create
  void createTodoList(String data, BuildContext context) {
    if (data != '') {
      textController.text = data;
    }
    dateController.text == '' ? dateController.text = date : dateController.text= dateController.text;
    selectedCategory == 'All' ? selectedCategory = 'Personal' : selectedCategory = selectedCategory;
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
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
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
                          suffixIcon: context.watch<TodoListDatabase>().preferences.first.stt == true
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
                          child: TextFormField(
                            onTap: () {
                              _selectDate(context);
                            },
                            controller: dateController,
                            style: const TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500
                            ),
                            readOnly: true, // Make the TextFormField read-only
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
                            labelText: 'Reminder Interval',
                            labelStyle: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none),
                        child: DropdownButtonFormField<String>(
                          value: interval,
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
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
              setState(() {
                selectedDate = DateTime.now().add(const Duration(days: 1));
                requestedClipboard = true;
              });
            },
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            onPressed: () async {
              setState(() {
                animate = true;
              });
              Future.delayed(const Duration(milliseconds: 300), () {
                setState(() {
                  animate = false;
                });
              });
              AudioService().play('pings/start.mp3');
              String text = textController.text.trim();
              String due = dateController.text;
              String category = selectedCategory;
              String intvl = interval;
              if (text.isNotEmpty) {
                context.read<TodoListDatabase>().addTodoList(text, category, due, intvl);
                setState(() {
                  selectedDate = DateTime.now().add(const Duration(days: 1));
                });
                Navigator.pop(context);
                textController.clear();
                if (context.read<TodoListDatabase>().preferences.first.notification == true) {
                  /* NotificationService().showNotification(
                    id: nonTrashedTodolistsState.isNotEmpty ? nonTrashedTodolistsState.first.id + 1 : 0,
                    title: "New Plan Recorded",
                    body: text,
                    payload: "Due by $due"
                  ); */
                  NotificationService().scheduleNotification(
                    id: context.read<TodoListDatabase>().todolists.isNotEmpty ? context.read<TodoListDatabase>().todolists.last.id + 1 : 1,
                    title: "Reminder",
                    body: "TODO: $text",
                    interval: intvl,
                    payload: jsonEncode({
                      'scheduledDate': DateTime.now().toIso8601String(),
                      'interval': intvl,
                    }),
                  );
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                if (context.read<TodoListDatabase>().preferences.first.vibration) Vibration.vibrate(duration: 50);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
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
      ));
  }

  // ignore: non_constant_identifier_names
  void editTodoList(int id, Plan) {
    Navigator.pop(context);
    textController.text = Plan.plan;
    dateController.text = Plan.due != null ? DateFormat('yyyy-MM-dd').format(Plan.due) : date;
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
                                    fontWeight: FontWeight.w500
                                  ),
                                  readOnly: true, // Make the TextFormField read-only
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
                      context
                          .read<TodoListDatabase>()
                          .updateTodoList(Plan.id, text, category, due, interval);
                      Navigator.pop(context);
                      textController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
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
                      if (context.read<TodoListDatabase>().preferences.first.vibration) Vibration.vibrate(duration: 50);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
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
              hint = 'Listening';
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
          hint = 'Listening';
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
    context.read<TodoListDatabase>().fetchTrashedTodoList();
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
        if ((requestedClipboard == false)) {
          fetchClipboard(context, nonTrashedTodolistsState);
        }
      }
    });
  }

  Future<void> fetchClipboard(context, nonTrashedTodolists) async {
    if (clipboard != '') {
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
    List trashedTodolists = context.read<TodoListDatabase>().trashedTodoLists;

    for (var plan in trashedTodolists) {
      // Get the current time
      DateTime currentTime = DateTime.now();
      // Calculate the difference between current time and database time
      Duration difference = currentTime.difference(plan.trashedDate);
      if (difference.inDays >= 30) {
        context.read<TodoListDatabase>().deleteTodoList(plan.id);
      }
    }

    setState(() {
      nonTrashedTodolistsState = nonTrashedTodolists;
      count = nonTrashedTodolists.length;
    });

    if(context.read<TodoListDatabase>().preferences.first.accessClipboard == true) {
      initClipboard();
    }

    /* Timer.periodic(const Duration(seconds: 7), (timer) {
      NotificationService().cancelNotification(144000);
      setState(() {
        readTodoLists();
      });
    });
     */

    context.read<TodoListDatabase>().fetchUser();
    List user = context.watch<TodoListDatabase>().user;

    if (context.read<TodoListDatabase>().preferences.first.backup == true && context.read<TodoListDatabase>().preferences.first.autoSync == true && user.isNotEmpty) {
      Timer.periodic(const Duration(minutes: 10), (timer) {
        setState(() {
          backingUp = true;
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7)
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.fixed,
            content: const Text('Synchronizing your data',
              style: TextStyle(
                fontFamily: "Quicksand", fontWeight: FontWeight.w500
              )
            ),
          ),
        );
        Sync().sync(context, backup: () {
          setState(() {
            backingUp = false;
          });
        });
      });
    } else {
      // Do nothing
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          isSearch = false;
          isOfLength = false;
        });
      },
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: isSearch
                ? searchTextField()
                : const SizedBox(),
            centerTitle: true,
            actions: [
              !isSearch && context.watch<TodoListDatabase>().preferences.first.backup == true ? Tooltip(
                message: "Backup Tasks and Preferences",
                child: IconButton(
                  onPressed: () { 
                    setState(() {
                      backingUp = true;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)
                        ),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.fixed,
                        content: const Text('Backing up',
                          style: TextStyle(
                            fontFamily: "Quicksand", fontWeight: FontWeight.w500
                          )
                        ),
                      ),
                    );
                    Backup().backup(context, backup: () {
                      setState(() {
                        backingUp = false;
                      });
                    });
                  },
                  icon: backingUp == false ? const Icon(Icons.backup_outlined) : const Icon(Icons.backup_rounded),
                  ),
              ) : const SizedBox(),
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
                  return Tooltip(
                    message: "More Options",
                    child: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        showPopover(
                          shadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10)],
                          arrowHeight: 0,
                          arrowWidth: 0,
                          contentDxOffset: -100,
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
                            nonTrashedTodolists: nonTrashedTodolists,
                          ),
                        );
                      },
                      icon: const Icon(Icons.more_vert)
                    ),
                  );
                }
              ) : const SizedBox(),
            ],
          ),
          drawer: const TodoListDrawer(),
          body: GestureDetector(
            onTap: () {
              setState(() {
                isSearch = false;
                isOfLength = false;
              });
            },
            child: Shell(
              index: 0,
              nonTrashedTodolists: nonTrashedTodolists,
              cardToRemove: cardToRemove,
              animate: animate,
              isSearch: isSearch,
              isOfLength: isOfLength,
              selectedCategory: selectedCategory,
              closeSearch: () {
                setState(() {
                  isSearch = false;
                  isOfLength = false;
                });
              },            
            ),
          ),
        ),
      ),
    );
  }
}
