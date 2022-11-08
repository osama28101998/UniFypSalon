// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:salon/Barbers.dart';
// import 'package:salon/currentlocation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Barbers.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/SalonReviews.dart';
import 'package:salon/Customer/customermodel.dart';

class salonprofile extends StatefulWidget {
  const salonprofile({Key? key}) : super(key: key);

  @override
  State<salonprofile> createState() => _salonprofileState();
}

class _salonprofileState extends State<salonprofile> {
  late Future _future;
  var salonname = '';
  var image;
  // var rating;
  double salonrating = 0;
  List<double> rating = [];
  getsalonname() async {
    var dio = Dio();
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Customer/salonprofile?id=' +
        modeldata.selectedsalonid.toString();
    var response = await dio.get(url);
    print(response.data);
    setState(() {
      print(response.data);
      print(response.data[0]['name']);
      salonname = response.data[0]['name'].toString();
      image = response.data[0]['image'].toString();
    });
  }

  getsalonrating() async {
    var dio = Dio();
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Customer/salonprofilerating?id=' +
        modeldata.selectedsalonid.toString();
    var response = await dio.get(url);
    setState(() {
      rating.clear();
      var res = response.data;
      for (var i = 0; i < res.length; i++) {
        rating.add(res[i]['salonrating']);
      }

      salonrating = rating.fold(
          0, (salonrating, element) => salonrating + element / rating.length);

      // rating=res.map((m) => m['salonrating']!).average;
      // print(rating.toString());
      // print(rating.toString());
    });
  }

  void initState() {
    super.initState();
    this.getsalonname();
    this.getsalonrating();
  }

  @override
  Widget build(BuildContext context) {
    _future = getsalonservices();
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Profile'),
        actions: [
          Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: 
      
      GestureDetector(
        onTap: () {
          Get.to(salonreviews());
        },
        child: Icon(
          Icons.reviews_sharp,
          size: 26.0,
        ),
      )
    ),
         // TextButton.icon(onPressed: (){}, icon: Icon(Icons.reviews), label: Text('Salon Reviews'))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.only()),
                    child: Center(
                        child: image != null
                            ? Image.network('http://' +
                                IP.ip +
                                '/SalonService' +
                                image.toString())
                            : Center(child: CircularProgressIndicator())),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          salonname,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        RatingBarIndicator(
                          rating: salonrating,
                          itemSize: 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    'Services :',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  // Center(child: Text('shop no 1 street 10 airport etc')),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Center(
                  //   child: RatingBarIndicator(
                  //     rating: 4,
                  //     itemSize: 30,
                  //      itemBuilder: (context, _) => Icon(
                  //       Icons.star,
                  //       color: Colors.amberAccent,
                  //     ),)
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Open',
                  //       style: TextStyle(color: Colors.green),
                  //     ),
                  //     SizedBox(width: 5),
                  //     Text(
                  //       '10.00 AM-9.00 PM',
                  //       style: TextStyle(color: Colors.black),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     FavoriteButton(
                  //       iconSize: 30,
                  //       valueChanged: (_isFavorite) {
                  //         print('Is Favorite $_isFavorite)');
                  //       },
                  //     )
                  //   ],
                  // ),
                  Container(
                    height: 250,
                    child: future(),
                  ),
                ],
              ),
            ),
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    if (modeldata.servicelist.length > 0 &&
                        modeldata.selectedservicetype.length > 0) {
                      Get.to(selecttime());
                    } else {
                      Fluttertoast.showToast(
                          msg: 'No service selected',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey[350],
                          textColor: Colors.black,
                          fontSize: 16.0);
                    }
                  },
                  child: Text('Next')),
            )
          ],
        ),
      ),
    );
  }

  Widget future() {
    return FutureBuilder(
        future: _future,
        builder: (_context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: Text('No Services!'));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext build, ind) {
                  Map data = snapshot.data[ind];

                  return Card(
                    elevation: 8,

                    shadowColor: Colors.black87,

                    //color: Color.fromARGB(255, 45, 188, 255),

                    child: Column(
                      //  mainAxisSize: MainAxisSize.min,

                      children: <Widget>[
                        ListTile(
                          leading: Image.network('http://' +
                              IP.ip +
                              '/SalonService' +
                              data['s_image'].toString()),
                          title: Text(data['s_name']),
                          subtitle: Text(data['stype_name']),
                          trailing: Text(data['s_price'].toString()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // const SizedBox(width: 8),

                            TextButton(
                              //'add'
                              child: Text(
                                modeldata.servicelist.any((element) =>
                                        element.sname == data['s_name'])
                                    ? 'Remove'
                                    : 'Choose',
                                // servicelist.contains(element)
                                style: TextStyle(
                                  color: modeldata.servicelist.any((element) =>
                                          element.sname == data['s_name'])
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                              onPressed: () async {
                                print(data['s_id']);
                                var result = await modeldata.servicelist.where(
                                    (a) =>
                                        a.sname == data['s_name'].toString());
                                setState(() {
                                  if (result.isEmpty) {
                                    modeldata.servicelist.add(service(
                                        data['s_name'],
                                        data['s_price'],
                                        data['estimated_time']));
                                    modeldata.selectedserviceid
                                        .add(data['s_id']);
                                    print(modeldata.selectedserviceid);

                                    print(modeldata.servicelist);

                                    modeldata.selectedservicetype
                                        .add(data['stype_id']);
                                    print(modeldata.selectedservicetype);
                                  } else {
                                    modeldata.servicelist.removeWhere(
                                        (element) =>
                                            element.sname == data['s_name']);
                                    modeldata.selectedservicetype
                                        .remove(data['stype_id']);
                                    modeldata.selectedserviceid
                                        .remove(data['s_id']);
                                    print(modeldata.selectedservicetype);
                                    print('sl' +
                                        modeldata.servicelist.length
                                            .toString());
                                    print('selctid:' +
                                        modeldata.selectedservicetype.length
                                            .toString());
                                  }
                                });
                              },
                            ),

                            //const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }
          else {
            // print('object');

            return const Center(
              child: Text('NoData'),
            );
          }
        });
  }
}
