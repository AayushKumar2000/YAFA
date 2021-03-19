import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/noResult.dart';
import 'package:flutter/material.dart';
import 'package:algolia_ns/algolia_ns.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Search extends SearchDelegate {
  final String searchFieldLabel = "Restaurant name, cuisine, or a dish";
  final TextStyle searchFieldStyle =
      TextStyle(fontSize: 14.0, color: Colors.grey[500]);

  List<AlgoliaObjectSnapshot> _results = [];
  late Algolia algolia;
  late AlgoliaQuery queryAgolia;

  Search() {
    algolia = Algolia.init(
      applicationId: 'P7VJS2X8PX',
      apiKey: 'b08c42607241f55ef61893bfeb6146ae',
    );

    queryAgolia = algolia.instance.index('Restaurants');
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
    ;
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty)
      return Text('');
    else
      return FutureBuilder(
        future: queryAgolia.search(query).getObjects(),
        builder: (BuildContext context,
            AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return spinkitLoading;

          if (snapshot.hasError) return Text('erorr');
          _results = snapshot.data!.hits!;
          print(snapshot.data!.hits!.length);
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
            return ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                String type = _results[index].data!['restaurantID'] != null
                    ? "Dish"
                    : "Outlet";
                return Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${_results[index].data!['name']}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text('${_results[index].data!['place'] ?? type}',
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.grey[500])),
                    ],
                  ),
                );
              },
            );
        },
      );
  }
}
