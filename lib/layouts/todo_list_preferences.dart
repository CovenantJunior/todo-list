import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:todo_list/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class TodoListPreferences extends StatefulWidget {
  const TodoListPreferences({super.key});

  @override
  State<TodoListPreferences> createState() => _TodoListPreferencesState();
}

class _TodoListPreferencesState extends State<TodoListPreferences> {
  late bool isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  late bool notification;
  late bool backup;
  late bool autoSync;
  late bool autoDelete;

  @override
  void initState() {
    super.initState();
    readPreferences();
  }

  Future<void> readPreferences () async {
    context.read<TodoListDatabase>().fetchPreferences();
  }

  @override
  Widget build(BuildContext context) {
    List preferences = context.watch<TodoListDatabase>().preferences;
    print(preferences);

    for (var preference in preferences) {
      setState(() {
        notification = preference.notification;
        backup = preference.backup;
        autoSync = preference.autoSync;
        autoDelete = preference.autoDelete;
      });
    }


    return Scaffold(
      appBar: AppBar(
        // Used AppBar just for the back icon
        title: const Text(
          "Preferences",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.dark_mode_outlined),
                          SizedBox(width: 20),
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand"
                            ),
                          ),
                        ],
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
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notifications_none_rounded),
                          SizedBox(width: 20),
                          Text(
                            'Notification',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand"
                            ),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: notification,
                        onChanged: (value) {
                        }
                      )
                    ],
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.add_to_drive),
                          SizedBox(width: 20),
                          Text(
                            'Backup to Drive',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand"
                            ),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                        }
                      )
                    ],
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.sync_rounded),
                          SizedBox(width: 20),
                          Text(
                            'Auto Sync',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand"
                            ),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                        }
                      )
                    ],
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_delete_outlined),
                          SizedBox(width: 20),
                          Text(
                            'Auto Delete Completed Task',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand"
                            ),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: false,
                        onChanged: (value) {
                        }
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}