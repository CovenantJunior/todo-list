import 'package:flutter/material.dart';
import 'package:todo_list/layouts/todo_list_page.dart';
import 'package:todo_list/layouts/todo_list_preferences.dart';
import 'package:todo_list/layouts/todo_list_starred.dart';
import 'package:todo_list/layouts/todo_trash_page.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:todo_list/models/todo_preferences_database.dart';
import 'package:todo_list/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoListDatabase.initialize();
  await TodoPreferencesDatabase.initialize();
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
        ),

        // Theme Provider
        ChangeNotifierProvider(
          create: (context) => TodoPreferencesDatabase(),
        )
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
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