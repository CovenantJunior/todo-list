import 'package:flutter/material.dart';
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
                  const SnackBar(content: Text(
                    'Plan saved',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
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

  void search(List todolists) {
    List selectedLists = [];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Search Plan",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold
          ),
        ),
        content: SingleChildScrollView(
          child: MultiSelectDialogField(
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
            message: "Mark as incompleted",
            child: IconButton(
              icon: const Icon(
                Icons.unpublished_rounded,
              ),
              // color: Colors.blueGrey,
              onPressed: () {
                print(selectedLists);
                if (selectedLists.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
                    'Please select a plan to deal with',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
                } else {
                  if (selectedLists.length > 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        'Marking as incompleted',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
                        )
                      )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        'Marking as incompleted...',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
                        )
                      )));
                  }
                }
              }
            ),
          ),
          Tooltip(
            message: "Mark as completed",
            child: IconButton(
              icon: const Icon(
                Icons.done_all_rounded,
              ),
              // color: Colors.blueGrey,
              onPressed: () {
                print(selectedLists);
                if (selectedLists.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
                    'Please select a plan to deal with',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
                } else {
                  if (selectedLists.length > 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        'Marking as completed...',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
                        )
                      )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        'Marking as completed...',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
                        )
                      )));
                  }
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
                print(selectedLists);
                if (selectedLists.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(
                    'Please select a plan to deal with',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold
                    )
                  )));
                } else {
                  if (selectedLists.length > 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        'Deleting selected plans...',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
                        )
                      )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        'Deleting selected plan...',
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold
                        )
                      )));
                  }
                }
              }
            ),
          )
        ],
      )
    );
  }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
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
          IconButton(
            onPressed: () {
              search(todolists);
            },
            icon: const Icon(
              Icons.search
            )
          ),
          const IconButton(
            onPressed: null, 
            icon: Icon(
              Icons.sort
            )
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
                if (plan.completed == true) {
                  context.read<TodoListDatabase>().replan(plan.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Plan reset for extra brilliance!',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                } else {
                  context.read<TodoListDatabase>().completed(plan.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Plan accomplished. You inspire!!!',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
                }
              },
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onLongPress: () {
                      showPopover(
                        width: 210,
                        context: context,
                        bodyBuilder: (context) => TodoListOptions(id: plan.id, plan: plan.plan)
                      );
                    },
                    child: Card(
                      surfaceTintColor: tint(plan.completed),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
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
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    showPopover(
                                      width: 270,
                                      context: context,
                                      bodyBuilder: (context) => TodoListOptions(id: plan.id, plan: plan.plan)
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.more_vert, 
                                    color:Colors.blueGrey
                                  )
                                );
                              }
                            ),
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

      floatingActionButton: FloatingActionButton(
        onPressed: createTodoList,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        child: const Icon(
          Icons.add,
          // color: Colors.blueGrey,
        ),
      ),
    );
  }
}