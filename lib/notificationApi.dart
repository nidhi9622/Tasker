import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/projectDetail.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channel name',
            //'channel description',
            importance: Importance.max),
        iOS: IOSNotificationDetails(presentAlert: true, presentBadge: true));
  }

  static Future initialize(
      {required Map object, required BuildContext context}) async {
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/icon"),
            iOS: IOSInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
            ));
    notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProjectDetail(object: jsonDecode(id!))));
      },
    );
  }

  // static Future showNotification({
  //   required int id,
  //   String? title,
  //   String? body,
  //   required String? payload,
  // }) async {
  //   print(id);
  //   return await notificationsPlugin.show(
  //     id,
  //     title,
  //     body,
  //     await notificationDetails(),
  //     payload: payload,
  //   );
  // }

  static Future showScheduleNotification(
          {required int id,
          String? title,
          String? body,
          String? payload,
          required dynamic scheduleTime}) async =>
      await notificationsPlugin.zonedSchedule(id, title, body,
          tz.TZDateTime.from(scheduleTime, tz.UTC), await notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
}
