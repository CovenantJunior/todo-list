import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
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

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();
    readTodoLists();
  }

  // Access user input
  final textController = TextEditingController();

  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];

  // Create
  void createTodoList() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Add a plan",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold
          ),
        ),
        content: TextField(
          autocorrect: true,
          autofocus: true,
          maxLines: 1,
          maxLength: 35,
          controller: textController,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.undo_rounded
            )
          ),
          IconButton(
            icon: const Icon(Icons.save),
            // color: Colors.blueGrey,
            onPressed: () {
              String text = textController.text;
              if (text.isNotEmpty) {
                context.read<TodoListDatabase>().addTodoList(text);
                Navigator.pop(context);
                textController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                    'Plan saved',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                    'Oops, blank shot!',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
              }
            }
          )
        ],
      )
    );
  }

  // Read
  Future<void> readTodoLists() async {
    context.read<TodoListDatabase>().fetchTodoList();
  }

  @override
  Widget build(BuildContext context) {
    List todolists = context.watch<TodoListDatabase>().todolists;
    
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
        for (var plans in todolists) {
          if (plans.plan.toLowerCase().contains(q.toLowerCase())) {
            searchResults.add(todolists);
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

    void multiEdit(List todolists) {
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
              items: todolists.map((e) => MultiSelectItem(e, e.plan)).toList(),
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
              message: "Delete selected plan(s)",
              child: IconButton(
                icon: const Icon(Icons.delete),
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
    }

    void planDetails(plan) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Details",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold
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
                        fontFamily: "Quicksan",
                        fontSize: 20
                      ),
                    ),
                    Text(plan.plan)
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(
                        fontFamily: "Quicksan",
                        fontSize: 20
                      ),
                    ),
                    if(plan.completed == true)
                      const Text("You rock. this plan was proudly executed")
                    else
                      const Text("We still have to get this plan done")
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Date Created",
                      style: TextStyle(
                        fontFamily: "Quicksan",
                        fontSize: 20
                      ),
                    ),
                    Text(DateFormat('EEE, MMM d yyyy HH:mm:ss').format(plan.created))
                  ],
                ),
                const SizedBox(height: 20),
                if (plan.modified != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date Modified",
                        style: TextStyle(
                          fontFamily: "Quicksan",
                          fontSize: 20
                        ),
                      ),
                      Text(DateFormat('EEE, MMM d yyyy HH:mm:ss').format(plan.modified))
                    ],
                  ),
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
            if(!isSearch)
              Tooltip(
                message: "Bulk Edit Plans",
                child: IconButton(
                  onPressed: () {
                    multiEdit(todolists);
                  },
                  icon: const Icon(
                    Icons.edit
                  )
                ),
              ),
            if(!isSearch)
              Tooltip(
                message: "Search Plans",
                child: IconButton(
                  onPressed: search, 
                  icon: const Icon(
                    Icons.search
                  )
                ),
              )
          ],
        ),
      
        drawer: const TodoListDrawer(),
      
        body: todolists.isNotEmpty  ? LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 200,
          onRefresh: () async {
            readTodoLists();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: todolists.length,
              itemBuilder: (context, index) {
              final plan = todolists[index];
              return GestureDetector(
                onDoubleTap: () {
                  mark(plan);
                },
                child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onLongPress: () {
                        showPopover(
                          width: 250,
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                plan.plan,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  decoration: decorate(plan.completed),
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
        ) : SingleChildScrollView(
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
        ),
      
        floatingActionButton: Tooltip(
          message: "Add a Plan",
          child: FloatingActionButton(
            onPressed: createTodoList,
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            child: const Icon(
              Icons.add,
              // color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}