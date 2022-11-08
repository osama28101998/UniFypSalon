// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Customer_methods.dart';

class Topstaff extends StatefulWidget {
  const Topstaff({Key? key}) : super(key: key);

  @override
  State<Topstaff> createState() => _TopstaffState();
}

class _TopstaffState extends State<Topstaff> {
  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future = viewtopstaffs();
    return Scaffold(
      appBar: AppBar(title: Text('Top Staffs')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: _future,
                builder: (_context, AsyncSnapshot snapshot) {
                  // print('here');
                  if (snapshot.hasData) if (snapshot.data.length == 0) {
                    return Center(child: Text('No type selected!'));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
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
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                ('http://' +
                                                    IP.ip +
                                                    '/SalonService' +
                                                    data['staff_image']
                                                        .toString())),
                                          ),
                                          title: Text(
                                            (data['staff_fname'] +
                                                    ' ' +
                                                    data['staff_lname'])
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              'Speciality : ' +
                                                  data['stype_name']
                                                      .toString()
                                                      .toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                          trailing: RatingBarIndicator(
                                            rating: double.parse(data['rating'].toString()),
                                            itemSize: 20,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amberAccent,
                                            ),
                                          )),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: <Widget>[
                                      //     // const SizedBox(width: 8),
      
                                      //     //const SizedBox(width: 8),
                                      //   ],
                                      // ),
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
                      child: Text('No Type Selected!'),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
