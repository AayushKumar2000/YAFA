import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yafa/models/model_Vendor.dart';
import 'package:yafa/services/database_Vendor.dart';
import 'package:yafa/services/database_user.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/noResult.dart';
import 'package:yafa/widgets/vendorList.dart';
import 'package:yafa/widgets/vendorListTile.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<dynamic>? bookmarkList = null;

  @override
  void initState() {
    UserDatabase().getBookmarks().then((x) => {
          setState(() {
            bookmarkList = x.map((y) => y['restaurantID']).toList();
            print(bookmarkList);
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map query = ModalRoute.of(context)!.settings.arguments as Map;
    print(query['query']);
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
              future: VendorDatabase().getVendorForSearch(query['query']),
              builder: (context, AsyncSnapshot<List<VendorModel>> snapshot) {
                print(snapshot);
                if (snapshot.hasError) {
                  return NoResultFound(
                    primaryText: 'Oops! Something went wrong.',
                    secondaryBoldText: '',
                    secondaryText2: '',
                    secondaryText: 'Unable to fetch data from the server.',
                  );
                  ;
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return spinkitLoading;
                }
                print("no: ${snapshot.data!.length}");
                return Container(
                  child: Column(
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/foodapp-yafa.appspot.com/o/restaurants_Dominic%20Pizza.jpg?alt=media&token=a0699595-3cfd-4f62-8713-8eb94b6ee585'),
                                fit: BoxFit.cover)),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  alignment: Alignment.centerLeft,
                                  onPressed: () {
                                    Navigator.pop(context, null);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  query['query'],
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Restuarants which serves '${query['query']}",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.02),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return VendorListTile(
                                    vendor: snapshot.data![index],
                                    bookmarkList: bookmarkList);
                              }),
                        ),
                      )
                    ],
                  ),
                );
              })),
    );
  }
}
