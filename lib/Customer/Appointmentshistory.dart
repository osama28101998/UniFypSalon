// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/review.dart';
import 'package:salon/Customer/reviewmodel.dart';

class bookinghistory extends StatefulWidget {
  const bookinghistory({Key? key}) : super(key: key);

  @override
  State<bookinghistory> createState() => _bookinghistoryState();
}

class _bookinghistoryState extends State<bookinghistory> {
  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future = getbookinghistory();
    return Scaffold(
      appBar: AppBar(
        title: Text(' Appointment History'),
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
                                  // reviewed
                                  data['isreview']
                                          .toString()
                                          .contains('notreviewed')
                                      ? TextButton(
                                          onPressed: () {
                                            print(data['isreview']);
                                            reviewmodel.barberid =
                                                data['staffid'];
                                            reviewmodel.salonid =
                                                data['salonid'];
                                            reviewmodel.barbername =
                                                data['staffname'];
                                            reviewmodel.salonname =
                                                data['salonname'];
                                            reviewmodel.bookingid =
                                                data['bookingid'];

                                            Get.to(review());
                                          },
                                          child: Text('Make a Review'))
                                      : Text(
                                          'Reviewed',
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold),
                                        ),

                                  TextButton(
                                      onPressed: () async {
                                        return showDialog(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Staff & salon favorite'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          var staffid =
                                                              data['staffid']
                                                                  .toString();
                                                          var mesg =
                                                              await addfavoritestaff(
                                                                  staffid);
                                                           Fluttertoast.showToast(
          msg: mesg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
                                                          // print(data['staffid']);
                                                          // print('aaa'+data['userid'].toString());
                                                        },
                                                        child: Text('Staff')),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          var salonid =
                                                              data['salonid']
                                                                  .toString();
                                                          var mesg =
                                                              await addfavoritesalon(
                                                                  salonid);
                                                           Fluttertoast.showToast(
          msg: mesg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
                                                          //  print( data['salonid']);
                                                        },
                                                        child: Text('Salon'))
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
                                      child: Text('Add to favorite'))
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
