import 'package:yafa/models/model_Vendor.dart';
import 'package:yafa/services/database_Vendor.dart';
import 'package:yafa/services/database_user.dart';
import 'package:yafa/widgets/noResult.dart';
import 'package:yafa/widgets/vendorListTile.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorList extends StatefulWidget {
  List<String> filterSelected = [];

  VendorList({required this.filterSelected});

  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList>
    with SingleTickerProviderStateMixin {
  late Stream<List<VendorModel>> VendorList;

  // ignore: avoid_init_to_null
  List<dynamic>? bookmarkList = null;

  @override
  void initState() {
    UserDatabase().getBookmarks().then((x) => {
          if (this.mounted)
            setState(() {
              bookmarkList = x.map((y) => y['restaurantID']).toList();
              print(bookmarkList);
            })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: VendorDatabase().VednorStream(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasError) {
          return NoResultFound(
            primaryText: 'Oops! Something went wrong.',
            secondaryBoldText: '',
            secondaryText2: '',
            secondaryText: 'Unable to fetch data from the server.',
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            bookmarkList == null) {
          return spinkitLoading;
        }
        print("f ${widget.filterSelected}");
        FilterList fl = FilterList(
            vendorList: snapshot.data as List<VendorModel>,
            filters: widget.filterSelected);
        print("filter list");

        List<VendorModel> vendorList = fl.filter();
        if (vendorList.length == 0)
          return NoResultFound(
            primaryText: 'Sorry, No Results found :(',
            secondaryText: 'Try again with few filters',
            secondaryBoldText: '',
            secondaryText2: '',
          );
        else
          return ListView.builder(
              itemCount: vendorList.length,
              itemBuilder: (context, index) {
                return VendorListTile(
                    vendor: vendorList[index], bookmarkList: bookmarkList);
              });
      },
    );
  }
}
