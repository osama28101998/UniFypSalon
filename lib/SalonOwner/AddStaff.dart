// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';
import 'package:salon/user_model.dart';

class addstaff extends StatefulWidget {
  const addstaff({Key? key}) : super(key: key);

  @override
  State<addstaff> createState() => _addstaffState();
}

class _addstaffState extends State<addstaff> {
  File? image;
  final picker = ImagePicker();
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lnamecontroller = TextEditingController();
  TextEditingController jointimecontroller = TextEditingController();
  TextEditingController leavetimecontroller = TextEditingController();
  var serviceid;
  List servicetype = [];
  var jointime;
  var leavetime;
  var join;
  var leave;
  getservicetype() async {
    var dio = Dio();

    String url = ('http://' +
            IP.ip +
            '/SalonService/api/Salonowner/Allservicetypes?id=' +
            User.id.toString())
        .toString();
    print(url);
    var result = await dio.get(url);
    setState(() {
      servicetype = result.data;
      Fluttertoast.showToast(
          msg: 'Loaded',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[350],
          textColor: Colors.black,
          fontSize: 16.0);
    });
    print(result.statusCode);
    return result.data;
  }

  
  void initState() {
    super.initState();
    this.getservicetype();
  }

  imgFromGallery() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null) {
        image = File(img.path.toString());
        // print('image : '+img.path.toString());
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Staff'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                image.toString()=='null' ?
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 4),
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                          onPressed: () {
                            imgFromGallery();
                          },
                          icon: Icon(
                            Icons.camera_alt_sharp,
                            color: Colors.white,
                          ))),
                  alignment: Alignment.bottomRight,
                )
                :
                 Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(image!),
                                ),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 4),
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                          onPressed: () {
                            imgFromGallery();
                          },
                          icon: Icon(
                            Icons.camera_alt_sharp,
                            color: Colors.white,
                          ))),
                  alignment: Alignment.bottomRight,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // height: 50,
                  child: TextField(
                    controller: fnamecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Staff First Name',
                        hintText: 'First Name',
                        prefixIcon: Icon(Icons.emoji_people)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  // height: 50,
                  child: TextField(
                    controller: lnamecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Staff Last Name',
                        hintText: 'Last Name',
                        prefixIcon: Icon(Icons.emoji_people)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blueGrey,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton(
                    focusColor: Colors.blue,
                    //icon: Icon(Icons.abc),
                    isExpanded: true,
                    hint: const Text('Staff Speciality'),
                    items: servicetype.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(
                          item['stype_name'],
                        ),
                        value: item['stype_id'].toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        serviceid = value.toString();
                        print(serviceid.toString());
                      });
                    },
                    value: serviceid,

                    underline: DropdownButtonHideUnderline(child: Container()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  // height: 50,
                  child: TextField(
                    controller: jointimecontroller,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Joining time',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setState(() {
                              join = time.hour.toString() +
                                  ':' +
                                  time.minute.toString();
                              print(join);
                              jointime = time.format(context);
                              print(jointime);
                            });
                          }

                          jointime != null
                              ? jointimecontroller.text = jointime.toString()
                              : jointimecontroller.text =
                                  'No join time Selected';
                        },
                        icon: Icon(Icons.timer_rounded),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextField(
                    controller: leavetimecontroller,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Leave time',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setState(() {
                              leave = time.hour.toString() +
                                  ':' +
                                  time.minute.toString();

                              leavetime = time.format(context);
                              print(jointime);
                            });
                          }

                          leavetime != null
                              ? leavetimecontroller.text = leavetime.toString()
                              : leavetimecontroller.text =
                                  'No leave time Selected';
                        },
                        icon: Icon(Icons.timer_rounded),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                    onPressed: () async {
                      var fname = fnamecontroller.text.toString();
                      var lname = lnamecontroller.text.toString();

                      if (fname.isNotEmpty &&
                          lname.isNotEmpty &&
                          jointime.isNotEmpty &&
                          leavetime.isNotEmpty) {
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
                                    Text("Adding Staff"),
                                  ],
                                ),
                              );
                            });

                        var mesg =await AddStaff(fname, lname, serviceid, join, leave, image!);
                    print(mesg);
                    Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                     
                         
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please fill all fields',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[350],
                            textColor: Colors.black,
                            fontSize: 16.0);
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
