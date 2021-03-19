import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafa/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:yafa/screens/login.dart';

class otp extends StatefulWidget {
  @override
  _otpState createState() => _otpState();
}

var phone;
var verificationCode;

// ignore: camel_case_types
class _otpState extends State<otp> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  // ignore: close_sinks
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> phoneno =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    phone = phoneno['number'];
    print(phone);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("OTP Authetication"),
      ),
      body: Column(
        children: [
          Container(
            //alignment: Alignment.center,
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                "OTP sent to $phone\n               Please verify",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              withCursor: true,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await authc
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      print("pass to home");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  scaffoldkey.currentState!.showSnackBar(SnackBar(
                    content: Text("Invalid OTP"),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  verifyPhone(phone) async {
    await authc.verifyPhoneNumber(
      phoneNumber: "$phone",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await authc.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            print("user logged in");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      verifyPhone(phone);
    });
  }
}
