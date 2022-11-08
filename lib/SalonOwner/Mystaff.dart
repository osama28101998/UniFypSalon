// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, unnecessary_new

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/SalonOwner/AddStaff.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';
import 'package:salon/user_model.dart';

class staff extends StatefulWidget {
  const staff({Key? key}) : super(key: key);

  @override
  State<staff> createState() => _staffState();
}

class _staffState extends State<staff> {
  late Future _future;
  var serviceid;
  List servicetype = [];
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

  @override
  Widget build(BuildContext context) {
    _future=Getmystaff(User.id,serviceid);
    return Scaffold(
        appBar: AppBar(
          title: Text('Staff'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Get.to(addstaff());
              },
              tooltip: 'Add Service',
            ),
            // add more IconButton
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.blueGrey, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton(
              focusColor: Colors.blue,
              //icon: Icon(Icons.abc),
              isExpanded: true,
              hint: const Text('Select Staff Type'),
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
           SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: future(),
              ),
            )

        ])
        )
        );


  }

         Widget future() {
    return FutureBuilder(
        future: _future,
        builder: (_context, AsyncSnapshot snapshot) {
          // print('here');
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: Text('No Staff found against selected category!'));
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
                                
                                leading: Image.network(
                                            
                                  ('http://' +
                                    IP.ip +
                                    '/SalonService' +
                                    data['staff_image'].toString()),
                                ),
                                title: Text((data['staff_fname']+' '+data['staff_lname']).toString().toUpperCase()),
                                subtitle: Text(data['join_time']+'-'+data['closing_time'].toString()),
                                //trailing: Text(data['join_time'].toString()),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  // const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () async {
                                      var id = data['u_id'];
                                      var msg =
                                          // await updateRequests(id.toString());
                                          setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(' Request of ' +
                                                    data['u_name'])));
                                        // print(msg);
                                      });
                                      print(id);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {},
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
              child: Text('No Staff Found Aganist this'),
            );
          }
        });
  }
}
