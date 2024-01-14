import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class TodoListPreferences extends StatefulWidget {
  const TodoListPreferences({super.key});

  @override
  State<TodoListPreferences> createState() => _TodoListPreferencesState();
}

class _TodoListPreferencesState extends State<TodoListPreferences> {
  late bool isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Used AppBar just for the back icon
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand"
                      ),
                    ),
                    CupertinoSwitch(
                      value: isDark,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                        setState(() {
                          isDark = !isDark;
                        });
                      }
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand"
                      ),
                    ),
                    CupertinoSwitch(
                      value: false,
                      onChanged: (value) {
                      }
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}