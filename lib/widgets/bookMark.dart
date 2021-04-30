import 'package:yafa/services/database_user.dart';
import 'package:flutter/material.dart';
import 'package:yafa/models/model_Vendor.dart';

class Bookmark extends StatefulWidget {
  VendorModel Vendor;
  List? bookmarkList = [];
  Bookmark({required this.Vendor, required this.bookmarkList});
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  List bookmarkList = [];
  late double _scale;

  @override
  void initState() {
    super.initState();

    // UserDatabase().getBookmarks().then((x) => {
    //       setState(() {
    //         bookmarkList = x.map((y) => y['restaurantID']).toList();
    //       })
    //     });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 2,
      ),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _tapDown(TapDownDetails details) {
    // print(1);
    _controller.forward();
    // setState(() {
    //   _scale = 0.8;
    // });
  }

  void _tapUp(TapUpDetails details) {
    // print(2);
    _controller.reverse();
    // setState(() {
    //   _scale = 1.0;
    // });
  }

  @override
  Widget build(BuildContext context) {
    bool bookmarked = widget.bookmarkList!.contains(widget.Vendor.docID);
    _scale = 1 - _animation.value;
    // print("scaleIcon:");
    // print(_controller.value);
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,

      onTap: () {
        print(bookmarked);
        if (!bookmarked) {
          UserDatabase().setBookMark(widget.Vendor);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'bookmark added.',
            ),
            duration: new Duration(seconds: 1),
          ));
        } else {
          UserDatabase().removeBookMark(widget.Vendor);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text('bookmark removed.'),
            duration: new Duration(seconds: 1),
          ));
        }
        setState(() {
          bookmarked
              ? widget.bookmarkList!.remove(widget.Vendor.docID)
              : widget.bookmarkList!.add(widget.Vendor.docID);
        });
      },
      child: Container(
        height: 32.0,
        width: 32.0,
        //color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 15.0, right: 10.0),

        // child: ScaleTransition(
        //   scale: _animation,

        child: Transform.scale(
          scale: _scale,
          child: Icon(
            bookmarked ? Icons.bookmark : Icons.bookmark_outline,
            size: 28.0,
            color: bookmarked ? Colors.green[600] : Colors.black,
          ),
        ),
      ),

      // ),
    );
    // );
  }
}
