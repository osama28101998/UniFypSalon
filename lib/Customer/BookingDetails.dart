// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import, camel_case_types

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/Customer/confirmation.dart';
import 'package:salon/Customer/customermodel.dart';
import 'Salonprofile.dart';
// import 'package:salon/Barbers.dart';
// import 'package:salon/confirmation.dart';

class bookingdetails extends StatefulWidget {
  const bookingdetails({Key? key}) : super(key: key);

  @override
  State<bookingdetails> createState() => _bookingdetailsState();
}




class _bookingdetailsState extends State<bookingdetails> {


  int price = 0;
  int time=0;
  
void initState(){

   super.initState();
   
    for (var i = 0; i < modeldata.servicelist.length; i++) {
    price=price+modeldata.servicelist[i].sprice as int;
  }

  for (var i = 0; i < modeldata.servicelist.length; i++) {
    time=time+int.parse(modeldata.servicelist[i].time);
  }
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Details'),
        ),
        body: Column(children: [
          Container(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.only()),
                  child: Center(child: Image.asset('assets/salonprofile.jpg')),
                ),
                SizedBox(
                  height: 20,
                ),
               
                Container(
                  width: 500,
                  height: 200,
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.blue, width: 10),
                  //   borderRadius: BorderRadius.circular(5.0),
                  // ),
                  child: ListView.builder(
                      itemCount: modeldata.servicelist.length,
                      itemBuilder: (context, index) {
                        price =price+ modeldata.servicelist[index].sprice as int;
                        return Card(
                            color: Colors.blue,
                            elevation: 20,
                            child: ListTile(
                              title: Text(modeldata.servicelist[index].sname),
                              subtitle: Text(modeldata.servicelist[index].sprice
                                  .toString()),
                              trailing: Text(modeldata.servicelist[index].time),
                              leading: Icon(Icons.timer),

                              // leading: CircleAvatar(
                              //     backgroundImage: NetworkImage(
                              //         "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                            ));
                      }),
                ),
              ]))),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Total : '+'$price',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
             

               Text(
                'Estimated Time :' +' $time'+' min',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
             
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                
                 var date=modeldata.selecteddate.toString();
                 var splitteddate=date.split('-');
                 var timesplitted=modeldata.selectedtime[0].toString().split(':');
                DateTime dt=DateTime(int.parse(splitteddate[0]),int.parse(splitteddate[1]),int.parse(splitteddate[2]),int.parse(timesplitted[0]),int.parse(timesplitted[1]));
                var durationadd=dt.add(Duration(minutes: time));
            
                var completetime=durationadd.toString().split(' ');
                String ctime=completetime[1].toString();
                
               
                
      
    
       var mesg=await confirmbooking(time,ctime);
                print(mesg);
              if(mesg=='success')
              {
                Get.offAll(confirmation());
                

              }
                            },
              child: Text('Book'))
        ]));
  }
}
