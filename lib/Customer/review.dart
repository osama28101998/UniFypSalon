// ignore_for_file: prefer_const_constructors, camel_case_types, curly_braces_in_flow_control_structures



import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/menuscreen.dart';
import 'package:salon/Customer/reviewmodel.dart';
import 'package:salon/user_model.dart';

class review extends StatefulWidget {
  const review({Key? key}) : super(key: key);

  @override
  State<review> createState() => _reviewState();
}

class _reviewState extends State<review> {
  TextEditingController staffdescription = TextEditingController();
  TextEditingController salondescription = TextEditingController();
  var staffrating;
  var salonrating;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Review'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Center(
                  child: Text(
                'Please Give Us Your Suggestions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 30,
              ),
              Text(
                'Staff Name : ' +
                    reviewmodel.barbername.toString().toUpperCase(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Staff Rating ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amberAccent,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      reviewmodel.staffrating = rating;
                      print(staffrating);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 3,
                  controller: staffdescription,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      hintText: 'Write a review',
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description)),
                ),
              ),
              Text(
                'Salon Name : ' +
                    reviewmodel.salonname.toString().toUpperCase(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                ' Salon Rating ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amberAccent,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      reviewmodel.salonrating = rating;
                      print(salonrating);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 3,
                  controller: salondescription,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      hintText: 'Write a review',
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description)),
                ),
              ),
              ElevatedButton(
                  onPressed: () async{
                    var staffdes = staffdescription.text.toString();
                    var salondes = salondescription.text.toString();

                    if (staffdes.isNotEmpty && salondes.isNotEmpty)
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
                                  Text("Providing Feedback..."),
                                ],
                              ),
                            );
                          });
                    var mesg = await makereview(staffdes, salondes);

                    if (mesg != '') {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: mesg.toString(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey[350],
                          textColor: Colors.black,
                          fontSize: 16.0);
                    }
                    Get.off(MyHomePage(email: User.email, name: User.name, role: User.role));
                  },
                  child: Text('Review'))
            ],
          ),
        ),
      ),
    );
  }
}
