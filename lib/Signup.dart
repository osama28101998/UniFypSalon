// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/Login.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  @override
  var status='active';
  var selecteduser = 'Customer';
  final List<String> _users = ["Salonowner", "Customer"];
  late String _selectedGender = 'male';
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  Future<void> Signup() async {
    
    if (namecontroller.text.isNotEmpty &&
        emailcontroller.text.isNotEmpty &&
        passwordcontroller.text.isNotEmpty &&
        phonecontroller.text.isNotEmpty) {
      var dio = Dio();
      var url = 'http://' + IP.ip + '/SalonService/api/User/Signup';
      
      var response = await dio.post(url, data: {
        'u_name': namecontroller.text,
        'u_email': emailcontroller.text,
        'u_password': passwordcontroller.text,
        'gender': _selectedGender,
        'phone': phonecontroller.text,
        'role': selecteduser,
        'status': status,
      });
      if (response.statusCode == 200 &&
          response.data == "This Email Already Exist") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data)));
      } else if (response.statusCode == 200 &&
          response.data == "Successfully Created") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data)));
        Get.to(loginHome());
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please Fill All Credentials')));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Signup'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.offAll(() => loginHome());
            },
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: <Widget>[
                      Container(
                        // height: 50,
                        child: TextField(
                          controller: namecontroller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                              hintText: 'Enter Your Name',
                              prefixIcon: Icon(Icons.person)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextField(
                          controller: emailcontroller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Enter Your Email ',
                              prefixIcon: Icon(Icons.email)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextField(
                          obscureText: true,
                          controller: passwordcontroller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter Your Password',
                              prefixIcon: Icon(Icons.lock)),
                        ),
                      
                      ),
//                       FlutterPwValidator(
//     controller: passwordcontroller,
//     minLength: 6,
//     uppercaseCharCount: 2,
//     numericCharCount: 3,
//     specialCharCount: 1,
//     width: 400,
//     height: 150,
//     onSuccess:(){},
//     onFail: (){},
// ),
                      const SizedBox(height: 20),
                      Column(children: [
                        Row(
                          children: [
                            SizedBox(width: 50, child: Text('Gender:')),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'male',
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                        print(_selectedGender);
                                      });
                                    },
                                  ),
                                  //title: const Text('Male'),
                                  Expanded(
                                    child: Text('Male'),
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'female',
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                        print(_selectedGender);
                                      });
                                    },
                                  ),
                                  Expanded(child: Text('Female'))
                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),

                        // Row(

                        //   children: [
                        //     const Text('Please let us know your gender:'),
                        //     ListTile(
                        //       leading: Radio<String>(
                        //         value: 'male',
                        //         groupValue: _selectedGender,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             _selectedGender = value!;
                        //           });
                        //         },
                        //       ),
                        //       title: const Text('Male'),
                        //     ),
                        //     ListTile(
                        //       leading: Radio<String>(
                        //         value: 'female',
                        //         groupValue: _selectedGender,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             _selectedGender = value!;
                        //           });
                        //         },
                        //       ),
                        //       title: const Text('Female'),
                        //     ),
                        //     const SizedBox(height: 5),
                        //     // Text(_selectedGender == 'male' ? 'male!' : 'female!')
                        //   ],
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: phonecontroller,
                            maxLength: 11,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Phone No',
                                hintText: 'Enter Your Phone No',
                                prefixIcon: Icon(Icons.phone)),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'User type :',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButton(
                                value: selecteduser,
                                hint: const Text('Select User Type'),
                                items: _users.map((e) {
                                  return DropdownMenuItem(
                                      value: e, child: Text(e));
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selecteduser = value!;
                                    if (selecteduser == "Salonowner") {
                                      status = "deactive";
                                    } else {
                                      status = "active";
                                    }
                                    print(selecteduser);
                                    print(status);
                                  });
                                },
                                underline: DropdownButtonHideUnderline(
                                    child: Container()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          width: 500,
                          child: ElevatedButton(
                              onPressed: () {
                                Signup();
                              },
                              child: const Text('Signup')),
                        ),
                        TextButton(
                            child: const Text(
                              'Already have an account? Sign in',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                            onPressed: () {
                              Get.offAll(() => const loginHome());
                            })
                      ])
                    ])))));
  }
}
