import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    return Container(
        child: Column(
      children: [
        Text('account'),
        SizedBox(
          height: 20.0,
        ),
        Text("user: ${user!.uid}"),
        TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text('Logout'))
      ],
    ));
    ;
  }
}
