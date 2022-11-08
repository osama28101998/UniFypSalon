// ignore_for_file: unnecessary_new, prefer_const_constructors, unused_local_variable, curly_braces_in_flow_control_structures, sized_box_for_whitespace, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salon/SalonOwner/AddServices.dart';
import 'package:salon/SalonOwner/Editservice.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';
import 'package:salon/SalonOwner/serviceupdatemodel.dart';
import 'package:salon/user_model.dart';

import '../Admin/ip.dart';

class mysalonservices extends StatefulWidget {
  const mysalonservices({Key? key}) : super(key: key);

  @override
  State<mysalonservices> createState() => _mysalonservicesState();
}

class _mysalonservicesState extends State<mysalonservices> {
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
    _future = Getmyservices(User.id, serviceid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(addservices());
            },
            tooltip: 'Add Service',
          ),
          // add more IconButton
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                hint: const Text('Select Service Type'),
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
              height: 10,
            ),
            SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Container(
               width: 400,
               height: 500,
                child: future(),
              ),
            )
          ],
        ),
      ),

      //   body: Container(
      //   height: MediaQuery.of(context).size.height,
      //   child:
      //   // future(),
      //   // ElevatedButton(onPressed: ()async{
      //   //  var res= await Getmyservices(User.id.toString());
      //   //  print(res);
      //   // }, child: Text('data'))

      // ),
    );
  }

  Widget future() {
    return FutureBuilder(
        future: _future,
        builder: (_context, AsyncSnapshot snapshot) {
          // print('here');
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: Text('No type selected!'));
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
                                leading: Image.network(('http://' +
                                    IP.ip +
                                    '/SalonService' +
                                    data['s_image'].toString())),
                                title: Text(
                                  data['s_name'].toString().toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(data['estimated_time'] + ' min',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                                trailing: Text(
                                    'Rs : ' + data['s_price'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
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
                                      service.id=data['s_id'].toString();
                                      service.name = data['s_name'].toString();
                                      service.time =
                                          data['estimated_time'].toString();
                                      service.price = data['s_price'];
                                      service.image =
                                          data['s_image'].toString();
                                          print(service.id);
                                      Get.to(Editservices());
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
              child: Text('No Type Selected!'),
            );
          }
        });
  }
}
