import 'dart:async';

// ignore: implementation_imports
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restart_app/restart_app.dart';
import 'package:todo_list/models/todo_list_database.dart';

List preferences = [];
TodoListDatabase db = TodoListDatabase();

void fetchUntrashedTodoList() async {
  db.fetchUntrashedTodoList();
}

void fetchPreferences() async {
  db.fetchPreferences();
}

void completed(int id) async {
  db.completed(id);
}

void trashTodoList(int id) async {
  db.trashTodoList(id);
}

@pragma('vm:entry-point')
Future<void> notificationResponse(NotificationResponse notificationResponse) async {
  if (notificationResponse.actionId != null) {
    if (notificationResponse.actionId == 'ACTION_COMPLETED') {
      db.completed(notificationResponse.id!);
      db.fetchUntrashedTodoList();
      Restart.restartApp(webOrigin: '/home');
    } else if (notificationResponse.actionId == 'ACTION_DELETE') {
      db.trashTodoList(notificationResponse.id!);
      db.fetchUntrashedTodoList();
      Restart.restartApp(webOrigin: '/home');
    }
  }
}

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initilaize Notification
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  Future<void> initNotifications() async {
    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestProvisionalPermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
          
        },
    );

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationResponse
    );
  }

  AndroidNotificationAction ok =
      const AndroidNotificationAction('ACTION_OK', 'Ok', showsUserInterface: true);
  AndroidNotificationAction completed =
      const AndroidNotificationAction('ACTION_COMPLETED', 'Mark as Completed', showsUserInterface: true);
  AndroidNotificationAction reschedule =
      const AndroidNotificationAction('ACTION_RESCHEDULE', 'Reschedule', showsUserInterface: true);
  AndroidNotificationAction delete =
      const AndroidNotificationAction('ACTION_DELETE', 'Delete', showsUserInterface: true);

  LinuxNotificationAction linuxOk =
      const LinuxNotificationAction(key: 'ACTION_OK', label: 'Ok');
  LinuxNotificationAction linuxCompleted = const LinuxNotificationAction(
      key: 'ACTION_COMPLETED', label: 'Mark as Completed');
  LinuxNotificationAction linuxReschedule = const LinuxNotificationAction(
      key: 'ACTION_RESCHEDULE', label: 'Reschedule');
  LinuxNotificationAction linuxDelete =
      const LinuxNotificationAction(key: 'ACTION_DELETE', label: 'Delete');

  androidDetails() {
    return AndroidNotificationDetails(
        'todo_notifications', 'Todo List Notifications',
        channelDescription:
            'Get reminders for your tasks and stay organized with notifications from the Minimalist Todo List App',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        visibility: NotificationVisibility.public,
        enableVibration: true,
        fullScreenIntent: false,
        enableLights: true,
        actions: [
          ok,
          completed,
          delete,
        ]);
  }

  darwinDetails() {
    return const DarwinNotificationDetails(
        subtitle:
            'Get reminders for your tasks and stay organized with notifications from the Minimalist Todo List App',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical);
  }

  linuxDetails() {
    return LinuxNotificationDetails(
      sound: ThemeLinuxSound('message'),
      category: LinuxNotificationCategory.imReceived,
      urgency: LinuxNotificationUrgency.critical,
      timeout: const LinuxNotificationTimeout.systemDefault(),
      resident: false,
      defaultActionName: null,
      customHints: null,
      actions: <LinuxNotificationAction>[
        linuxOk,
        linuxCompleted,
        linuxDelete,
      ],
    );
  }

  notificationDetails() {
    return NotificationDetails(
        android: androidDetails(),
        iOS: darwinDetails(),
        macOS: darwinDetails(),
        linux: linuxDetails());
  }

  // Build and Send Notification
  showNotification({int id = 0, String? title, String? body, String? payload}) {
    return flutterLocalNotificationsPlugin.show(
      id, title, body, notificationDetails(), payload: payload
    );
  }

  // Schedule and Send Notification
  scheduleNotification(
    {
      int? id,
      String? title,
      String? body,
      String? interval,
      scheduledDate,
      String? payload
    }
  ) {
    RepeatInterval notificationInterval;
      switch (interval) {
        case 'Every Minute':
          notificationInterval = RepeatInterval.everyMinute;
          break;
        case 'Hourly':
          notificationInterval = RepeatInterval.hourly;
          break;
        case 'Daily':
          notificationInterval = RepeatInterval.daily;
          break;
        case 'Weekly':
          notificationInterval = RepeatInterval.weekly;
          break;
        default:
          notificationInterval = RepeatInterval.everyMinute;
        break;
      }
      return flutterLocalNotificationsPlugin.periodicallyShow(
        id!, title, body, notificationInterval, notificationDetails(), payload: payload, androidScheduleMode: AndroidScheduleMode.alarmClock
      );
  }

  cancelNotification(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}