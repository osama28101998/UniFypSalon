// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';

class addseats extends StatefulWidget {
  const addseats({Key? key}) : super(key: key);

  @override
  State<addseats> createState() => _addseatsState();
}

class _addseatsState extends State<addseats> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Seats'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Seat Code',
                    hintText: 'Seat Code',
                    prefixIcon: Icon(Icons.chair_rounded)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              child: TextField(
                controller: descriptioncontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () async{
            
              var seatcode=namecontroller.text;
              var description=descriptioncontroller.text;
              if(seatcode.isNotEmpty && description.isNotEmpty)
              {
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
                                    Text("Adding..."),
                                  ],
                                ),
                              );
                            });
              var mesg=await Addsalonseats(seatcode, description);
                Navigator.pop(context);
                Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
              }else
              {
                Navigator.pop(context);
                  Fluttertoast.showToast(
                              msg: 'Fill All Fields',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
              }
            }, child: Text('Add Seat'))
          ],
        ),
      ),
    );
  }
}
