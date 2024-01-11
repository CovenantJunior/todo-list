import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
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
        title: const Text("Add a plan"),
        content: TextField(
          controller: textController,
        ),
        actions: [
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

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "My Plans",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
            SizedBox(width: 3),
            Icon(
              Icons.bookmark_added_rounded,
              // color: Colors.blueGrey,
            ),
          ],
        ),
        centerTitle: true,
      ),

      drawer: const TodoListDrawer(),

      body: todolists.isNotEmpty  ? LiquidPullToRefresh(
        onRefresh: () async {
          readTodoLists();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: todolists.length,
            itemBuilder: (context, index) {
            final plan = todolists[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      plan.plan,
                      overflow: TextOverflow.clip,
                      maxLines: 20,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w600,
                        fontSize: 16
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
            );
          }),
        ),
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              const Center(child: Text(
                  "No plans yet, tap the icon below to add",
                  style: TextStyle(
                    // color: Colors.blueGrey,
                  ),
                )
              ),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.only(left: 230.0),
                child: Transform.rotate(
                  angle: 1.5708,
                  child: Image.asset(
                    'images/pointer.gif',
                    width: 100,
                  )
                ),
              )
            ],
          ),
        ],
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