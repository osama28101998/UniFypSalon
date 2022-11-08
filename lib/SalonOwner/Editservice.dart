// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:salon/Admin/ip.dart';
import 'package:salon/SalonOwner/serviceupdatemodel.dart';




class Editservices extends StatefulWidget {
  const Editservices({Key? key}) : super(key: key);

  @override
  State<Editservices> createState() => _EditservicesState();
}

class _EditservicesState extends State<Editservices> {

  TextEditingController name = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController price = TextEditingController();

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
  

  EditServices() async {
    

    String url = ('http://' +
        IP.ip +
        '/SalonService/api/Salonowner/Editservice?serviceid='+service.id+
        '&name='+
        name.text.toString() +
        '&time=' +
        time.text.toString() +
        '&price=' +
        price.text.toString());
    var dio = Dio();
   
    var response = await dio.post(url);
    return response.data;
  }

  void initState() {
    super.initState();
    name.text=service.name.toString();
    time.text=service.time.toString();
    price.text=service.price.toString();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Services'),
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
              CircleAvatar(radius: 100,backgroundImage: NetworkImage('http://' +
                                    IP.ip +
                                    '/SalonService' +service.image),),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Service Name',
                        hintText: 'Enter Service Name',
                        prefixIcon: Icon(Icons.design_services)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // height: 50,
                  child: TextField(
                    controller: time,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Time in minutes',
                        hintText: 'Enter Service Time',
                        prefixIcon: const Icon(Icons.timer)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // height: 50,
                  child: TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Service Price',
                        hintText: 'Enter Service price',
                        prefixIcon: const Icon(Icons.price_check)),
                  ),
                ),
               
                const SizedBox(height: 10),
                ElevatedButton.icon(
                    onPressed: () async {
                      if (name.text.isNotEmpty &&
                          time.text.isNotEmpty &&
                          price.text.isNotEmpty) {
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
                                    Text("Updating..."),
                                  ],
                                ),
                              );
                            });
                     

                        var mesg = await EditServices();
                        
                      
                       Navigator.pop(context);
                        Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                          }else{
                            Fluttertoast.showToast(
                              msg: 'Please Fill All Fields',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                          }
                    },
                    icon: const Icon(Icons.update),
                    label: const Text('Update')),
                
              ],
            ),
          ),
        ),
      ),
     
    );
  }

 

}
