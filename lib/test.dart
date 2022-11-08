// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:salon/notificationservice.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late FlutterLocalNotificationsPlugin notificationsPlugin;
  @override
  void initState() {
    
    super.initState();
     notificationsPlugin=FlutterLocalNotificationsPlugin();
     var android=AndroidInitializationSettings('drawable/logo');
     var ios=IOSInitializationSettings();
     var initsettings=InitializationSettings(android: android,iOS: ios);
     notificationsPlugin.initialize(initsettings,onSelectNotification:
     ( payload){
           debugPrint("payload : $payload ");
           showDialog(context: context, builder: (_)=>AlertDialog(
            title: Text('Notification'),
            content:Text('$payload'),


           ));
     });
  }
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed:(){
              Shownotification();
            },child:Text('show simple')),
            ElevatedButton(onPressed:(){},child:Text('show scheduled ')),
            ElevatedButton(onPressed:(){},child:Text('show')),
           
          ],
        ),
      ),
    );
  }
  Shownotification()async{
    var android=new AndroidNotificationDetails('channelId', 'channelName',channelDescription:'channelDescription' );
    var ios=new IOSNotificationDetails();
    var platform=new NotificationDetails(android: android,iOS: ios);
    await notificationsPlugin.show(0, 'Salon Service Booking App', 'Your Booking is Successfull', platform);

  }
}