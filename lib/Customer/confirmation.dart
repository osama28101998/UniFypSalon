// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:salon/Customer/customermodel.dart';
// import 'package:salon/Appointments.dart';
import 'package:salon/Login.dart';
import 'package:salon/Customer/menuscreen.dart';
import 'package:salon/user_model.dart';

class confirmtion extends StatelessWidget {
  const confirmtion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: confirmation(),
    );
  }
}

class confirmation extends StatefulWidget {
  const confirmation({Key? key}) : super(key: key);

  @override
  State<confirmation> createState() => _confirmationState();
}

class _confirmationState extends State<confirmation> {
  late FlutterLocalNotificationsPlugin notificationsPlugin;

  void initState() {
    super.initState();
    modeldata.servicechoosen.clear();
    modeldata.selectedservicetype.clear();

    modeldata.selectedseats.clear();

    modeldata.selectedserviceid.clear();
    modeldata.serviceselection.clear();

    modeldata.servicelist.clear();
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('drawable/logo');
    var ios = IOSInitializationSettings();
    var initsettings = InitializationSettings(android: android, iOS: ios);
    notificationsPlugin.initialize(initsettings,
        onSelectNotification: (payload) {
      debugPrint("payload : $payload ");
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Notification'),
                content: Text('$payload'),
              ));
    });
    Shownotification();
  }
  //Timer(const Duration(seconds: 5),(() => Navigator.push(context, MaterialPageRoute(builder:(context)=> loginHome()))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Confirmation')),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/confirmation.gif'),
              radius: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Appointment Confirmed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // const SizedBox(height: 30.0,),
            //   const SpinKitRing(
            //     color: Colors.blue,
            //     size: 50,
            //     ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      // Get.offAll(() => appointments());
                    },
                    label: Text('See Appointment'),
                    icon: Icon(Icons.visibility_rounded)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.star),
                    label: Text('Rate Application')),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.off(MyHomePage(
                        email: User.email, name: User.name, role: User.role));
                  },
                  icon: Icon(Icons.menu),
                  label: Text('Main Menu'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Shownotification() async {
    var android = new AndroidNotificationDetails('channelId', 'channelName',
        channelDescription: 'channelDescription');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: ios);
    await notificationsPlugin.show(
        0,
        'Salon Service Booking App',
        'Your Booking is Successfull Booking Date is : ' +
            modeldata.selecteddate.toString() +
            '&Time is +' +
            modeldata.selectedtime.toString(),
        platform);
  }
}
