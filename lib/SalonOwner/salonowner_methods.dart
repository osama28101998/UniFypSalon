import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/user_model.dart';

import '../Admin/ip.dart';

AddServicetype(String servicetype) async {
  var dio = Dio();
  String url = ('http://' +
          IP.ip +
          '/SalonService/api/Salonowner/Addservicetype?id=' +
          servicetype)
      .toString();
  var response = await dio.post(url, data: {
    'stype_name': servicetype,
    'salon_id': User.id,
  });
  var result = response.data;
  return result.toString();
}

Getservicetypes() async {
  var dio = Dio();
  String url =
      ('http://' + IP.ip + '/SalonService/api/Salonowner/Allservicetypes')
          .toString();
  var response = await dio.get(url);
  var result = response.data;
  return result;
}

Getmyservices(var id, var serviceid) async {
  var dio = Dio();
  print('here' + id.toString());
  String url = ('http://' +
          IP.ip +
          '/SalonService/api/Salonowner/myservice?id=' +
          id.toString() +
          '&typeid=' +
          serviceid.toString())
      .toString();
  print(url);
  var result = await dio.get(url);
  print(result.statusCode);
  return result.data;
}

Getmystaff(var id, var serviceid) async {
  var dio = Dio();
  print('here' + id.toString());
  String url = ('http://' +
          IP.ip +
          '/SalonService/api/Salonowner/mystaff?salonid=' +
          id.toString() +
          '&servicetypeid=' +
          serviceid.toString())
      .toString();
  var result = await dio.get(url);
  return result.data;
}

Savesalonlocation(var lat, var lng,var address) async {
  var dio = Dio();
  String url = ('http://' +
          IP.ip +
          '/SalonService/api/Salonowner/addsalonlocation?salonid=' +
          User.id.toString() +
          '&lat=' +
          lat +
          '&lng=' +
          lng+
          '&address='+
          address
          )
      .toString();
  var result = await dio.post(url);
  return result.data;
}


Addsalonseats(var seatcode,var description)async{

  var dio=Dio();
 String url = ('http://' +
          IP.ip +
          '/SalonService/api/Salonowner/addsalonseat?salonid=' +
          User.id.toString() +
          '&seatcode=' +
          seatcode +
          '&description=' +
          description).toString();

  var response=await dio.post(url);
  return response.data;
}



getmysalonseats()async{

  var dio=Dio();
  String url='http://'+IP.ip+'/SalonService/api/Salonowner/viewseats?id='+User.id.toString();
  var response=await dio.get(url);
  return response.data;
}


viewnotifications()async{

  var dio=Dio();
  String url='http://'+IP.ip+'/SalonService/api/Salonowner/viewnotification?id='+User.id.toString();
  var response=await dio.get(url);
  return response.data;

}

markasread(var id)async{

  var dio=Dio();
  String url='http://'+IP.ip+'/SalonService/api/Salonowner/markasread?id='+id.toString();
  var response=await dio.get(url);
  return response.data;

}







AddStaff(var fname, var lname,var serviceid, var jointime, var leavetime,File image) async {
    var dio = Dio();
    
    String url = 'http://' + IP.ip + '/SalonService/api/Salonowner/Addstaff?fname='+fname+'&lname='+lname+'&salonid='+User.id.toString()+'&stypeid='+serviceid+'&jointime='+jointime+'&leavetime='+leavetime;
    
     var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(image.path.toString())});
    var response = await dio.post(url, data: formData);
    return response.data;
  }



  getmysalonbookings()async{
  var dio=Dio();
  String url='http://'+IP.ip+'/SalonService/api/Salonowner/Appointments?salonid='+User.id.toString();
  var response=await dio.get(url);
  return response.data;
}

markcomplete(var bid)async{

  var dio=Dio();
  String url='http://'+IP.ip+'/SalonService/api/Salonowner/markcompletebooking?bid='+bid.toString();
  var response=await dio.post(url);
  return response.data;
}



































// getservicetype() async {
//   var dio=Dio();

//     String url =
//         ('http://' + IP.ip + '/SalonService/api/Salonowner/Allservicetypes?id='+User.id.toString()).toString();
//         print(url);
//     var result = await dio.get(url);
//     print(result.statusCode);
//     return result.data;  
//   }



// AddService(String typeid, String name, String time, String price,
//     String salonid) async {
//   var dio = Dio();
//   String url = ('http://' +
//           IP.ip +
//           '/SalonService/api/Salonowner/Addservice?typeid=' +
//           typeid +
//           '&name=' +
//           name +
//           '&time=' +
//           time +
//           '&price=' +
//           price +
//           '&salonid=' +
//           salonid)
//       .toString();
//   // http://192.168.10.10/SalonService/api/Salonowner/Addservice?typeid=1&name=faujicut&time=20&price=200
//   var response = await dio.post(url, data: {});
//   var result = response.data;
//   return result.toString();

// }







