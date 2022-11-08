// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Salonprofile.dart';
import 'package:salon/Login.dart';
import 'package:salon/SalonOwner/Mystaff.dart';
import 'package:salon/SalonOwner/Seats.dart';
import 'package:salon/SalonOwner/notifications.dart';
import 'package:salon/SalonOwner/salonlocation.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';
import 'package:salon/SalonOwner/salonservices.dart';
import 'package:salon/SalonOwner/salonwonerprofile.dart';
import 'package:salon/SalonOwner/servicetype.dart';
import 'package:salon/user_model.dart';

class ownerdashboard extends StatefulWidget {
  String email;
  String name;
  String role;
  ownerdashboard({required this.email, required this.name, required this.role});

  @override
  State<ownerdashboard> createState() => _ownerdashboardState();
}

class _ownerdashboardState extends State<ownerdashboard> {
  var count;
  viewnotificationcount() async {
    var dio = Dio();
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Salonowner/viewnotificationcount?id=' +
        User.id.toString();
    var response = await dio.get(url);
    setState(() {
      count = response.data;
    });

    print(count);
    print(count.toString());
  }

  void initState() {
    super.initState();
    this.viewnotificationcount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointments'), actions: <Widget>[
        Stack(children: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Get.to(salonownernotifications());
              }),
          count != 'No unread found'
              ? Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Container(),
        ])
      ]),

      body: Center(
          child: Container(
        child: future(),
      )),

      drawer: User.status != 'deactive'
          ? Drawer(
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
                        backgroundImage: User.image == null
                            ? NetworkImage('https://picsum.photos/250?image=9')
                            : NetworkImage('http://' +
                                IP.ip +
                                '/SalonService' +
                                User.image)),
                  ),
                  ListTile(
                    title: const Text('Appointment Dashboard'),
                    leading: Icon(Icons.dashboard),
                    onTap: () {
                      Navigator.pop(context);
                      // Get.off(()=>ownermain());
                    },
                  ),
                  ListTile(
                    title: const Text('Service category'),
                    leading: Icon(Icons.category),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(servicetype());
                    },
                  ),
                  ListTile(
                    title: const Text('Services'),
                    leading: Icon(Icons.miscellaneous_services_sharp),
                    onTap: () {
                      Navigator.pop(context);

                      Get.to(mysalonservices());
                    },
                  ),
                  ListTile(
                    title: const Text('Staff'),
                    leading: Icon(Icons.emoji_people_outlined),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(staff());
                    },
                  ),
                  ListTile(
                    title: const Text('Profile'),
                    leading: Icon(Icons.person),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(salonownerprofile());
                    },
                  ),
                  ListTile(
                    title: const Text('Seats'),
                    leading: Icon(Icons.chair),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(salonseats());
                    },
                  ),
                  ListTile(
                    title: const Text('Location'),
                    leading: Icon(Icons.location_on),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(salonlocation());
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      Navigator.pop(context);

                      Get.offAll(loginHome());
                    },
                  ),
                ],
              ),
            )
          : Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
                UserAccountsDrawerHeader(
                  accountName: Text(User.name),
                  accountEmail: Text(User.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? Colors.blue
                            : Colors.white,
                    child: Text(
                      User.role,
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Logout'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Navigator.pop(context);

                    Get.offAll(loginHome());
                  },
                ),
              ]),
            ),

      // Text(
      //           'Welcome!',
      //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         ),
    );
  }

  Widget future() {
    return FutureBuilder(
        future: getmysalonbookings(),
        builder: (_context, AsyncSnapshot snapshot) {
          // print('here');
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: Text(''));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext build, ind) {
                  Map data = snapshot.data[ind];
                  return Container(
                    height: 140,
                    child: Column(
                      children: [
                        Card(
                          elevation: 8,
                          shadowColor: Colors.black87,
                          //color: Color.fromARGB(255, 45, 188, 255),
                          child: Column(
                            //  mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(('http://' +
                                      IP.ip +
                                      '/SalonService' +
                                      data['image'].toString())),
                                ),
                                title: Text(
                                  data['u_name'].toString().toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(data['staff_fname'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                                trailing: Text(
                                    data['booking_status'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  // const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text(
                                      'Details',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () async {
                                      var d = data['booking_date']
                                          .toString()
                                          .split('T');

                                      return showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Booking Details'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text('Booking Date : ' +
                                                      d[0].toString()),
                                                  Text('Booking Time : ' +
                                                      data['booking_time']
                                                          .toString()),
                                                  Text('Service Name : ' +
                                                      data['s_name']
                                                          .toString()),
                                                  Text('Staff Name : ' +
                                                      data['staff_fname']
                                                          .toString()),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Mark Complete',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Row(
                                                children: const [
                                                  CircularProgressIndicator(),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Please Wait..."),
                                                ],
                                              ),
                                            );
                                          });
                                      var id = data['booking_id'].toString();
                                      var mesg = await markcomplete(id.toString());
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg: mesg.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                          setState(() {
                                            
                                          });
                                    },
                                  ),
                                  //const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
          else {
            // print('object');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
