// // ignore_for_file: prefer_const_constructors

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class NotificationService {
//   //LocalNotificationService();
//    final  _notificationService = FlutterLocalNotificationsPlugin();



//   Future<void> initialize() async {
//     final AndroidInitializationSettings Androidsettings =
//     AndroidInitializationSettings('@drawable/logo');

//     final IOSInitializationSettings IOSsettings =
//     IOSInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );

//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> showNotification(int id, String title, String body, int seconds) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'main_channel',
//           'Main Channel',
          
          
//           channelDescription:'Main channel notifications' ,
//           importance: Importance.max,
//           priority: Priority.max,
//           icon: '@drawable/ic_launcher'
//         ),
//         iOS: IOSNotificationDetails(
//           sound: 'default.wav',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }

//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }