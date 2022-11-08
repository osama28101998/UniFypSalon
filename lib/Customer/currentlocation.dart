// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Salonprofile.dart';
import 'package:salon/Customer/customermodel.dart';
// import 'package:salon/Salonprofile.dart';
import 'package:salon/Customer/menuscreen.dart';
import 'package:salon/user_model.dart';

class Searchsalons extends StatefulWidget {
  @override
  State<Searchsalons> createState() => _SearchsalonsState();
}

class _SearchsalonsState extends State<Searchsalons> {
  getsalonlocations() async {
    var dio = Dio();
    var service = modeldata.servicechoosen;
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Customer/Showsalonservice?values=';
    if (service.length == 1) {
      url = url + service[0];
    } else if (service.length == 2) {
      url = url + service[0] + '&values=' + service[1];
    } else if (service.length == 3) {
      url =
          url + service[0] + '&values=' + service[1] + '&values=' + service[2];
    }

    var response = await dio.get(url);
    var result = response.data;
    markers.clear();
    for (var i = 0; i < result.length; i++) {
     
      
      markers.add(Marker(
          markerId: MarkerId(result[i]['salon_id'].toString()),
          position: LatLng(double.parse(result[i]['salon_lat']), double.parse(result[i]['salon_lng'])),
          infoWindow:
              InfoWindow(title: result[i]['salon_name'],
              
               onTap: () {
                modeldata.selectedsalonid=result[i]['salon_id'].toString();
                print(result[i]['salon_id'].toString());
                Get.to(salonprofile());
               
               })));
    }
  }

  late GoogleMapController googlemapcontroller;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(33.5651, 73.0169), zoom: 14);
  Set<Marker> markers = {};

  void initState() {
    super.initState();
    this.getsalonlocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.to(MyHomePage(
              name: User.name,
              email: User.email,
              role: User.role,
            ));
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googlemapcontroller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Position position = await _determinepos();
            googlemapcontroller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 14)));

           
            markers.add(Marker(
                markerId: MarkerId('My Location'),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: InfoWindow(title: 'You', onTap: () {})));
            // markers.add(Marker(
            //     markerId: MarkerId('Salon Dummy Location'),
            //     position: LatLng(33.6491, 73.0833),
            //     infoWindow: InfoWindow(
            //         title: 'ABC Salon',
            //         onTap: () {
            //          Get.to( salon());
            //         },
            //         snippet: "Hello"))
            //         );
            setState(() {});
          },
          child: Icon(Icons.location_searching)),
    );
  }

  Future<Position> _determinepos() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services Disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return Future.error('Location Permission Denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission Denied Permanantly');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
