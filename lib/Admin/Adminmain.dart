// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/admin_methods.dart';
import 'package:salon/Login.dart';
import 'package:salon/user_model.dart';
// import 'package:salon/Requests.dart';



class adminmain extends StatefulWidget {
  String name;
  String email;
  String role;

  adminmain({required this.name, required this.email, required this.role});

  @override
  State<adminmain> createState() => _adminmainState();
}

class _adminmainState extends State<adminmain> {
  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future = getAllRequests();
    
    return Scaffold(
      
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: future(),
      ),
      );
  }

  Widget future() {
    return FutureBuilder(
        future: _future,
        builder: (_context, AsyncSnapshot snapshot) {
         // print('here');
          if (snapshot.hasData)
             if(snapshot.data.length == 0)
                {
                 return Center(child: Text('No more Pending Requests !'));
                }else
           {
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
                              leading: Image.asset(
                                'assets/barber1.jpg',
                                height: 130,
                              ),
                              title: Text(data['u_name']),
                              subtitle: Text(data['u_email']),
                              trailing: Text(data['role']),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('Accept',style: TextStyle(color: Colors.green),),
                                  onPressed: () async {
                                    var id = data['u_id'];
                                    var msg =
                                        await updateRequests(id.toString());

                                    var nmsg =await sendnotification(id.toString());
                                    print(nmsg);
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(msg +
                                                  ' Request of ' +
                                                  data['u_name'])));
                                      print(msg);
                                    });
                                    print(id);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Reject',style: TextStyle(color:Colors.red),),
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
                }
      
            );
          } else {
           // print('object');
            return const Center(
              
              child: Text('No pending Requests'),
            );
          }
        });
  }
}
