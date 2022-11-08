// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/acceptedrequest.dart';
import 'package:salon/Admin/adminprofile.dart';
import 'package:salon/Admin/ip.dart';

import '../Login.dart';
import '../user_model.dart';
import 'Adminmain.dart';

class AdminTab extends StatefulWidget {
  const AdminTab({Key? key}) : super(key: key);

  @override
  State<AdminTab> createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Admin Dashboard"),
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.pending)),
              Tab(icon: Icon(Icons.approval_sharp)),
              Tab(icon: Icon(Icons.not_interested_sharp)),
            ])),
        body: TabBarView(children: [
          adminmain(
            email: User.email,
            name: User.name,
            role: User.role,
          ),
          acceptedreq(),
          Center(child: Text("Data"))
        ]),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(User.name),
                accountEmail: Text(User.email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  backgroundImage: User.image==null ?
                 NetworkImage('https://picsum.photos/250?image=9')
                  :
                  NetworkImage('http://'+IP.ip+'/SalonService'+User.image)
                  ,
                ),
              ),
              // ListTile(
              //   title: const Text('Saloon Requests'),
              //   leading: Icon(Icons.approval),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Get.offAll(()=>request());
              //   },
              // ),
               ListTile(
                title: const Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Get.to(adminprofile());
                },
              ),
              ListTile(
                title: const Text('Logout'),
                leading: Icon(Icons.logout),
                onTap: () {
                  Get.offAll(() => loginHome());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
