import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/admin_methods.dart';
import 'package:salon/user_model.dart';
// import 'package:salon/Requests.dart';

class acceptedreq extends StatefulWidget {
  @override
  State<acceptedreq> createState() => _acceptedreqState();
}

class _acceptedreqState extends State<acceptedreq> {
  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future = acceptedRequests();

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
          if (snapshot.hasData) {
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
                        //color: Colors.lightBlueAccent,
                        child: Column(
                          //  mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Image.asset(
                                'assets/barber1.jpg',
                                height: 130,
                              ),
                              title: Text(data['u_email']),
                              subtitle: Text(data['role']),
                              trailing: Text(data['status']),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            // const SizedBox(width: 8),
                            // TextButton(
                            //   child: const Text('Accept'),
                            //   onPressed: () async {
                            //     var id = data['u_id'];
                            //     var msg =
                            //         await updateRequests(id.toString());
                            //     setState(() {
                            //       ScaffoldMessenger.of(context)
                            //           .showSnackBar(SnackBar(
                            //               content: Text(msg +
                            //                   ' Request of ' +
                            //                   data['u_name'])));
                            //       print(msg);
                            //     });
                            //     print(id);
                            //   },
                            // ),
                            // TextButton(
                            //   child: const Text('Reject'),
                            //   onPressed: () {},
                            // ),
                            //const SizedBox(width: 8),
                          ],
                        ),
                        // ],
                      ),
                      // ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
