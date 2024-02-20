import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
        print(payload);
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
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print(response);
      },
    );
  }

  AndroidNotificationAction ok =
      const AndroidNotificationAction('ACTION_OK', 'Ok');
  AndroidNotificationAction completed =
      const AndroidNotificationAction('ACTION_COMPLETED', 'Mark as Completed');
  AndroidNotificationAction reschedule =
      const AndroidNotificationAction('ACTION_RESCHEDULE', 'Reschedule');
  AndroidNotificationAction delete =
      const AndroidNotificationAction('ACTION_DELETE', 'Delete');

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
            'Get reminders for your tasks and stay organized with notifications from the Todo List App',
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
            'Get reminders for your tasks and stay organized with notifications from the Todo List App',
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
        id, title, body, notificationDetails());
  }

  // Schedule and Send Notification
  scheduleNotification(
    {
      int id = 0,
      String? title,
      String? body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation,
      String? payload,
      androidScheduleMode}) {
      return flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation, androidScheduleMode: androidScheduleMode
      );
  }
}