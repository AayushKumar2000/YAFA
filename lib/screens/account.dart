import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yafa/providers/user.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    print(currentUser.user);

    return Container(
        padding: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Row(
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "${currentUser.user['name']}",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.8,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Divider(
              height: 0.5,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Order History',
                        style: TextStyle(color: Colors.black87, fontSize: 15.8),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 18.5, color: Colors.black54)
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              height: 0.5,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_none),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Notifications',
                        style: TextStyle(color: Colors.black87, fontSize: 15.8),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 18.5, color: Colors.black54)
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              height: 0.5,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'About',
                        style: TextStyle(color: Colors.black87, fontSize: 15.8),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 18.5, color: Colors.black54)
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              height: 0.5,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                children: [
                  Icon(Icons.logout),
                  TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.black87, fontSize: 15.0),
                      ))
                ],
              ),
            )
          ],
        ));
    ;
  }
}
