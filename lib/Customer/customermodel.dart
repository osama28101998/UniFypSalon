

import 'package:salon/Customer/Salonprofile.dart';

class modeldata{

static var servicechoosen=[];
static var selectedsalonid;
static var selectedservicetype=[];
static var staffid;
static var staffname;
static List<String> selectedtime=[];
static var selecteddate;
static var persons;
static var seatstatus=[];
static var selectedseats=[];

static var selectedserviceid=[];
static var serviceselection=[];
 static var estimatedtime;

 static List<service> servicelist = [];

}




class service {
  var sname;
  var sprice;
  var time;

  service(this.sname, this.sprice, this.time);
  @override
  toString() {
    return '{ ${this.sname}, ${this.sprice},${this.time} }';
  }
}