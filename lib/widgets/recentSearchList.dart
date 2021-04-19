import 'package:flutter/material.dart';
import 'package:yafa/services/recent_search.dart';

class RecentSearchList extends StatefulWidget {
  @override
  _RecentSearchListState createState() => _RecentSearchListState();
  List<RecentSearch> snapshot;
  RecentSearchList({required this.snapshot});
}

class _RecentSearchListState extends State<RecentSearchList> {
  DatabaseRecentSearch dbSearch = DatabaseRecentSearch.instance;
  late List<RecentSearch> snapshot;

  void initState() {
    super.initState();
    snapshot = widget.snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          RecentSearch search = snapshot[index];
          return ListTile(
            leading: Icon(Icons.history_rounded),
            title: Text(
              '${search.search_title}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('${search.search_title}',
                style: TextStyle(fontSize: 15.0, color: Colors.grey[500])),
            trailing: IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: () {
                dbSearch.removeSearch(search.search_title);
                setState(() {
                  snapshot.remove(search);
                });
              },
            ),
            onTap: () {},
          );
          ;
        });
  }
}
