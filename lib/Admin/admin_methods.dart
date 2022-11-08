import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/user_model.dart';

getAllRequests() async{
  
  var dio=Dio();
  String url=('http://'+IP.ip+'/SalonService/api/User/salonrequests').toString();
  var result=await dio.get(url);

 
 return result.data as List;
}

updateRequests(var id) async{

 var dio=Dio();
  String url=('http://'+IP.ip+'/SalonService/api/User/updaterequest?id='+id).toString();
  var result= await dio.get(url);
  return result.data;
}


acceptedRequests() async{

var dio=Dio();
  String url=('http://'+IP.ip+'/SalonService/api/User/Acceptedrequests').toString();
  var result= await dio.get(url);
  return result.data;
}

sendnotification(var id )async{
 var description='Your Request has been accepted now you can set up your salon .';
 var isread='unread';
  var dio=Dio();
  String url=('http://'+IP.ip+'/SalonService/api/User/addnotification?description='+description+'&isread='+isread.toString()+'&id='+id.toString()).toString();
  print(url);
  var result=await dio.post(url);
  print(result.data);
  return result.data;


}



editprofile(var name,var password,var phone)async{

   var dio = Dio();

    String url = ('http://' +
            IP.ip +
            '/SalonService/api/User/AdminProfile?id=' +
            User.id.toString() +
            '&name=' +
            name.toString() +
            '&password=' +
            password.toString() +
            '&phone=' +
            phone.toString())
        .toString();

  var result=await dio.post(url);
  return result.data;
}
