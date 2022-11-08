// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/BookingDetails.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/customermodel.dart';

class seatselection extends StatefulWidget {
  const seatselection({Key? key}) : super(key: key);

  @override
  State<seatselection> createState() => _seatselectionState();
}

class _seatselectionState extends State<seatselection> {
  getseatstatus() async {
    var dio = Dio();
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Customer/viewseatstatus?salonid=' +
        modeldata.selectedsalonid.toString() +
        '&date=' +
        modeldata.selecteddate.toString() +
        '&time=' +
        modeldata.selectedtime.toString();
    var response = await dio.get(url);
    setState(() {
      modeldata.seatstatus = response.data;
      print(modeldata.seatstatus.length);
    });
  }

  void initState() {
    super.initState();
    this.getseatstatus();
  }

  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future = getsalonseats();
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Seat'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: future(),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {


             Get.to(bookingdetails());
            }, label: Icon(Icons.navigate_next)));
  }

  Widget future() {
    return FutureBuilder(
        future: _future,
        builder: (_context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: Text('No Seats'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 100,
                  mainAxisSpacing: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext build, ind) {
                Map data = snapshot.data[ind];
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (modeldata.selectedseats
                          .contains(data['seat_id'].toString())) {
                        modeldata.selectedseats
                            .remove(data['seat_id'].toString());
                        print(modeldata.selectedseats);
                      } else {
                        modeldata.selectedseats.add(data['seat_id'].toString());
                        print(modeldata.selectedseats);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.chair),
                    // child: Text(data["seat_code"],
                    // style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white)),
                    decoration: BoxDecoration(
                        color: modeldata.seatstatus.contains(data['seat_id'])
                            ? Colors.red
                            : Colors.green,
                        border: Border.all(color:
                        modeldata.selectedseats.contains(data['seat_id'].toString()) ?
                        Colors.amber
                                 : Colors.white,
                                 width: 10,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                );
              },
            );
          }
          else {
            // print('object');
            return const Center();
          }
        });
  }
}
