import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email;
  var pass;
  var no;
  var name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Container(
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
                    hintText: "Enter your  Name ",
                    hintStyle: TextStyle(color: Colors.lightBlue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
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
                    hintText: "Enter your Email",
                    hintStyle: TextStyle(color: Colors.lightBlue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '+91',
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          no = "+91" + val;
                        },
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.white),
                        autofocus: false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "Enter your Phone Number",
                          hintStyle: TextStyle(color: Colors.lightBlue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Material(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(50),
                elevation: 10,
                child: MaterialButton(
                  minWidth: 250,
                  onPressed: () {
                    try {
                      if (email != null && no != null && name != null)
                        Navigator.pushNamed(context, "/otp", arguments: {
                          "number": no,
                          "name": name,
                          "email": email
                        });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("Login"),
                ),
              ),
            ],
          )),
    );
    ;
  }
}
