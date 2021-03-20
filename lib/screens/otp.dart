import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafa/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:yafa/services/database_user.dart';

class otp extends StatefulWidget {
  @override
  _otpState createState() => _otpState();
}

// ignore: camel_case_types
class _otpState extends State<otp> {
  var phone;
  String verificationCode = "";
  late Map user;
  FirebaseAuth authc = FirebaseAuth.instance;
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
    user = ModalRoute.of(context)!.settings.arguments as Map;
    phone = user['number'];
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
                  await authc.signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: verificationCode, smsCode: pin));
                  UserDatabase().addUser(user['name'], user['email']);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                } on FirebaseAuthException catch (e) {
                  print("error1: $e");

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: new Text(phoneAuthErrorMessages(e.code)),
                    duration: new Duration(seconds: 5),
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
      timeout: const Duration(seconds: 10),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await authc.signInWithCredential(credential);
        UserDatabase().addUser(user['name'], user['email']);

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("error2: $e");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: new Text(phoneAuthErrorMessages(e.code)),
          duration: new Duration(seconds: 5),
        ));
      },
      codeSent: (String verificationID, int? resendToken) {
        this.verificationCode = verificationID;
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: new Text(
              ' SMS auto-retrieval times out, please enter the code manually'),
          duration: new Duration(seconds: 5),
        ));
        this.verificationCode = verificationID;
      },
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

  String phoneAuthErrorMessages(String code) {
    switch (code) {
      case "invalid-phone-number":
        return "The format of the phone number provided is incorrect";
        break;
      case "invalid-verification-code":
        return "Invalid Verification code";
        break;

      default:
        return "";
    }
  }
}
