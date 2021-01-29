import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterNotificationsPlugin;
  static AndroidNotificationDetails androidSettings;

  static initializer() {
    flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();
    androidSettings = AndroidNotificationDetails(
        "111", "Background_task_Channel", "Channel to test local notification",
        importance: Importance.high, priority: Priority.max);
    var androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: androidInitialization, iOS: null, macOS: null);
    flutterNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onNotificationSelect);
  }

  static Future<void> onNotificationSelect(String payload) async {
    print(payload);
  }

  static showOneTimeNotification(DateTime scheduledDate) async {
    var notificationDetails =
        NotificationDetails(android: androidSettings, iOS: null, macOS: null);

    await flutterNotificationsPlugin.zonedSchedule(
        1,
        "Background Task notification",
        "This is a background task notification",
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation: null,
        androidAllowWhileIdle: null);
  }
}
