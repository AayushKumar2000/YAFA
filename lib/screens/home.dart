import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:yafa/providers/user.dart';
import 'package:yafa/screens/account.dart';
import 'package:yafa/screens/bookmark.dart';
import 'package:yafa/screens/defaultHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:yafa/screens/login.dart';
import 'package:yafa/widgets/test.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget SelectedHomeScreen() {
    switch (_selectedIndex) {
      case 0:
        return DefaultHomeScreen();
        break;
      case 1:
        return BookMarkScreen();
        break;
      case 2:
        return Account();
        break;
      default:
        return Container();
    }
  }

  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("init message $message");
      if (message != null) Navigator.pushNamed(context, '/test');
    });

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    // Also handle any interaction when the app is in the background via a
    // Stream listener

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("remote message $message");

      if (message != null) Navigator.pushNamed(context, '/test');
      // Navigator.push(
      //     context, new MaterialPageRoute(builder: (context) => new Test()));
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    print(11111111);
    Provider.of<CurrentUser>(context, listen: false).getUser();

    return Scaffold(
        body: SafeArea(
          child: SelectedHomeScreen(),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            iconSize: 30.0,
            unselectedFontSize: 14.0,
            selectedFontSize: 14.0,
            onTap: _onTap,
            selectedItemColor: Colors.green[600],
            elevation: 10,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark),
                  label: 'BookMark',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box_rounded),
                  label: 'Account',
                  backgroundColor: Colors.white)
            ]));
  }
}
