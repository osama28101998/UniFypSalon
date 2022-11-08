// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/rescheduleappointment.dart';
import 'package:salon/Customer/reschedulemodel.dart';
import 'package:salon/user_model.dart';

class appointment extends StatefulWidget {
  const appointment({Key? key}) : super(key: key);

  @override
  State<appointment> createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  late Future _future;

  @override
  Widget build(BuildContext context) {
    _future = getmybookings();
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: future(),
            ),
          ],
        ),
      ),
    );
  }

  Widget future() {
    return FutureBuilder(
        future: _future,
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
                                leading: Image.asset(
                                  'assets/barber1.jpg',
                                  height: 130,
                                ),
                                title: Text(
                                    data['salonname'].toString().toUpperCase()),
                                subtitle: Text(data['servicename']),
                                trailing: Text('Staff : ' + data['staffname']),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  // const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () async {
                                      var d = data['bookingdate']
                                          .toString()
                                          .split('T');
                                      print(d[0]);
                                      return showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
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
                                                      data['bookingtime']
                                                          .toString()),
                                                  Text('Booking Status : ' +
                                                      data['bookingstatus']
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
                                    child: const Text(
                                      'Details',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),

                                  TextButton(
                                      onPressed: () {
                                        var d = data['bookingdate']
                                            .toString()
                                            .split('T');

                                        reschedule.bid = data['staffid'];
                                        reschedule.date = d[0];
                                        reschedule.time = data['bookingtime'];
                                        reschedule.salonid = data['salonid'];
                                        reschedule.bookingid=data['bookingid'];
                                        
                                        Get.to(rescheduleappointment());                                      },
                                      child: Text('Reschedule'))
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
