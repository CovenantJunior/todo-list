import 'package:flutter/material.dart';
import 'package:todo_list/component/todo_list_drawer_tile.dart';
import 'package:todo_list/layouts/todo_list_settings.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';

class TodoListDrawer extends StatefulWidget {
  const TodoListDrawer({super.key});

  @override
  State<TodoListDrawer> createState() => _TodoListDrawerState();
}

class _TodoListDrawerState extends State<TodoListDrawer> {
  // Delete All Plans
    void deleteAllTodoLists() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "Delete all plans?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Quicksand',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<TodoListDatabase>().deleteAllTodoLists();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Poof! Gone like the wind',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold
                      )
                    )));
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

  @override
  Widget build(BuildContext context) {
    List todolists = context.watch<TodoListDatabase>().todolists;
    
    return Drawer(
      semanticLabel: "TodoList Drawer Menu",
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(
                'images/note.png',
                width: 70,
              ),
          ),
          TodoListDrawerTile(
            title: "Home",
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            }
          ),

          TodoListDrawerTile(
            title: "Settings",
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoListSettings()));
            }
          ),

          if (todolists.isNotEmpty)
            TodoListDrawerTile(
              title: "Delete all plans",
              leading: const Icon(Icons.delete_forever_rounded),
              onTap: () {
                deleteAllTodoLists();
              },
            ),
        ],
      ),
    );
  }
}