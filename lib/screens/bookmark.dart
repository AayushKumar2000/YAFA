import 'package:yafa/models/model_Vendor.dart';
import 'package:yafa/services/database_Vendor.dart';
import 'package:yafa/widgets/bookMark.dart';
import 'package:yafa/widgets/bookMarkTile.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/noResult.dart';
import 'package:flutter/material.dart';
import 'package:yafa/services/database_user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookMarkScreen extends StatefulWidget {
  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  // ignore: avoid_init_to_null
  List<dynamic>? bookmarkList = null;
  int length = 0;

  @override
  void initState() {
    UserDatabase().getBookmarks().then((x) => {
          setState(() {
            bookmarkList = x;
          })
        });

    super.initState();
  }

  void removeBookmarkFromList(bookmark) {
    setState(() {
      bookmarkList!.remove(bookmark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 12.0,
        top: 20.0,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'BookMarks',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              SizedBox(
                width: 10.0,
              ),
              Icon(Icons.bookmarks_rounded, color: Colors.green[600]),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          bookmarkList == null
              ? Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Center(child: spinkitLoading))
              : bookmarkList!.length == 0
                  ? Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                          child: NoResultFound(
                        primaryText: 'No Bookmarks Found',
                        secondaryText: 'Tap the bookmark icon to add it',
                        secondaryText2: '\n to your collection',
                        secondaryBoldText: '',
                      )),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: bookmarkList!.length,
                          itemBuilder: (context, index) {
                            //   return bookmarkTile(bookmarkList![index]);
                            return BookmarkTilel(
                                bookmark: bookmarkList![index],
                                removeBookmarkFromList: removeBookmarkFromList);
                          }),
                    ),
        ],
      ),
    );
  }

  // Widget bookmarkTile(Map bookmark) {
  //   double _scale = 1;

  //   return GestureDetector(
  //     onTapDown: _tapDown,
  //     onTapUp: _tapUp,
  //     onTap: () async {
  //       _scale = 1 - _controller.value;

  //       // VendorDatabase v = VendorDatabase();
  //       // VendorModel vendor = await v.getVendor(bookmark['restaurantID']);
  //       // Navigator.pushNamed(context, '/menu', arguments: vendor);
  //     },
  //     child: Transform.scale(
  //       scale: _scale,
  //       child: Container(
  //           padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
  //           margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12.0),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black26,
  //                 offset: Offset(0.0, 2.0),
  //                 blurRadius: 3.0,
  //               )
  //             ],
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   Expanded(
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Text(
  //                             "${bookmark['name']}",
  //                             overflow: TextOverflow.ellipsis,
  //                             style: TextStyle(
  //                                 fontSize: 18.0, fontWeight: FontWeight.w600),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 5.0,
  //                   ),
  //                   // Material(
  //                   IconButton(
  //                     splashRadius: 20.0,
  //                     splashColor: Colors.red[100],
  //                     icon: Icon(
  //                       Icons.delete,
  //                       color: Colors.red[400],
  //                     ),
  //                     onPressed: () {
  //                       UserDatabase().removeBookMark2(bookmark);
  //                       setState(() {
  //                         bookmarkList!.remove(bookmark);
  //                       });
  //                     },
  //                   ),
  //                   // )
  //                 ],
  //               ),
  //               Text("${bookmark['place']}",
  //                   style: TextStyle(
  //                       color: Colors.grey[500],
  //                       fontSize: 14.5,
  //                       fontWeight: FontWeight.w400))
  //             ],
  //           )),
  //     ),
  //   );
  // }
}
