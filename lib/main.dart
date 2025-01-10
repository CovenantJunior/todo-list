import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_list/layouts/todo_list_page.dart';
import 'package:todo_list/layouts/todo_list_preferences.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:provider/provider.dart';
// import 'package:todo_list/services/credential_service.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      foregroundServiceNotificationId: 144000,

      initialNotificationTitle: "Stay Productive",
      initialNotificationContent: "Take one step at a time and keep moving forward.",

      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      isForegroundMode: true,
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
  /* Timer.periodic(const Duration(seconds: 30), (timer) async {
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
      // print(notification.payload);
      // print(DateTime.now());
      NotificationService().showScheduledNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload
      );
    } else if (interval == 'Hourly' && difference.inHours <= 1) {
      // print(notification.payload);
      // print(DateTime.now());
      NotificationService().showScheduledNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload
      );
    } else if (interval == 'Daily' && difference.inDays <= 1 && scheduledDateTime.isAfter(now.subtract(const Duration(days: 1)))) {
      // print(notification.payload);
      // print(DateTime.now());
      NotificationService().showScheduledNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload
      );
    } else if (interval == 'Weekly' && difference.inDays.abs() <= 7 && scheduledDateTime.weekday != now.weekday) {
      // print(notification.payload);
      // print(DateTime.now());
      NotificationService().showScheduledNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload
      );
    }
  } catch (e) {
    // Handle error parsing scheduled date
  }

  if (interval != 'Hourly' && interval != 'Every Minute' && interval != 'Daily' && interval != 'Weekly') {
    // Handle invalid interval value
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
 */
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await TodoListDatabase.initialize();
  NotificationService().initNotifications();
  initializeService();
  await Firebase.initializeApp();
  // JsonReader jsonReader = JsonReader();
  // Credential credential = await jsonReader.readCredentials();
  await dotenv.load(fileName: "assets/.env");
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListDatabase>(
      builder: (context, todoListDatabase, child) {
        // Initialize theme preference
        todoListDatabase.fetchPreferences();

        return MaterialApp(
          theme: todoListDatabase.preferences.first.darkMode
              ? ThemeData.dark()
              : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/home',
          routes: {
            '/home': (context) => const TodoListPage(),
            '/preferences': (context) => const TodoListPreferences(),
          },
        );
      },
    );
  }
}