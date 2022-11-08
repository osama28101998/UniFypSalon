// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/Splash.dart';
 
void main() => runApp(const MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  static const String _title = 'Salon Booking App';
 
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:  splashscreen(),
      ),
    );
  }
}