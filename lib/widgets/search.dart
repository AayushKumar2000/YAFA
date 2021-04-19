import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:yafa/providers/checkConnectivity.dart';
import 'package:yafa/services/recent_search.dart';
import 'package:yafa/widgets/connectivityError.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/noResult.dart';
import 'package:flutter/material.dart';
import 'package:algolia_ns/algolia_ns.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yafa/widgets/recentSearchList.dart';

class Search extends SearchDelegate {
  final String searchFieldLabel = "Restaurant name, cuisine, or a dish";
  final TextStyle searchFieldStyle =
      TextStyle(fontSize: 14.0, color: Colors.grey[500]);

  List<AlgoliaObjectSnapshot> _results = [];
  late Algolia algolia;
  int counter = 0;
  late AlgoliaQuery queryAgolia;
  DatabaseRecentSearch dbSearch = DatabaseRecentSearch.instance;

  Search() {
    algolia = Algolia.init(
      applicationId: 'P7VJS2X8PX',
      apiKey: 'b08c42607241f55ef61893bfeb6146ae',
    );

    queryAgolia = algolia.instance.index('Restaurants');
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? [Container()]
        : [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            ),
          ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<CheckConnectivity>(
        builder: (context, checkConnectivity, child) {
      if (checkConnectivity.connectivity == ConnectivityResult.none)
        return ConnectivityError();
      if (query.isEmpty)
        return Text('');
      else
        return searchList();
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    counter++;
    return Consumer<CheckConnectivity>(
        builder: (context, checkConnectivity, child) {
      if (checkConnectivity.connectivity == ConnectivityResult.none)
        return ConnectivityError();
      else {
        if (query.isEmpty) {
          dbSearch.getData();
          if (counter < 3) {
            return spinkitLoading;
          } else
            return FutureBuilder<List<RecentSearch>>(
                future: dbSearch.getSearches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  ;
                  if (snapshot.hasError)
                    return Text('erorr: ${snapshot.error}');

                  return RecentSearchList(snapshot: snapshot.data!);
                });
        } else {
          return FutureBuilder(
            future: queryAgolia.search(query).getObjects(),
            builder: (BuildContext context,
                AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return spinkitLoading;

              if (snapshot.hasError) return Text('erorr');
              _results = snapshot.data!.hits!;
              if (_results.length == 0)
                return Container(
                  //padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Center(
                      child: NoResultFound(
                    primaryText: 'Opps!',
                    secondaryText: "No Result found for your query ",
                    secondaryBoldText: "'$query'",
                    secondaryText2: '\nTry rephrasing the query',
                  )),
                );
              else
                return searchList();
            },
          );
        }
      }
    });
  }

  Widget searchList() {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        String type =
            _results[index].data!['restaurantID'] != null ? "Dish" : "Outlet";
        String title = _results[index].data!['name'];
        String sub_title = _results[index].data!['place'] ?? type;
        return ListTile(
          title: Text(
            '$title',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(sub_title,
              style: TextStyle(fontSize: 15.0, color: Colors.grey[500])),
          onTap: () {
            RecentSearch search =
                RecentSearch(search_title: title, search_subTitle: sub_title);
            dbSearch.insertSearch(search);
          },
        );
      },
    );
  }
}
