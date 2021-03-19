import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp.dart';

// ignore: camel_case_types
class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

var authc = FirebaseAuth.instance;
var email;
var pass;
var no;
var name;

class _signupState extends State<signup> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: mysignup(context),
    );
  }
}

mysignup(context) {
  return Scaffold(
    //  resizeToAvoidBottomPadding: false,
    appBar: AppBar(
      title: Text("Signup Page"),
    ),
    body: signupbody(context),
  );
}

signupbody(context) {
  return Container(
      alignment: Alignment.center,
      height: double.infinity,
      width: double.infinity,
      padding:
          EdgeInsets.only(bottom: 10.0, left: 25.0, right: 25.0, top: 40.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/sky.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: ListView(
        children: [
          Container(
            width: 350,
            child: TextField(
              onChanged: (val) {
                name = val;
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              autofocus: false,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter your full name: ",
                hintStyle: TextStyle(color: Colors.lightBlue),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 350,
            child: TextField(
              onChanged: (val) {
                email = val;
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              autofocus: false,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter your Email ID",
                hintStyle: TextStyle(color: Colors.lightBlue),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 350,
            child: TextField(
              onChanged: (val) {
                no = val;
              },
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white),
              autofocus: false,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter your phone number: ",
                hintStyle: TextStyle(color: Colors.lightBlue),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 350,
            child: TextField(
              onChanged: (val) {
                pass = val;
              },
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(color: Colors.white),
              autofocus: false,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Enter your Passcode",
                hintStyle: TextStyle(color: Colors.lightBlue),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Material(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(50),
            elevation: 10,
            child: MaterialButton(
              minWidth: 350,
              onPressed: () {
                try {
                  if (email != null &&
                      pass != null &&
                      no != null &&
                      name != null)
                    Navigator.pushNamed(context, "/otp",
                        arguments: {"number": "{$no}"});
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Register"),
            ),
          ),
          SizedBox(height: 10),
          Material(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(50),
            elevation: 10,
            child: MaterialButton(
              minWidth: 175,
              onPressed: () {
                try {
                  Navigator.pushNamed(context, "/login");
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Already have an account ? Login Here"),
            ),
          ),
        ],
      ));
}
