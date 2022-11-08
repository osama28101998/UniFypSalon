// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';

class salonownernotifications extends StatefulWidget {
  const salonownernotifications({Key? key}) : super(key: key);

  @override
  State<salonownernotifications> createState() =>
      _salonownernotificationsState();
}

class _salonownernotificationsState extends State<salonownernotifications> {
  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future=viewnotifications();
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: future(),
    );





  }



    Widget future() {
    return FutureBuilder(
        future: _future,
        builder: (_context, AsyncSnapshot snapshot) {
          // print('here');
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: Text('No notifations'));
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
                                
                                leading: Icon(Icons.notifications),
                                title: Text(data['description']),
                                subtitle: Text(data['isRead']),
                                //trailing: Text(data['isRead'].toString()),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  // const SizedBox(width: 8),
                                  data['isRead'].toString()=='unread'?
                                  TextButton(
                                    child: const Text(
                                      'Mark as Read',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () async {
                                       var id = data['notification_id'];
                                      
                                      var msg =await markasread(id.toString());
                                      
                                      // });
                                     // print(id);
                                    },
                                  ):Text('Readed'),
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
              child: Text('No Notifications'),
            );
          }
        });
  }


  

}
