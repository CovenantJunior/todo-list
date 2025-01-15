// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:todo_list/component/todo_actions.dart';
import 'package:todo_list/component/todo_list.dart';
import 'package:todo_list/component/todo_list_drawer.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:todo_list/services/ads/interstitial.dart';
import 'package:todo_list/services/audio_service.dart';
import 'package:todo_list/services/auth_service.dart';
// import 'package:todo_list/services/backup_service.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:todo_list/shell.dart';
import 'package:vibration/vibration.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with TickerProviderStateMixin {
  
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
  Timer? _timer;
  double _spin = 0.0;


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
  List cardToRemove = [];
  bool _isListening = false;

  final FocusNode _focusNode = FocusNode();

  
  Widget searchTextField() {
    //add
    return FocusScope(
      child: TextField(
        controller: textController,
        autofocus: true,
        autocorrect: true,
        enableSuggestions: true,
        decoration: InputDecoration(
          labelText: 'Search Plans / $selectedCategory',
          labelStyle: const TextStyle(fontFamily: "Quicksand")
        ),
        onChanged: (value) {
          var q = textController.text;
          if (q.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isOfLength = true;
                searchResults = [];
              });
            });
            context.read<TodoListDatabase>().search(q.toLowerCase());
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isOfLength = false;
                searchResults = [];
              });
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
        }
      ),
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
                          value: selectedCategory == 'All' ? 'Personal' : selectedCategory,
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
              AudioService().play('pings/start.mp3');
              setState(() {
                animate = true;
              });
              Future.delayed(const Duration(milliseconds: 300), () {
                setState(() {
                  animate = false;
                });
              });
              String text = textController.text.trim();
              String due = dateController.text;
              String category = selectedCategory == 'All' ? 'Personal' : selectedCategory;
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      InterstitialAds().loadInterstitialAd(context);
    });
  }

  void startSpin() {
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        _spin = (_spin + 0.1) % 360;
      });
    });
  }


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
    _startTimer();
    startSpin();
  }

  @override
  void dispose() {
    _animationController.dispose(); 
    super.dispose();
    _timer?.cancel();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    if (isSearch) {
      switch (selectedCategory) {
        case 'Personal':
          index = 1;
          break;
        case 'Work':
          index = 2;
          break;
        case 'Study':
          index = 3;
          break;
        case 'Shopping':
          index = 4;
          break;
        case 'Sport':
          index = 5;
          break;
        default:
          index = 0;
          break; // default to 'All'
      }
    }

    List nonTrashedTodolists = context.watch<TodoListDatabase>().nonTrashedTodolists;
    List trashedTodolists = context.watch<TodoListDatabase>().trashedTodoLists;
    List todoLists = context.watch<TodoListDatabase>().todolists;
    bool needBackup = context.watch<TodoListDatabase>().needBackup;
    bool backingUp = context.watch<TodoListDatabase>().backingUp;

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


    return GestureDetector(
      onTap: () {
        setState(() {
          isSearch = false;
          isOfLength = false;
        });
      },
      child: Scaffold(
        backgroundColor: context.watch<TodoListDatabase>().isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: isSearch
            ? searchTextField()
            : const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Todo List",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w800,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.task_alt_rounded, weight: 100),
                ],
              ),
          centerTitle: true,
          actions: [
            !isSearch && context.watch<TodoListDatabase>().preferences.first.backup == true ? Tooltip(
              message: "Backup Tasks and Preferences",
              child: IconButton(
                onPressed: () async { 
                  if (backingUp == false && user.isNotEmpty && user.first.googleUserId != '' && needBackup == false) {
                    return;
                  }
                  if (await InternetConnectionChecker().hasConnection == true) {
                    context.read<TodoListDatabase>().setbackingUp(true);
                    AuthService().signInWithGoogleAndBackup(context, todoLists, context.read<TodoListDatabase>().preferences.first, backup: () {
                      context.read<TodoListDatabase>().setbackingUp(false);
                      context.read<TodoListDatabase>().setNeedBackup(false);
                    });
                  } else {
                    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      duration: const Duration(seconds: 5),
                      content: const Row(children: [
                        Icon(Icons.error_outline_rounded, color: Colors.red),
                        SizedBox(width: 10),
                        Text('No internet connection',
                            style: TextStyle(
                                fontFamily: "Quicksand", fontWeight: FontWeight.w500)),
                      ]),
                    ));
                  }
                },
                icon: (backingUp == false && user.isNotEmpty && user.first.googleUserId != '' && needBackup == false) ?
                  const Icon(Icons.check_circle_outline, color: Colors.green) :
                    Transform.rotate(
                      angle: backingUp ? _spin : 0.0,
                      child: const Icon(Icons.sync_rounded)
                    ),
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
                              textController.clear();
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
        body: !isSearch ? Stack(
          children: [
            ClipRRect(
              child: Shell(
                index: index,
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
                toggle: (c) {
                  setState(() {
                    selectedCategory = c == 'All' ? 'Personal' : c;
                  });
                }
              ),
            ),
            if(backingUp)
            const LinearProgressIndicator()
          ],
        ) : Todo(
              list: nonTrashedTodolists,
              category: selectedCategory,
              cardToRemove: cardToRemove,
              animate: animate,
              isSearch: isSearch,
              isOfLength: isOfLength,
              selectedCategory: selectedCategory,
              closeSearch: closeSearch
            ),
      ),
    );
  }
}
