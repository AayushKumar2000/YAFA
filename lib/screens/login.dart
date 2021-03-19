import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

var authc = FirebaseAuth.instance;
var email;
var pass;

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: mylogin(context),
      debugShowCheckedModeBanner: false,
    );
  }
}

mylogin(context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Login Page"),
    ),
    body: loginbody(context),
  );
}

loginbody(context) {
  return Container(
    alignment: Alignment.center,
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("images/sky.png"),
        fit: BoxFit.fill,
      ),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 350,
        child: TextField(
          onChanged: (val) {
            email = val;
          },
          style: TextStyle(color: Colors.white),
          autofocus: false,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "Enter registered phone number:",
            hintStyle: TextStyle(color: Colors.lightBlue),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
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
          style: TextStyle(color: Colors.white),
          autofocus: false,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "Enter your Passcode",
            hintStyle: TextStyle(color: Colors.lightBlue),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
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
          onPressed: () async {
            try {
              print(email);
              print(pass);
              var user = await authc.signInWithEmailAndPassword(
                  email: email, password: pass);
              if (user != null) {
                print('user created');
                Navigator.pushNamed(context, '/home');
              }
            } catch (e) {
              print(e);
              print('failed');
            }
          },
          child: Text("Submit"),
        ),
      ),
      SizedBox(height: 10),
      Material(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(50),
        child: MaterialButton(
          minWidth: 175,
          onPressed: () {
            try {
              Navigator.pushNamed(context, "/signup");
            } catch (e) {
              print(e);
            }
          },
          child: Text(
            "New User? Signup Here",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ]),
  );
}
