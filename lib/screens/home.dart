import 'dart:io';

import 'package:yafa/screens/bookmark.dart';
import 'package:yafa/screens/defaultHomeScreen.dart';
import 'package:flutter/material.dart';

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
        return accountScreen();
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
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

Widget accountScreen() {
  return Container(child: Text('account'));
}
