import 'package:flutter/material.dart';
import 'package:todo_list/layouts/todo_list_page.dart';
import 'package:todo_list/layouts/todo_list_preferences.dart';
import 'package:todo_list/layouts/todo_list_starred.dart';
import 'package:todo_list/layouts/todo_trash_page.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:todo_list/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoListDatabase.initialize();
  runApp(
    
    MultiProvider(
      providers: [
        // TodoList Database Provider
        ChangeNotifierProvider(
          create: (context) => TodoListDatabase(),
        ),

        // Theme Provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        )
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    context.read<TodoListDatabase>().fetchPreferences();
    List preferences = context.watch<TodoListDatabase>().preferences;
    bool? darkMode;

    for (var preference in preferences) {
      setState(() {
        darkMode = preference.darkMode;
      });
    }

    return MaterialApp(
      theme: darkMode == true ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
      routes: {
        'notes' : (context) => const TodoListPage(),
        'settings' : (context) => const TodoListPreferences(),
        'trash' : (context) => const TodoTrash(),
        'starred' : (context) => const TodoStarred()
      },
    );
  }
}