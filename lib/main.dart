import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/layouts/todo_list_page.dart';
import 'package:todo_list/layouts/todo_list_preferences.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/services/notification_service.dart';

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    // print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  // print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  NotificationService().initNotifications();
  BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoListDatabase.initialize();
  runApp(
    MultiProvider(
      providers: [
        // TodoList Database Provider
        ChangeNotifierProvider(
          create: (context) => TodoListDatabase(),
        )
      ],
      child: const MyApp()
    )
  );
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      startOnBoot: true,
      forceAlarmManager: true,
      requiredNetworkType: NetworkType.NONE,
      minimumFetchInterval: 15, // Fetch interval in minutes
      stopOnTerminate: false, // Indicate that background fetch should not stop when the app is terminated
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
    ),
    (String taskId) async {
      // Handle background fetch event
      // This is the fetch-event callback.
      // print("[BackgroundFetch] Event received $taskId");

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      NotificationService().initNotifications();
      BackgroundFetch.finish(taskId);
    }, (String taskId) async { 
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      // print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    }
  );
  BackgroundFetch.start().then((int status) {
    // print('[BackgroundFetch] start success: $status');
  }).catchError((e) {
    // print('[BackgroundFetch] start FAILURE: $e');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize theme preference
    context.read<TodoListDatabase>().themePreference();
    return MaterialApp(
      theme: context.watch<TodoListDatabase>().isDark == true
          ? ThemeData.dark()
          : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const TodoListPage(),
        '/preferences': (context) => const TodoListPreferences(),
      },
    );
  }
}
