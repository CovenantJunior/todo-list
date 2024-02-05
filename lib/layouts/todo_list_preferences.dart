import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';

class TodoListPreferences extends StatefulWidget {
  const TodoListPreferences({super.key});

  @override
  State<TodoListPreferences> createState() => _TodoListPreferencesState();
}

class _TodoListPreferencesState extends State<TodoListPreferences> {
  int? id;
  late bool darkMode;
  late bool notification;
  late bool vibration;
  late bool stt;
  late bool readPlan;
  late bool backup;
  late bool autoSync;
  late bool accessClipboard;
  late bool autoDelete;

  @override
  void initState() {
    super.initState();
    readPreferences();
  }

  Future<void> readPreferences () async {
    context.read<TodoListDatabase>().fetchPreferences();
  }

  void notifyInfo() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text(
          "Notification",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w600,
            fontSize: 20
          ),
        ),
        content: Text(
          "Notifications are shown at the best time of the day, just sit back",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w500,
          )
        ),
      ),
    );
  }

  void clipBoardInfo() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text(
          "Clipboard",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w600,
            fontSize: 20
          ),
        ),
        content: Text(
          "Read immediate Clipboard data for a quick task creation",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w500,
          )
        ),
      ),
    );
  }

  void ttsInfo() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text(
          "Text to Speech",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w600,
            fontSize: 20
          ),
        ),
        content: Text(
          "Fill in task description with your voice",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w500,
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List preferences = context.watch<TodoListDatabase>().preferences;

    for (var preference in preferences) {
      setState(() {
        id = preference.id;
        darkMode = preference.darkMode;
        notification = preference.notification;
        vibration = preference.vibration;
        stt = preference.stt;
        readPlan = preference.readPlan;
        backup = preference.backup;
        autoSync = preference.autoSync;
        accessClipboard = preference.accessClipboard;
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
                        value: darkMode,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setDarkMode(id);
                        }
                      )
                    ],
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications_none_rounded),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              const Text(
                                'Notification',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Quicksand"
                                ),
                              ),
                              const SizedBox(width: 7),
                              Baseline(baseline: 10.0,
                              baselineType: TextBaseline.alphabetic,
                              child: GestureDetector(onTap: notifyInfo, child: const Icon(Icons.help_outline_rounded, size: 15)))
                            ],
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: notification,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setNotification(id);
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
                          Icon(Icons.vibration_rounded),
                          SizedBox(width: 20),
                          Row(
                            children: [
                              Text(
                                'Vibration',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Quicksand"
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: notification,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setNotification(id);
                        }
                      )
                    ],
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications_none_rounded),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              const Text(
                                'Speech to Text',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Quicksand"
                                ),
                              ),
                              const SizedBox(width: 7),
                              Baseline(baseline: 10.0,
                              baselineType: TextBaseline.alphabetic,
                              child: GestureDetector(onTap: ttsInfo, child: const Icon(Icons.help_outline_rounded, size: 15)))
                            ],
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: notification,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setNotification(id);
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
                          Icon(Icons.volume_up_sharp),
                          SizedBox(width: 20),
                          Text(
                            'Read out Plan Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Quicksand"
                            ),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: backup,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setBackup(id);
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
                        value: backup,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setBackup(id);
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
                        value: autoSync,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setAutoSync(id);
                        }
                      )
                    ],
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.copy_outlined),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              const Text(
                                'Access Clipboard',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Quicksand"
                                ),
                              ),
                              const SizedBox(width: 7),
                              Baseline(baseline: 10.0,
                              baselineType: TextBaseline.alphabetic,
                              child: GestureDetector(onTap: clipBoardInfo, child: const Icon(Icons.help_outline_rounded, size: 15))),
                            ],
                          )
                        ],
                      ),
                      CupertinoSwitch(
                        value: autoSync,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setAutoSync(id);
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
                        value: autoDelete,
                        onChanged: (value) {
                          context.read<TodoListDatabase>().setAutoDelete(id);
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