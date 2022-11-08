// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/customermodel.dart';



class salonreviews extends StatefulWidget {
  const salonreviews({ Key? key }) : super(key: key);

  @override
  State<salonreviews> createState() => _salonreviewsState();
}

class _salonreviewsState extends State<salonreviews> {

  getsalonreviews()async{
var dio=Dio();
String url='http://'+IP.ip+'/SalonService/api/Customer/seesalonreviews?salonid='+modeldata.selectedsalonid.toString();
var response=await dio.get(url);
 return response.data;

  }

  void initState(){
super.initState();
// this.getsalonreviews();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(' Salon Reviews')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: future(),

      ),
      
    );
  }
  Widget future(){
 return FutureBuilder(
        future: getsalonreviews(),
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
                                    Text(data['salon_description']),
                                trailing: RatingBarIndicator(
                                  rating:double.parse(data['salon_rating'].toString()),
                                     
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