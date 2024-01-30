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

class TodoStarred extends StatefulWidget {
  const TodoStarred({super.key});

  @override
  State<TodoStarred> createState() => _TodoStarredState();
}

class _TodoStarredState extends State<TodoStarred> {
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
                          'Unstarring ${selectedLists.length} plans',
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
                          'Unstarring plan',
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
          const Text(
            'Starred',
            style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold
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
                          width: 300,
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
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
                                  const Icon(Icons.star_rounded, color: Colors.orangeAccent,)
                                ],
                              ),
                              const SizedBox(height: 25),
                              Row(
                                children: [
                                  const Text(
                                    "Due",
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    DateFormat('EEE, MMM d yyyy').format(plan.due),
                                    style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 10
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  const Text(
                                    "Category",
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    plan.category,
                                    style: const TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 10
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ) : const SizedBox();
                  }
                ),
              );
            }),
          ),
        ) : !isSearch ? const Center(child: Text("No starred plan yet")) : const Center(child: Text("No result")),
      
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