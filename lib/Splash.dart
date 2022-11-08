// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salon/Login.dart';
import 'package:salon/notificationservice.dart';
import 'package:salon/test.dart';
import 'Customer/menuscreen.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({ Key? key }) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

     @override
  void initState() {
    
    super.initState();

    Timer(const Duration(seconds: 4),(() => Navigator.push(context, MaterialPageRoute(builder:(context)=> loginHome())))); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue ,
          body:Column(
           mainAxisAlignment:MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
             children:<Widget> [
               CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
                radius: 100,
                ),
               const SizedBox(height: 30.0,),
              const SpinKitRing(
                color: Colors.white,
                size: 50,
                )
          ],
          )
    );
  }}