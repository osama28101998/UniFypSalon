// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/customermodel.dart';



class staffreviews extends StatefulWidget {
  const staffreviews({ Key? key }) : super(key: key);

  @override
  State<staffreviews> createState() => _staffreviewsState();
}

class _staffreviewsState extends State<staffreviews> {

  getstaffreviews()async{
var dio=Dio();
String url='http://'+IP.ip+'/SalonService/api/Customer/seestaffreviews?staffid='+modeldata.staffid.toString();
var response=await dio.get(url);
return response.data;

  }

  void initState(){
super.initState();
// this.getstaffreviews();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(modeldata.staffname.toString()+' Reviews')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: future(),

      ),
      
    );
  }
  Widget future(){
 return FutureBuilder(
        future: getstaffreviews(),
        builder: (_context, AsyncSnapshot snapshot) {
          // print('here');
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext build, ind) {
                  Map data = snapshot.data[ind];
                  return Container(
                    height: 100,
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
                                leading:
                                
                                CircleAvatar(
                                  backgroundImage:NetworkImage(
                                              
                                    ('http://' +
                                      IP.ip +
                                      '/SalonService' +
                                      data['image'].toString()),
                                    
                                  ),
                                ),
                                title: Text((data['u_name'].toString().toUpperCase()),
                                    style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),
                                    ),
                                subtitle:
                                    Text(data['staff_description']),
                                trailing: RatingBarIndicator(
                                  rating:double.parse(data['staff_rating'].toString()),
                                     
                                  itemSize: 20,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amberAccent,
                                  ),
                                ),
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
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });


  }
}