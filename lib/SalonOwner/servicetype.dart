// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/SalonOwner/Salonownermain.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salon/user_model.dart';

class servicetype extends StatefulWidget {
  const servicetype({Key? key}) : super(key: key);

  @override
  State<servicetype> createState() => _servicetypeState();
}

class _servicetypeState extends State<servicetype> {
  TextEditingController stypecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service type'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.to(ownerdashboard(
                email: User.email, name: User.name, role: User.role));
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Container(
                // height: 50,
                child: TextField(
                  controller: stypecontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Service type',
                      hintText: 'Enter Service Type',
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 100,
                child: ElevatedButton.icon(
                    onPressed: () async {
                      var stype = stypecontroller.text.toString();
                      if (stype.toString() == '') {
                        //  ScaffoldMessenger.of(context)
                        //     .showSnackBar(SnackBar(content: Text('Field type is empty !')));
                        Fluttertoast.showToast(
                            msg: 'Filed is empty',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[350],
                            textColor: Colors.black,
                            fontSize: 16.0);
                      } else if (stype.toString() != '') {
                        var mesg = await AddServicetype(stype.toString());
                        setState(() {
                          Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);

                          //print(msg);0
                          stypecontroller.text = '';
                        });
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
