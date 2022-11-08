// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon/SalonOwner/salonowner_methods.dart';
import 'package:geocoding/geocoding.dart';

class salonlocation extends StatefulWidget {
  const salonlocation({Key? key}) : super(key: key);

  @override
  State<salonlocation> createState() => _salonlocationState();
}

class _salonlocationState extends State<salonlocation> {
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

  late GoogleMapController googlemapcontroller;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(33.5651, 73.0169), zoom: 14);
  Set<Marker> markers = {};
  TextEditingController latcontroller = TextEditingController();
  TextEditingController lngcontroller = TextEditingController();
  TextEditingController address = TextEditingController();
  var lat;
  var lng;
  var addres;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  child: TextField(
                    readOnly: true,
                    controller: latcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //labelText: '',
                        hintText: ' latitude',
                        prefixIcon: Icon(Icons.edit_location_sharp)),
                  ),
                ),
                Container(
                  width: 150,
                  child: TextField(
                    readOnly: true,
                    controller: lngcontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //labelText: '',
                        hintText: 'longitude',
                        prefixIcon: Icon(Icons.edit_location_sharp)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 330,
              child: TextField(
                readOnly: true,
                controller: address,
                
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: '',
                  hintText: 'Address',
 prefixIcon: Icon(Icons.edit_location_sharp)
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: 400,
              height: 390,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googlemapcontroller = controller;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      Position position = await _determinepos();
                      lat = position.latitude.toString();
                      lng = position.longitude.toString();

                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              double.parse(lat), double.parse(lng));
                        
                      print(addres);
                      latcontroller.text = lat;
                      lngcontroller.text = lng;
                      addres=placemarks.reversed.last.thoroughfare.toString()+','+placemarks.reversed.last.subLocality.toString()+','+placemarks.reversed.last.locality.toString();
                      address.text=addres.toString();
                      googlemapcontroller.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target:
                                  LatLng(position.latitude, position.longitude),
                              zoom: 14)));

                      markers.clear();
                      markers.add(Marker(
                          markerId: MarkerId('My Location'),
                          position:
                              LatLng(position.latitude, position.longitude),
                          infoWindow: InfoWindow(title: 'You', onTap: () {})));

                      setState(() {});
                    },
                    icon: Icon(Icons.location_on),
                    label: Text('Get Location')),
                ElevatedButton.icon(
                    onPressed: () async {
                      if (latcontroller.text.isNotEmpty &&
                          lngcontroller.text.isNotEmpty) {
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
                                    Text("Please Wait..."),
                                  ],
                                ),
                              );
                            });
                        var mesg = await Savesalonlocation(lat, lng,addres);
                        if (mesg == 'This Location Already in use!') {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                        } else if (mesg == 'Location Added Successfully') {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: mesg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please set Latitute & Longitude',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[350],
                            textColor: Colors.black,
                            fontSize: 16.0);
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save Location'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
