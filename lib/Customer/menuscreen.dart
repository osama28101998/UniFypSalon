// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, curly_braces_in_flow_control_structures, avoid_print

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Appointments.dart';
import 'package:salon/Customer/Appointmentshistory.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/Favoritesalons.dart';
import 'package:salon/Customer/Favoritestaff.dart';
import 'package:salon/Customer/Profile.dart';
import 'package:salon/Customer/Topstaff.dart';
import 'package:salon/Customer/currentlocation.dart';
import 'package:salon/user_model.dart';
import 'customermodel.dart';
import 'package:salon/Login.dart';

// import 'package:salon/currentlocation.dart';

class MyHomePage extends StatefulWidget {
  String email;
  String name;
  String role;
  MyHomePage({required this.email, required this.name, required this.role});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedindex = -1;
var city;
  List<fetchedservice> service = [];
  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController noofperson = TextEditingController();
  TextEditingController estimatedprice = TextEditingController();
  TextEditingController estimatedtime = TextEditingController();
  var selecteddate;
  var _selectedTime = null;
  final DateFormat formatdate = DateFormat('yyyy-MM-dd');
  var dropdownvalue;
  // var servicetype = [];
  var teststring;
  var list = [];
  var selectedservices = [];
  Viewservices() async {
    var dio = Dio();
    String url = ('http://' + IP.ip + '/SalonService/api/Customer/Viewservices')
        .toString();
    var response = await dio.get(url);
    setState(() {
      list = response.data;

      print(service);
    });
  }

_determinepos() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services Disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return Future.error('Location Permission Denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission Denied Permanantly');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  getlocation()async{
    Position position=await _determinepos();
    
    var lat=position.altitude;
    var lng=position.longitude;
     
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(lat, lng);

                              print(placemarks.reversed.last.locality.toString());
  }

  // Getservicetypes() async {
  //   var dio = Dio();
  //   String url =
  //       'http://' + IP.ip + '/SalonService/api/Customer/Viewservicetype';
  //   print(url);
  //   var response = await dio.get(url);
  //   if (response.data.length > 0) {
  //     setState(() {
  //       servicetype = response.data;
  //     });
  //   }
  // }

