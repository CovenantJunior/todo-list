import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/todo_list_trash_options.dart';
import 'package:todo_list/models/todo_list_database.dart';

class TodoTrash extends StatefulWidget {
  const TodoTrash({super.key});

  @override
  State<TodoTrash> createState() => _TodoTrashState();
}

class _TodoTrashState extends State<TodoTrash> {
  @override
  void initState() {
    super.initState();
    readTodoLists();
  }

  Future<void> readTodoLists() async {
    context.read<TodoListDatabase>().fetchTodoList();
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
                    if (plan.achieved!= null)
                      Text(DateFormat('EEE, MMM d yyyy HH:mm:ss').format(plan.achieved), style: const TextStyle(fontFamily: "Quicksand"))
                    else const Text('Not yet achieved', style: TextStyle(fontFamily: "Quicksand")),
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

  TextEditingController textController = TextEditingController();
  bool isSearch = false;
  bool isOfLength = false;
  List searchResults = [];

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
            'Trash',
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
            if(!isSearch)
              Tooltip(
                message: "Search Plans",
                child: IconButton(
                  onPressed: search, 
                  icon: const Icon(
                    Icons.search
                  )
                ),
              ),
          ],
        ),

        body: todolists.isNotEmpty || isSearch ? LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 200,
          onRefresh: () async {
            readTodoLists();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: todolists.length,
              itemBuilder: (context, index) {
              final plan = todolists[index];
              return Builder(
                builder: (context) {
                  return plan.trashed == true ? GestureDetector(
                    onLongPress: () {
                      showPopover(
                        arrowDxOffset: 100,
                        arrowDyOffset: 100,
                        direction: PopoverDirection.top,
                        width: 100,
                        context: context,
                        bodyBuilder: (context) => TodoListTrashOptions(id: plan.id, plan: plan.plan, Plan: plan)
                      );
                    },
                    onTap: () {
                      planDetails(plan);
                    },
                    child: Card(
                      surfaceTintColor: tint(plan.completed),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                      bodyBuilder: (context) => TodoListTrashOptions(id: plan.id, plan: plan.plan, Plan: plan)
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.more_vert, 
                                    color:Colors.blueGrey
                                  )
                                );
                              }
                            ), */
                            /* TodoListTrashOptions(
                              id: plan.id,
                              plan: plan.plan
                            ) */
                          ],
                        ),
                      ),
                    ),
                  ) : const SizedBox();
                }
              );
            }),
          ),
        ) : const SizedBox()
      ),
    );
  }
}