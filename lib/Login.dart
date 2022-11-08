// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salon/Admin/Adminmain.dart';
import 'package:salon/Admin/ip.dart';
import 'package:salon/SalonOwner/Salonownermain.dart';
import 'package:salon/user_model.dart';
import 'package:salon/Signup.dart';
import 'package:salon/Customer/menuscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Admin/admin_tab_bar.dart';

var resbody;

class loginHome extends StatefulWidget {
  const loginHome({Key? key}) : super(key: key);

  @override
  State<loginHome> createState() => _loginHomeState();
}

class _loginHomeState extends State<loginHome> {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

 

  Future<void> login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
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
                  Text("Logging In"),
                ],
              ),
            );
          });
      var dio = Dio();
      var url = 'http://' + IP.ip + '/SalonService/api/User/Login';

      var response = await dio.post(url, data: {
        'u_email': emailController.text,
        'u_password': passwordController.text
      });
      //Navigator.pop(context);
      if (response.data.toString() == 'Email OR Password Invalid!') {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: response.data,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[350],
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (response.data != 'Email OR Password Invalid!') {
        resbody = response.data;
        User.name = resbody['u_name'];
        User.email = resbody['u_email'];
        User.role = resbody['role'];
        User.id = resbody['u_id'];
        User.status = resbody['status'];
        User.password = resbody['u_password'];
        User.phone = resbody['phone'];
        User.image = resbody['image'];
        if (User.role == "admin") {
          Get.offAll(AdminTab());
        } else if (User.role == "Customer") {
          Get.offAll(
              MyHomePage(name: User.name, email: User.email, role: User.role));
        } else if (User.role == "Salonowner") {
          User.id = resbody['u_id'];
          Get.offAll(ownerdashboard(
              name: User.name, email: User.email, role: User.role));
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Email or password is empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  // @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(title: Text('data')),
      
      body: 
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            
           Container(
        height: 660,
        width: 380,
        decoration: const BoxDecoration(
          image: DecorationImage(
         image: AssetImage('assets/bw.jpg'),
          fit: BoxFit.fitWidth),
         ),
        child:  Column(
          children: [
             SizedBox(height: 210,),
            Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 350.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          border: Border.all(
                            color: Colors.white,
                            //  width: 5.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          gradient:
                              LinearGradient(colors: [Color.fromARGB(255, 243, 250, 252), Color.fromARGB(255, 243, 250, 252)]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                offset: Offset(2.0, 2.0))
                          ]),
                      child: ListView(
                        children: <Widget>[
                       
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 20),
                              )),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextField(
                              obscureText: _isObscure,
                              controller: passwordController,
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
      
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                              height: 50,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: ElevatedButton(
                                child: const Text('Login'),
                                onPressed: () {
                                  
                                  login();
                           
                                },
                              )),
                          Row(
                            children: <Widget>[
                              const Text('Does not have account?'),
                              TextButton(
                                child: const Text(
                                  'Sign up Now !',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Get.to(signup());
      
                                  //                   Navigator.push( context,
                                  //                  MaterialPageRoute(builder: (context) => const signup()),
                                  // );
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
              
          ],
        ),
      ),
    );
  }

}