  void initState() {
    super.initState();
    this.Viewservices();
    this.getlocation();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ' + User.name)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'Date',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                            .then((date)
                            
                             {
                              if(date!=null)
                              {
                          setState(() {
                            selecteddate = formatdate.format(date);
                            modeldata.selecteddate = selecteddate;
                            print(selecteddate.toString());
                            datecontroller.text = selecteddate.toString();
                          });
                              }else{
                                 datecontroller.text = 'No time selected';
                              }
                        });
                        
                      },
                      icon: Icon(Icons.calendar_month),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Time',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              Container(
                width: 200,
                height: 55,
                child: TextField(
                  controller: timecontroller,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        var time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());

                        if (time != null) {
                          setState(() {
                            print(time.hour);
                            _selectedTime = time.format(context);
                            print(_selectedTime);
                          });
                        }

                        _selectedTime != null
                            ? timecontroller.text = _selectedTime.toString()
                            : timecontroller.text = 'No time Selected';
                      },
                      icon: Icon(Icons.timer_rounded),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'No.of persons',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                height: 55,
                child: TextField(
                  controller: noofperson,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                child: MultiSelectDialogField(
                  title: Text('Select Services'),
                  itemsTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  searchHint: 'Service Name',
                  chipDisplay: MultiSelectChipDisplay(
                    textStyle: TextStyle(color:Colors.white),
                    chipColor: Colors.blue,
                    onTap: (value) {
                      setState(() {
                        selectedservices.remove(value);
                      });
                    },
                  ),
                  searchable: true,
                  items: list
                      .map((item) => MultiSelectItem(
                          item['Servicename'], item['Servicename']))
                      .toList(),
                  listType: MultiSelectListType.LIST,
                  onConfirm: (values) {
                    if (values.length <= 3) {
                      selectedservices = values;
                      modeldata.servicechoosen = values;
                      print('object' + modeldata.servicechoosen.toString());
                      print(selectedservices);
                    } else {
                      values.clear();
                      selectedservices.clear();
                      modeldata.servicechoosen.clear();
                      Fluttertoast.showToast(
                          msg: 'only max of 3',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey[350],
                          textColor: Colors.black,
                          fontSize: 16.0);
                      setState(() {});
                    }
                  },
                ),
              ),

              // Text(
              //   'Select Service',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              // ),
              // Container(
              //   width: 200,
              //   height: 50,
              //   child: DropdownButton(
              //     borderRadius: BorderRadius.circular(8),
              //     isExpanded: true,
              //     hint: Text('Select'),
              //     value: dropdownvalue,
              //     items: servicetype.map((item) {
              //       return DropdownMenuItem(
              //         child: Text(
              //           item['servicetype'],
              //         ),
              //         value: item['servicetype'].toString(),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         dropdownvalue = value;
              //         print(dropdownvalue);
              //       });
              //       //print(value);
              //     },
              //   ),
              // ),
              // Container(
              //   height: 300,
              //   width: 350,
              //   child: future(),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(10),
              //         topRight: Radius.circular(10),
              //         bottomLeft: Radius.circular(10),
              //         bottomRight: Radius.circular(10)),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 5,
              //         blurRadius: 7,
              //         offset: Offset(0, 3),
              //       ),
              //     ],
              //   ),
              // ),

              // Row(
              //   children: [
              //     SizedBox(
              //       width: 7,
              //     ),
              //     Text(
              //       'Estimated Time',
              //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Container(
              //       width: 55,
              //       height: 30,
              //       child: TextField(
              //           readOnly: true,
              //           controller: estimatedtime,
              //           decoration:
              //               InputDecoration(border: OutlineInputBorder())),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text(
              //       'Estimated Price',
              //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     Container(
              //       width: 55,
              //       height: 30,
              //       child: TextField(
              //         controller: estimatedprice,
              //         readOnly: true,
              //         decoration: InputDecoration(border: OutlineInputBorder()),
              //       ),
              //     ),
              //   ],
              // ),

              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
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
                                Text("in progress..."),
                              ],
                            ),
                          );
                        });
                    if (datecontroller.text.isNotEmpty &&
                        timecontroller.text.isNotEmpty &&
                        noofperson.text.isNotEmpty) {
                      Navigator.pop(context);
                      modeldata.persons = noofperson.text;
                      Get.to(Searchsalons());
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please Fill All fields!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey[350],
                          textColor: Colors.black,
                          fontSize: 16.0);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Search'))
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.name),
              accountEmail: Text(widget.email),

              currentAccountPicture:
              Container(
                height: 80,
                width: 50,
decoration:  User.image!=null ?
 BoxDecoration(
  shape: BoxShape.circle,
//  borderRadius: BorderRadius.circular(5),
  image: DecorationImage(image: NetworkImage('http://'+IP.ip+'/SalonService'+User.image.toString()),fit:BoxFit.fill)
)

:BoxDecoration(
  shape: BoxShape.circle,
  // borderRadius: BorderRadius.circular(5),
  image: DecorationImage(image: AssetImage('assets/noimage.jpg'),fit:BoxFit.fill)
)
,

              )
              
          
            ),
            ListTile(
              title: const Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
                Get.to(userprofile());
              },
            ),
            ListTile(
              title: const Text('Appointment History'),
              leading: Icon(Icons.history_rounded),
              onTap: () {
                Navigator.pop(context);

                Get.to(bookinghistory());
              },
            ),
            ListTile(
              title: const Text('My Appointments'),
              leading: Icon(Icons.book_online),
              onTap: () {
                Navigator.pop(context);

                Get.to(appointment());
              },
            ),
            ListTile(
              title: const Text('Favorite Salons'),
              leading: Icon(Icons.favorite),
              onTap: () {
                Navigator.pop(context);
                Get.to(favoritesalons());
              },
            ),
            ListTile(
              title: const Text('Favorite Staff'),
              leading: Icon(Icons.favorite_border),
              onTap: () {
                Navigator.pop(context);
                Get.to(favoritestaff());
              },
            ),
             ListTile(
              title: const Text('Top Staffs'),
              leading: Icon(Icons.favorite_border),
              onTap: () {
                Navigator.pop(context);
                Get.to(Topstaff());
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.pop(context);
                Get.off(loginHome());
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Get.to(mulselectdemo());
      //   },
      //   label: Text('Search'),
      //   icon: Icon(Icons.search),
      // ),
    );
  }
 
     
}

class fetchedservice {
  var name;
  var time;
  var price;

  fetchedservice(this.name, this.time, this.price);
}
