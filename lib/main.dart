import 'package:flutter/material.dart';
import 'package:todo_list/layouts/note_page.dart';
import 'package:todo_list/layouts/note_settings.dart';
import 'package:todo_list/models/note_database.dart';
import 'package:todo_list/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  runApp(
    
    MultiProvider(
      providers: [
        // Note Database Provider
        ChangeNotifierProvider(
          create: (context) => NoteDatabase(),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const NotePage(),
      routes: {
        'notes' : (context) => const NotePage(),
        'settings' : (context) => const NoteSettings(),
      },
    );
  }
}