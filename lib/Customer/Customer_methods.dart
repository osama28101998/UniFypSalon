// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:salon/Admin/admin_methods.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/customermodel.dart';
import 'package:salon/Customer/reschedulemodel.dart';
import 'package:salon/Customer/reviewmodel.dart';
import 'package:salon/user_model.dart';

getservices(var value) async {
  var dio = Dio();
  String url = ('http://' +
          IP.ip +
          '/SalonService/api/Customer/Viewservices?servicename=' +
          value.toString())
      .toString();
  var response = await dio.get(url);
  return response.data;
}

Showsalonlocations(var list) async {
  var url;
  var dio = Dio();

  var response = await dio.get(url);
  return response.data;
}

getsalonservices() async {
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/Customer/salonservices?id=' +
      modeldata.selectedsalonid.toString();
  var response = await dio.get(url);
  return response.data;
}

getsalonbarbers() async {
  var stypeid = modeldata.selectedservicetype;
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/Customer/Showbarbers?salonid=' +
      modeldata.selectedsalonid.toString();

  for (var item in stypeid) {
    url = url + '&stypeid=' + item.toString();
  }

  print(url);
  var response = await dio.get(url);
  return response.data;
}

getsalonseats() async {
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/Customer/viewsalonseats?salonid=' +
      modeldata.selectedsalonid;
  var response = await dio.get(url);
  return response.data;
}

confirmbooking(var duration, var endtime ) async {
  var dio = Dio();
  for (var item in modeldata.selectedserviceid) {
    String url = 'http://' +
        IP.ip +
        '/SalonService/api/Customer/booking?uid=' +
        User.id.toString() +
        '&salonid=' +
        modeldata.selectedsalonid.toString() +
        '&serviceid=' +
        item.toString() +
        '&staffid=' +
        modeldata.staffid.toString() +
        '&bookingdate=' +
        modeldata.selecteddate +
        '&seatid=' +
        modeldata.selectedseats[0].toString() +
        '&status=pending'+
        '&duration=' +
        duration.toString() +
        '&bookingdate=' +
        modeldata.selecteddate +
        '&time=' +
        modeldata.selectedtime[0]+'&endtime='+endtime.toString();

    var res = await dio.post(url);
    print(res.data);
  }

  return ('success');
}

getmybookings() async {
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/Customer/mybookings?id=' +
      User.id.toString();
  var response = await dio.get(url);
  return response.data;
}

reschedulebooking() async {
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/Customer/rescheduleappointment?id=' +
      reschedule.bookingid.toString() +
      '&date=' +
      reschedule.date.toString() +
      '&time=' +
      reschedule.selectedtime[0].toString();
  print(url);
  var response = await dio.post(url);
  return response.data;
}

getbookinghistory() async {
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/Customer/bookinghistory?id=' +
      User.id.toString();
  var response = await dio.get(url);
  return response.data;
}

makereview(var staffdes, var salondes) async {
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/Customer/makereview?salonid=' +
      reviewmodel.salonid.toString() +
      '&staffid=' +
      reviewmodel.barberid.toString() +
      '&staffdes=' +
      staffdes.toString() +
      '&salondes=' +
      salondes.toString() +
      '&staffrat=' +
      reviewmodel.staffrating.toString() +
      '&salonrat=' +
      reviewmodel.salonrating.toString() +
      '&customerid=' +
      User.id.toString()+
      '&bookingid='+
      reviewmodel.bookingid.toString()
      ;

  var response = await dio.post(url);
  return response.data;
}

updateprofile(var name, var password, var phone,File image) async {
  print('here :'+image.toString());
  var dio = Dio();
  String url = 'http://' +
      IP.ip +
      '/SalonService/api/User/UserProfile?id=' +
      User.id.toString() +
      '&name=' +
      name.toString() +
      '&password=' +
      password.toString() +
      '&phone=' +
      phone.toString();
      print(url);
      if(image!=null)
    {
    var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(image.path.toString())});
    var response = await dio.post(url, data: formData);
   return response.data;
    }else{
       var res= editprofile(name.text.toString(), password.text.toString(), phone.text.toLowerCase());
       return res;
    }
  
  }
 


   getmyfavoritestaffs()async{

    var dio=Dio();
    String url='http://'+IP.ip+'/SalonService/api/Customer/favortiestaff?userid='+User.id.toString();
    var response=await dio.get(url);
    return response.data;

   }


 getmyfavoritesalon()async{

    var dio=Dio();
    String url='http://'+IP.ip+'/SalonService/api/Customer/favortiesalon?userid='+User.id.toString();
    var response=await dio.get(url);
    return response.data;

   }


   addfavoritesalon(var salonid)async{
    var dio=Dio();
    String url='http://'+IP.ip+'/SalonService/api/Customer/addfavoritesalon?uid='+User.id.toString()+'&salonid='+salonid.toString();
    print(url);
   
    var response=await dio.post(url);
    return response.data;
       }
  addfavoritestaff(var staffid)async{
    var dio=Dio();
    String url='http://'+IP.ip+'/SalonService/api/Customer/addfavoritestaff?uid='+User.id.toString()+'&staffid='+staffid.toString();
    var response=await dio.post(url);
    return response.data;
       }


  removefavoritestaff(var staffid)async{
    var dio=Dio();
    String url='http://'+IP.ip+'/SalonService/api/Customer/removefavortiestaff?id='+staffid.toString();
    var response=await dio.get(url);
    return response.data;
       }


  removefavoritesalon(var id)async{
    var dio=Dio();
    String url='http://'+IP.ip+'/SalonService/api/Customer/removefavortiesalon?id='+id.toString();
    print(url);
    var response=await dio.get(url);
    return response.data;
       }




viewtopstaffs()async{
  var dio=Dio();
  String url='http://'+IP.ip+'/SalonService/api/Customer/topstaff';
  var response=await dio.get(url);
  return response.data;

}





class staffrating{
  var name;
  var rating;
  
  staffrating(this.name,this.rating);
   @override
  toString() {
    return '{ ${this.name}, ${this.rating} }';
  }
}
