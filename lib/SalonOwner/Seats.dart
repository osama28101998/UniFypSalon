// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/SalonOwner/Addseat.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';

class salonseats extends StatefulWidget {
  const salonseats({Key? key}) : super(key: key);

  @override
  State<salonseats> createState() => _salonseatsState();
}

class _salonseatsState extends State<salonseats> {
  late Future _future;
  @override
  Widget build(BuildContext context) {
    _future = getmysalonseats();
    return Scaffold(
      appBar: AppBar(
        title: Text('Seats'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(addseats());
            },
            tooltip: 'Add Seats',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: future(),
        ),
      ),
    );
  }

  Widget future() {
    return FutureBuilder(
        future: _future,
        builder: (_context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) if (snapshot.data.length == 0) {
            return Center(child: Text('No Seats'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 100,
                  mainAxisSpacing: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext build, ind) {
                Map data = snapshot.data[ind];
                return InkWell(
                  onTap: () {
                    print(data["seat_id"]);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data["seat_code"],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                );
              },
            );
          }
          else {
            // print('object');
            return const Center(
              child:CircularProgressIndicator(),
            );
          }
        });
  }
}
