import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:todo_list/component/todo_list_drawer.dart';
import 'package:todo_list/component/todo_list_options.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with SingleTickerProviderStateMixin{
  late SpeechToText _speech;

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
  TextEditingController dateController = TextEditingController();
  late AnimationController _animationController;

  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Personal';

  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];
  List nonTrashedTodolistsState = [];

  bool _isListening = false;

  // Create
  void createTodoList() {
    dateController.text = date;
    showDialog(
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
                const Icon(
                  Icons.list_rounded
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    autocorrect: true,
                    autofocus: true,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 100,
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Task description',
                      suffixIcon: IconButton(
                        onPressed: _listen,
                        icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                      ),
                      hintStyle: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      ),
                      labelStyle: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
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
                        fontWeight: FontWeight.bold
                      ),
                      border: InputBorder.none
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      items: ['Personal', 'Work', 'Study', 'Shopping', 'Sport', 'Wishlist']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                              style: const TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.bold
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
                      _selectDate(context);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                        labelStyle: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
                        ),
                        hintText: 'Select due date',
                        border: InputBorder.none
                      ),
                      child: TextField(
                        readOnly: true,
                        controller: dateController,
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
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
            });
          },
          icon: const Icon(Icons.undo_rounded),
        ),
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            String text = textController.text.trim();
            String due = dateController.text;
            String category = selectedCategory;
            if (text.isNotEmpty) {
              context.read<TodoListDatabase>().addTodoList(text, category, due);
              setState(() {
                selectedDate = DateTime.now();
                selectedCategory = 'Personal';
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
      },
      onError: (errorNotification) {
        // print('Speech recognition error: $errorNotification');
      },
    );
    if (available) {
      setState(() {
        _isListening = true;
        textController = 'Listening...' as TextEditingController;
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            textController = result.recognizedWords as TextEditingController;
          });
        },
      );
    }
  } else {
    setState(() {
      _isListening = false;
      _speech.stop();
    });
  }
}

  void trashAllTodoLists() {
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
              context.read<TodoListDatabase>().trashAllTodoLists(nonTrashedTodolistsState);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
                    'Moved all to Trash',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
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
    context.read<TodoListDatabase>().fetchTodoList();
  }

  @override
  Widget build(BuildContext context) {
    List nonTrashedTodolists = context.watch<TodoListDatabase>().nonTrashedTodolists;
    setState(() {
      nonTrashedTodolistsState = nonTrashedTodolists;
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
            context.read<TodoListDatabase>().search(q.toLowerCase());
          } else {
            setState(() {
              isOfLength = false;
              searchResults = [];
            });
            context.read<TodoListDatabase>().fetchTodoList();
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
              const Center(child: Text(
                  "Click the + icon below to add a plan"
                )
              ),
              const SizedBox(height: 10),
              const Center(child: Text("Double tap on plan to deactivate or flag completed")),
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
                  )
                ),
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

    void multiEdit(List nonTrashedTodolists) {
      List selectedLists = [];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Edit Plans",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold
            ),
          ),
          content: SingleChildScrollView(
            child: MultiSelectDialogField(
              buttonText: const Text(
                "Tap to select plans",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold
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
              items: nonTrashedTodolists.where((e) => e.trashed != true).map((e) => MultiSelectItem(e, e.plan)).toList(),
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
              message: "Reactivate Plan",
              child: IconButton(
                icon: const Icon(
                  Icons.star_rounded,
                ),
                // color: Colors.blueGrey,
                onPressed: () {
                  if (selectedLists.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                      'Please select a plan to deal with',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
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
                          'Starring ${selectedLists.length} plans',
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold
                          )
                        )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                          'Starring plan',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold
                          )
                        )));
                    }
                    Navigator.pop(context);
                  }
                }
              ),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                      'Please select a plan to deal with',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                  } else {
                    for (var selectedList in selectedLists) {
                      context.read<TodoListDatabase>().replan(selectedList.id);
                    }
                    if (selectedLists.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                          'Reactivating ${selectedLists.length} plans',
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold
                          )
                        )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                          'Reactivating plan',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold
                          )
                        )));
                    }
                    Navigator.pop(context);
                  }
                }
              ),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                      'Please select a plan to deal with',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                  } else {
                    for (var selectedList in selectedLists) {
                      context.read<TodoListDatabase>().completed(selectedList.id);
                    }
                    if (selectedLists.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                          'Marking ${selectedLists.length} plans as completed',
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold
                          )
                        )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                          'Marking plan as completed',
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold
                          )
                        )));
                    }
                    Navigator.pop(context);
                  }
                }
              ),
            ),
            Tooltip(
              message: "Trash selected plan(s)",
              child: IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                // color: Colors.blueGrey,
                onPressed: () {
                  if (selectedLists.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                      'Please select a plan to deal with',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                  } else {
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
                              for (var selectedList in selectedLists) {
                                context.read<TodoListDatabase>().trashTodoList(selectedList.id);
                              }
                              if (selectedLists.length > 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    content: Text(
                                    'Deleting ${selectedLists.length} selected plans',
                                    style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.bold
                                    )
                                  )));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                    'Deleting selected plan',
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.bold
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

    void search () {
      setState(() {
        isSearch = !isSearch;
        isOfLength = false;
        searchResults.clear();
      });
      if (_animationController.isDismissed) {
        _animationController.forward();
      }
    }

    void planDetails(plan) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Details",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 25
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
                        fontSize: 15,
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
                        fontSize: 15,
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
                        fontSize: 15,
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
                        fontSize: 15,
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
                        fontSize: 15,
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
                        fontSize: 15,
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
                        fontSize: 15,
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
                        fontSize: 15,
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
          )
        )
      );
    }

    void mark(plan) {
      if (plan.completed == true) {
        context.read<TodoListDatabase>().replan(plan.id);
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
        context.read<TodoListDatabase>().completed(plan.id);
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

    return Scaffold(
      appBar: AppBar(
        title: isSearch ?
        searchTextField() :
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Todo List",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
            SizedBox(width: 3),
            Icon(
              Icons.bookmark_added_rounded
            ),
          ],
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
          !isSearch && nonTrashedTodolists.isNotEmpty ?
            Tooltip(
              message: "Search Plans",
              child: IconButton(
                onPressed: search, 
                icon: const Icon(
                  Icons.search
                )
              ),
            ) : const SizedBox(),
          !isSearch && nonTrashedTodolists.isNotEmpty ?
            Tooltip(
              message: "Bulk Edit Plans",
              child: IconButton(
                onPressed: () {
                  multiEdit(nonTrashedTodolists);
                },
                icon: const Icon(
                  Icons.edit
                )
              ),
            ) : const SizedBox(),
        ],
      ),
    
      drawer: const TodoListDrawer(),
    
      body: nonTrashedTodolists.isNotEmpty ? LiquidPullToRefresh(
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
            return GestureDetector(
              onDoubleTap: () {
                mark(plan);
              },
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onLongPress: () {
                      showPopover(
                        direction: PopoverDirection.top,
                        width: 290,
                        context: context,
                        bodyBuilder: (context) => TodoListOptions(id: plan.id, plan: plan.plan, Plan: plan)
                      );
                    },
                    onTap: () {
                      planDetails(plan);
                    },
                    child: Card(
                      surfaceTintColor: tint(plan.completed),
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
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
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
                                plan.starred == true ? const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.star_rounded, color: Colors.orangeAccent),
                                ) : const SizedBox()
                              ],
                            ),
                            const Divider(height: 25),
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
            );
          }),
        ),
      ) : !isSearch ? pattern : const Center(child: Text("No result")),
    
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          nonTrashedTodolists.isNotEmpty && !isSearch ? Tooltip(
            message: "Move plans to trash",
            child: FloatingActionButton(
              onPressed: trashAllTodoLists,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.delete_sweep_outlined),
            ),
          ) : const SizedBox(),
      
          const SizedBox(height: 8),
      
          Tooltip(
            message: "Add a plan",
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: isSearch ? 0.25 : 0.0).animate(_animationController),
              child: FloatingActionButton(
                onPressed: isSearch ? closeSearch : createTodoList,
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                child: Transform.rotate(
                  angle: isSearch ? 45 * (3.141592653589793238 / 180) : 0.0, // Rotate 45 degrees if isSearch is true
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}