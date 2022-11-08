// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salon/Admin/admin_methods.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Customer/Customer_methods.dart';
import 'package:salon/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class salonownerprofile extends StatefulWidget {
  const salonownerprofile({Key? key}) : super(key: key);

  @override
  State<salonownerprofile> createState() => _salonownerprofileState();
}

class _salonownerprofileState extends State<salonownerprofile> {
  File? image;
  final picker = ImagePicker();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isObscure = true;
   //var uimage = NetworkImage('http://' + IP.ip + '/SalonService' + User.image);

  void initState() {
    super.initState();
    name.text = User.name;
    email.text = User.email;
    password.text = User.password;
    phone.text = User.phone;
  }

  imgFromGallery() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null) {
        image = File(img.path.toString());
        print('image :' + image!.path.toString());
      } else {}
    });
  }

  updateprofile() async {
     var dio = Dio();

    String url = ('http://' +
            IP.ip +
            '/SalonService/api/User/UserProfile?id=' +
            User.id.toString() +
            '&name=' +
            name.text.toString() +
            '&password=' +
            password.text.toString() +
            '&phone=' +
            phone.text.toString())
        .toString();
   
    if(image!=null)
    {
    var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(image!.path.toString())});
    var response = await dio.post(url, data: formData);
   return response.data;
    }else{
       var res= editprofile(name.text.toString(), password.text.toString(), phone.text.toLowerCase());
       return res;
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Salon Profile'),
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  User.image.toString()!='null'
                      ? Container(
                          width: 200,
                          height: 190,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                    image: image == null
                                        ? DecorationImage(
                                            fit: BoxFit.scaleDown,
                                            image: NetworkImage('http://' + IP.ip + '/SalonService' + User.image))
                                        : DecorationImage(
                                            fit: BoxFit.scaleDown,
                                            image: FileImage(image!)
                                            ),
                              
                              )
                              ),
                              Positioned(
                                  bottom: 1,
                                  right: 98,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: IconButton(
                                          onPressed: () {
                                            imgFromGallery();
                                          },
                                          icon: Icon(Icons.camera_alt)))),
                            ],
                          ),
                        )
                      : Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: 
                            image==null ?
                            DecorationImage(
                                image: AssetImage('assets/admin.png'),
                                fit: BoxFit.scaleDown)
                                :
                                DecorationImage(
                                image: FileImage(image!),
                          ),
                          )
                        ),
                       ElevatedButton(onPressed: (){
                        imgFromGallery();
                       }, child: Text('Upload Photo')),
                  // child: CircleAvatar(
                  //   radius: 30,
                  //   backgroundImage: NetworkImage('http://' +IP.ip +'/SalonService' +User.image),
                  //   child: Stack(children: [
                  //     Align(
                  //         alignment: Alignment.center,
                  //         child: IconButton(
                  //             onPressed: () {},
                  //             icon: Icon(Icons.camera_alt_rounded))),
                  //   ]),
                  // ),

                  // image.toString() != 'null'
                  //     ? Container(
                  //         height: 100,
                  //         width: 46,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.blue),
                  //           shape: BoxShape.circle,
                  //           image: DecorationImage(
                  //             fit: BoxFit.cover,
                  //             image: FileImage(image!),
                  //           ),
                  //         ),
                  //         child: IconButton(
                  //           color: Colors.white,
                  //           onPressed: () {
                  //             imgFromGallery();
                  //           },
                  //           icon: Icon(Icons.camera_alt_sharp),
                  //         ),
                  //         alignment: Alignment.center,
                  //       )
                  //     : CircleAvatar(
                  //         radius: 58,
                  //         child: Stack(children: [
                  //           Align(
                  //               alignment: Alignment.topCenter,
                  //               child: IconButton(
                  //                 color: Colors.black,
                  //                 onPressed: () {
                  //                   imgFromGallery();
                  //                 },
                  //                 icon: Icon(Icons.camera_alt_sharp),
                  //               )),
                  //         ]),
                  //       ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: name,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.people)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      readOnly: true,
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      obscureText: _isObscure,
                      controller: password,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              )),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      maxLength: 11,
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone)),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Update'),
                        onPressed: () async {
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

                          var mesg = await updateprofile();

                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: mesg.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[350],
                              textColor: Colors.black,
                              fontSize: 16.0);
                        
                        setState(() {
                          
                        });
                        },
                      )),
                ],
              )),
        ));
  }
}
