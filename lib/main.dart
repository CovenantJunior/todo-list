import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_list/layouts/todo_list_page.dart';
import 'package:todo_list/layouts/todo_list_preferences.dart';
import 'package:todo_list/models/todo_list_database.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/services/notification_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // print('Fire');
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  // print("Started");
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    final now = DateTime.now();
    
    /// you can see this log in logcat
    // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    List<PendingNotificationRequest> pendings = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var notification in pendings) {
      Map<String, dynamic> payload = jsonDecode(notification.payload!);
      final scheduledDate =payload['scheduledDate'];
      final interval = payload['interval'];
      if (scheduledDate != null && interval != null) {
        try {
          DateTime scheduledDateTime = DateTime.parse(scheduledDate);
          Duration difference = now.difference(scheduledDateTime);
          
          if (interval == 'Every Minute' && difference.inMinutes <= 1) {
            // Trigger the notification
          } else if (interval == 'Hourly' && difference.inHours <= 1) {
            // Trigger the notification
          } else if (interval == 'Daily' && difference.inDays <= 1) {
            // Trigger the notification
          } else if (interval == 'Weekly' && difference.inDays <= 7) {
            // Trigger the notification
          }
        } catch (e) {
          // Handle error parsing scheduled date
          print('Error parsing scheduled date: $e');
        }
        
        if (interval != 'Hourly' && interval != 'Every Minute' && interval != 'Daily') {
          // Handle invalid interval value
          print('Invalid interval value: $interval');
        }
      }
    }
      
    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoListDatabase.initialize();
  NotificationService().initNotifications();
  initializeService();
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