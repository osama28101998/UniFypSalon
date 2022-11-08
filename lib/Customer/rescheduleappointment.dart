// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, avoid_print, prefer_const_constructors, prefer_is_empty

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/customermodel.dart';
import 'package:salon/Customer/reschedulemodel.dart';
import 'package:salon/Customer/seatselection.dart';
import 'package:salon/SalonOwner/Seats.dart';

class rescheduleappointment extends StatefulWidget {
  const rescheduleappointment({Key? key}) : super(key: key);

  @override
  State<rescheduleappointment> createState() => _rescheduleappointmentState();
}

class _rescheduleappointmentState extends State<rescheduleappointment> {
  List<String> timeSlots = [];
  var bookedslots = [];

  final DateFormat formatdate = DateFormat('yyyy-MM-dd');
  TextEditingController datecontroller = TextEditingController();
  var selecteddate;
  var stafftimes;
  late String jointime;
  late String offtime;
  getstafftimings() async {
    var dio = Dio();
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Customer/Showbarbertimings?salonid=' +
        reschedule.salonid.toString() +
        '&staffid=' +
        reschedule.bid.toString();
    var response = await dio.get(url);
    setState(() {
      timeSlots.clear();
      stafftimes = response.data;
      jointime = stafftimes[0]['jointime'].toString();
      offtime = stafftimes[0]['offtime'].toString();
      var join = jointime.split(':');
      var off = offtime.split(':');

      DateTime now = DateTime.now();
      DateTime startTime = DateTime(now.year, now.month, now.day,
          int.parse(join[0]), int.parse(join[1]), 0);
      DateTime endTime = DateTime(now.year, now.month, now.day,
          int.parse(off[0]), int.parse(off[0]), 0);
      Duration step = Duration(minutes: 60);
      while (startTime.isBefore(endTime)) {
        DateTime timeIncrement = startTime.add(step);

        var time = timeIncrement.toString().split(' ');
        timeSlots.add(time[1].toString());
        startTime = timeIncrement;
      }
      print(timeSlots);
    });
  }

  getbookedslots() async {
    var dio = Dio();
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Customer/viewbookedslots?salonid=' +
        reschedule.salonid.toString() +
        '&staffid=' +
        reschedule.bid.toString() +
        '&date=' +
        selecteddate.toString();
    var response = await dio.get(url);
    var res = response.data;
    print('a' + res.toString());
    setState(() {
      bookedslots.clear();
      reschedule.selectedtime.clear();
      for (var i = 0; i < res.length; i++) {
        bookedslots.add(res[i]['booking_time']);
      }
      print(bookedslots);
    });
  }

  void initState() {
    super.initState();
    this.getstafftimings();
    datecontroller.text = reschedule.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reschedule Appointment'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              height: 55,
              child: TextField(
                controller: datecontroller,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030))
                          .then((date) {
                        setState(() {
                          selecteddate = formatdate.format(date!);
                          print(selecteddate);
                          datecontroller.text = selecteddate.toString();
                        });
                      });
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    getbookedslots();
                  },
                  child: Text('Check')),
            ),
            Container(
              width: 500,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 10),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView.builder(
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (bookedslots.contains(timeSlots[index])) {
                          Fluttertoast.showToast(
                              msg: 'This slot is not availible',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }

                        if (reschedule.selectedtime
                            .contains(timeSlots[index].toString())) {
                          reschedule.selectedtime
                              .remove(timeSlots[index].toString());
                          print(reschedule.selectedtime);
                        } else {
                          if (reschedule.selectedtime.length < 1) {
                            reschedule.selectedtime
                                .add(timeSlots[index].toString());
                            print(reschedule.selectedtime);
                          }
                        }
                        setState(() {});
                      },
                      child: Card(
                          color:
                              reschedule.selectedtime.contains(timeSlots[index])
                                  ? Colors.blue
                                  : Colors.white,
                          elevation: 20,
                          child: ListTile(
                            title: Text(timeSlots[index]),
                            subtitle: Text(
                                bookedslots
                                        .contains(timeSlots[index].toString())
                                    ? 'N/A'
                                    : 'Available',
                                style: TextStyle(
                                    color: bookedslots.contains(
                                            timeSlots[index].toString())
                                        ? Colors.red
                                        : Colors.green)),
                            leading: Icon(Icons.timer),
                          )),
                    );
                  }),
            ),
            Container(
              child: ElevatedButton(
                  onPressed: () async {
                    var mesg = await reschedulebooking();
                    Fluttertoast.showToast(
                        msg: mesg.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey[350],
                        textColor: Colors.black,
                        fontSize: 16.0);
                    reschedule.bid = '';
                    reschedule.date = '';
                    reschedule.time = '';
                    reschedule.salonid = '';
                    reschedule.bookingid = '';

                    reschedule.selectedtime.clear();
                  },
                  child: Text('Reschedule Appointment')),
            ),
          ],
        ),
      ),
    );
  }
}
