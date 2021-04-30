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
    "Non Veg",
    "Online",
    "South Indian",
    "North Indian",
    "Fast Food",
    "Veg",
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
                bool chipSelected =
                    SelectedFilterNames.contains(filterList[index]);

                return Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                      labelPadding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
                      showCheckmark: false,
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.green[200],
                      labelStyle: TextStyle(
                          fontSize: 14.5,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: chipSelected
                              ? Colors.green[800]
                              : Colors.grey[700]),
                      label: Text(filterList[index]),
                      selected: chipSelected,
                      onSelected: (bool value) {
                        setState(() {
                          bool filterRemoved = false;

                          bool x =
                              SelectedFilterNames.contains(filterList[index]);

                          if (!x)
                            SelectedFilterNames.add(filterList[index]);
                          else {
                            SelectedFilterNames.remove(filterList[index]);
                            filterRemoved = true;
                          }

                          if (true) {
                            String filter = filterRemoved
                                ? filterList[index]
                                : SelectedFilterNames[
                                    SelectedFilterNames.length - 1];

                            filterList.remove(filter);
                            if (filterRemoved)
                              filterList.insert(
                                  SelectedFilterNames.length, filter);
                            else
                              filterList.insert(0, filter);
                            _controller.animateTo(-0,
                                curve: Curves.linear,
                                duration: Duration(milliseconds: 300));
                          }
                        });
                      }),
                );
              }),
        ),
        SizedBox(height: 10.0),
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
