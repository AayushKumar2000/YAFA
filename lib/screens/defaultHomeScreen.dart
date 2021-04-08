import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yafa/widgets/search.dart';
import 'package:yafa/widgets/vendorList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DefaultHomeScreen extends StatefulWidget {
  @override
  _DefaultHomeScreenState createState() => _DefaultHomeScreenState();
}

class _DefaultHomeScreenState extends State<DefaultHomeScreen> {
  late ScrollController _controller;

  List<String> SelectedFilterNames = [];
  List<String> filterList = [
    "Rating 4.0+",
    "Vegetarian",
    "Online",
    "South Indian",
    "North Indian",
    "Fast Food",
    "Continental",
    "Chines"
  ];
  @override
  void initState() {
    _controller = ScrollController();
    getDeviceToken();
    super.initState();
  }

  getDeviceToken() async {
    String token = (await FirebaseMessaging.instance.getToken())!;
    storeDeviceToken(token);
    print(token);
    FirebaseMessaging.instance.onTokenRefresh.listen(storeDeviceToken);
  }

  storeDeviceToken(String token) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var url = Uri.parse(
        'https://xqbjtrf7i5.execute-api.us-east-1.amazonaws.com/dev/addFcmToken');
    var res = await http.post(url,
        body: jsonEncode(<String, String>{
          'userID': '${auth.currentUser!.uid}',
          'fcmToken': '$token'
        }));
    print(res.statusCode);
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, bottom: 0.0, right: 10.0, left: 10.0),
      child: Column(children: [
        searchBar(context),
        SizedBox(
          height: 40.0,
          child: ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: filterList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      bool filterRemoved = false;

                      bool x = SelectedFilterNames.contains(filterList[index]);
                      print(x);
                      if (!x)
                        SelectedFilterNames.add(filterList[index]);
                      else {
                        SelectedFilterNames.remove(filterList[index]);
                        filterRemoved = true;
                      }
                      print("selected filter $SelectedFilterNames");
                      if (true) {
                        String filter = filterRemoved
                            ? filterList[index]
                            : SelectedFilterNames[
                                SelectedFilterNames.length - 1];

                        filterList.remove(filter);
                        if (filterRemoved)
                          filterList.insert(SelectedFilterNames.length, filter);
                        else
                          filterList.insert(0, filter);
                        _controller.animateTo(-0,
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 300));
                      }
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color:
                              (SelectedFilterNames.contains(filterList[index])
                                  ? Colors.green[200]
                                  : Colors.white)!,
                          border: Border.all(
                              color: (SelectedFilterNames.contains(
                                      filterList[index])
                                  ? Colors.green[600]
                                  : Colors.grey)!),
                          borderRadius: BorderRadius.circular(20.0)),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Text(filterList[index],
                          style: TextStyle(
                            fontFamily: '',
                            fontSize: 16.0,
                          ))),
                );
              }),
        ),
        SizedBox(height: 15.0),
        Expanded(child: VendorList(filterSelected: SelectedFilterNames))
      ]),
    );
  }
}

Widget searchBar(BuildContext context) {
  return GestureDetector(
    onTap: () {
      print("clicked");
      showSearch(context: context, delegate: Search());
    },
    child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(0.5, 1.0),
                blurRadius: 1.0,
                spreadRadius: 0.3)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search, color: Colors.green),
            Text('Restaurant name, cuisine, or a dish...',
                style: TextStyle(fontSize: 15.0, color: Colors.grey[500])),
          ],
        )),
  );
}
