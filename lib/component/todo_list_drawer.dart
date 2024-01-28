import 'package:flutter/material.dart';
import 'package:todo_list/component/todo_list_drawer_tile.dart';
import 'package:todo_list/layouts/todo_list_preferences.dart';
import 'package:todo_list/layouts/todo_list_starred.dart';
import 'package:todo_list/layouts/todo_trash_page.dart';

class TodoListDrawer extends StatefulWidget {
  const TodoListDrawer({super.key});

  @override
  State<TodoListDrawer> createState() => _TodoListDrawerState();
}

class _TodoListDrawerState extends State<TodoListDrawer> {
  // Delete All Plans
    /* void trashAllTodoLists() {
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
                context.read<TodoListDatabase>().trashAllTodoLists();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                      'Moved all to Trash',
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
    } */

  @override
  Widget build(BuildContext context) {
    // List todolists = context.watch<TodoListDatabase>().todolists;
    // List nonTrashedTodolists = context.watch<TodoListDatabase>().nonTrashedTodolists;
    
    return Drawer(
      semanticLabel: "TodoList Drawer Menu",
      child: SingleChildScrollView(
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
              leading: const Icon(Icons.home_outlined),
              onTap: () {
                Navigator.pop(context);
              }
            ),

            TodoListDrawerTile(
              title: "Starred",
              leading: const Icon(Icons.star_rounded),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoStarred()));
              }
            ),
        
            TodoListDrawerTile(
              title: "Preferences",
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoListPreferences()));
              }
            ),
        
            /* if (todolists.isNotEmpty && nonTrashedTodolists.isNotEmpty)
              TodoListDrawerTile(
                title: "Move all to Trash",
                leading: const Icon(Icons.delete_sweep_outlined),
                onTap: () {
                  trashAllTodoLists();
                },
              ), */

            TodoListDrawerTile(
              title: "Trash",
              leading: const Icon(Icons.delete_outline_rounded),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoTrash()));
              }
            ),
          ],
        ),
      ),
    );
  }
}