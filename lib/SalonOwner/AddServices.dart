// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as GET;
import 'package:image_picker/image_picker.dart';
import 'package:salon/Admin/admin_methods.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';
import 'package:http/http.dart' as http;
import 'package:salon/user_model.dart';

// import 'package:salon/AddStaff.dart';
// import 'package:salon/Myservices.dart';
// import 'package:salon/Mystaff.dart';
// import 'package:salon/Salonownermain.dart';

class addservices extends StatefulWidget {
  const addservices({Key? key}) : super(key: key);

  @override
  State<addservices> createState() => _addservicesState();
}

class _addservicesState extends State<addservices> {
  late var data;
  List servicetype = [];
  var stypeid;
  File? image;
  final picker = ImagePicker();
  TextEditingController servicenamecontroller = TextEditingController();
  TextEditingController servicetimecontroller = TextEditingController();
  TextEditingController servicepricecontroller = TextEditingController();

  var mesg;
  // Future<String> getservicetype() async {
  //   String url =
  //       ('http://' + IP.ip + '/SalonService/api/Salonowner/Allservicetypes?id=')
  //           .toString();
  //   var result = await http.get(Uri.parse(url));
  //   var resbody = jsonDecode(result.body);
  //   setState(() {
  //     servicetype = resbody;
  //   });

  //   return 'succcess';
  // }
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
    });
    print(result.statusCode);
    return result.data;
  }

  AddService() async {
    

    String url = ('http://' +
        IP.ip +
        '/SalonService/api/Salonowner/Addservice?typeid=' +
        stypeid.toString()+
        '&name=' +
        servicenamecontroller.text.toString() +
        '&time=' +
        servicetimecontroller.text.toString() +
        '&price=' +
        servicepricecontroller.text.toString() +
        '&salonid=' +
        User.id.toString());
    var dio = Dio();
    print(url.toString());
    print(image!.path.toString());
    var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(image!.path.toString())});
    var response = await dio.post(url, data: formData);
    
    mesg = response.statusCode;
    return response.data;
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
        title: const Text('Add Services'),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     Get.offAll(() => ());
        //   },
        // ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Container(
                  // width: 330,
                  // height: 150,
                  padding:
                      //  EdgeInsets.fromLTRB(10, 10, 10, 10),
                      const EdgeInsets.all(6),
                  //const EdgeInsets.symmetric(horizontal: 10.0),

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
                    hint: const Text('Select Service Type'),
                    items: servicetype.map((item) {
                      return DropdownMenuItem(
                        child: Text(
                          item['stype_name'],
                        ),
                        value: item['stype_id'].toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        stypeid = value.toString();
                        print(stypeid.toString());
                      });
                    },
                    value: stypeid,
                    underline: DropdownButtonHideUnderline(child: Container()),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextField(
                    controller: servicenamecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Service Name',
                        hintText: 'Enter Service Name',
                        prefixIcon: Icon(Icons.person)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // height: 50,
                  child: TextField(
                    controller: servicetimecontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Time in minutes',
                        hintText: 'Enter Service Time',
                        prefixIcon: const Icon(Icons.punch_clock)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // height: 50,
                  child: TextField(
                    controller: servicepricecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Service Price',
                        hintText: 'Enter Service price',
                        prefixIcon: const Icon(Icons.price_change)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: image.toString() != 'null'
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(image!),
                                ),
                              ))
                          : Container(
                              height: 100,
                              width: 100,
                              child: Icon(Icons.image),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                shape: BoxShape.circle,
                              )),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                    onPressed: () async {
                      if (servicenamecontroller.text.isNotEmpty &&
                          servicetimecontroller.text.isNotEmpty &&
                          servicepricecontroller.text.isNotEmpty) {
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
                                    Text("Adding Service"),
                                  ],
                                ),
                              );
                            });
                     

                        var mesg = await AddService();
                        print(mesg);
                        if (mesg == 'Already Exist') {
                          Navigator.pop(context);

                          Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                        } else if (mesg != 'Already Exist') {
                          setState(() {
                            Navigator.pop(context);
                           Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);

                            print(mesg);
                          });
                        }
                      } else {
                        Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add')),
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        imgFromGallery();
                      },
                      child: Text('Upload image')),
                ),
              ],
            ),
          ),
        ),
      ),
     
    );
  }

 

}
