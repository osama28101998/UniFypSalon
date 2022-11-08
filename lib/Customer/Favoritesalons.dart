// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Customer_methods.dart';



class favoritesalons extends StatefulWidget {
  const favoritesalons({ Key? key }) : super(key: key);

  @override
  State<favoritesalons> createState() => _favoritesalonsState();
}

class _favoritesalonsState extends State<favoritesalons> {
  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future=getmyfavoritesalon();
    return Scaffold(
      appBar: AppBar(title:Text('Favorite Salons')),
      body: Column(children: [
   
 FutureBuilder(
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
                              data['image'].toString()),
                          title: Text((data['u_name']).toString().toUpperCase()),
                          subtitle:Text(data['address']), 
                          trailing:Text('Phone :'+ data['phone']),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // const SizedBox(width: 8),

                            TextButton(
                              //'add'
                              child: Text(
                               'Remove from favorites',
                                // servicelist.contains(element)
                                style: TextStyle(
                                  color:
                                       Colors.green,
                                ),
                              ),
                              onPressed: () async {
                                var id=data['FS_ID'].toString();
                              var mesg=await removefavoritesalon(id);
                               Fluttertoast.showToast(
          msg: mesg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
                              setState(() {
                                
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
        })
      ],),
    );
  }
}