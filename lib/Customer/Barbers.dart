// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/BarberReviews.dart';
import 'package:salon/Customer/Barbertimeslot.dart';
import 'package:salon/Customer/BookingDetails.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/customermodel.dart';
import 'package:salon/user_model.dart';
// import 'package:salon/BookingDetails.dart';
// import 'package:salon/Salonprofile.dart';

class selecttime extends StatefulWidget {
  const selecttime({Key? key}) : super(key: key);

  @override
  State<selecttime> createState() => _selecttimeState();
}

class _selecttimeState extends State<selecttime> {
  List<staffrating> staffdata = [];
  //DateTime date = DateTime.now();
  var selecteddate;
  var selectedtime;
  late Future _future;
  final DateFormat formatdate = DateFormat('yyyy-MM-dd');
  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();

  

  void initState() {
    super.initState();
   // this.getstaffrating();
  }

  @override
  Widget build(BuildContext context) {
    _future = getsalonbarbers();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    child: future(),
                  )),
            ],
          ),
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
            return Center(child: CircularProgressIndicator());
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
                                leading:Image.network(
                                            
                                  ('http://' +
                                    IP.ip +
                                    '/SalonService' +
                                    data['staff_image'].toString()),
                                  
                                ),
                                title: Text((data['staff_fname'] +
                                        ' ' +
                                        data['staff_lname'])
                                    .toString()
                                    .toUpperCase(),
                                    
                                    style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),
                                    ),
                                subtitle:
                                    Text('Speciality : ' + data['stype_name']),
                                trailing: RatingBarIndicator(
                                  rating:double.parse(data['rating'].toString()),
                                     
                                  itemSize: 20,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[

                                  TextButton(
                                    child: const Text(
                                      'Choose',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      // var a=staffdata.singleWhere(((element) =>element.name=="Zafar"));
                                      // print(a.rating);
                                      modeldata.staffid = data['id'];
                                      modeldata.staffname =
                                          data['staff_fname'] +
                                              ' ' +
                                              data['staff_lname'];

                                      Get.to(Stafftimes());
                                    },
                                  ),

                                        TextButton(
                                    child: const Text(
                                      'See Reviews',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                                                            modeldata.staffid = data['id'];

                                      modeldata.staffname =
                                          data['staff_fname'] +
                                              ' ' +
                                              data['staff_lname'];
                                       Get.to(staffreviews());
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
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
