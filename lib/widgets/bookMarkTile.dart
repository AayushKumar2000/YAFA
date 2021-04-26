import 'package:flutter/material.dart';
import 'package:yafa/models/model_Vendor.dart';
import 'package:yafa/services/database_Vendor.dart';
import 'package:yafa/services/database_user.dart';

class BookmarkTilel extends StatefulWidget {
  late Function removeBookmarkFromList;
  Map bookmark;
  BookmarkTilel({required this.bookmark, required this.removeBookmarkFromList});
  @override
  _BookmarkTilelState createState() => _BookmarkTilelState();
}

class _BookmarkTilelState extends State<BookmarkTilel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.02,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: () async {
        VendorDatabase v = VendorDatabase();
        VendorModel vendor = await v.getVendor(widget.bookmark['restaurantID']);
        Navigator.pushNamed(context, '/menu', arguments: vendor);
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
            padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 3.0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.bookmark['name']}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    // Material(
                    IconButton(
                      splashRadius: 20.0,
                      splashColor: Colors.red[100],
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[400],
                      ),
                      onPressed: () {
                        UserDatabase().removeBookMark2(widget.bookmark);
                        widget.removeBookmarkFromList(widget.bookmark);
                      },
                    ),
                    // )
                  ],
                ),
                Text("${widget.bookmark['place']}",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400))
              ],
            )),
      ),
    );
  }
}
