import 'package:yafa/models/model_Vendor.dart';
import 'package:yafa/widgets/bookMark.dart';
import 'package:flutter/material.dart';

class VendorListTile extends StatefulWidget {
  VendorModel vendor;
  List? bookmarkList = [];

  VendorListTile({required this.vendor, required this.bookmarkList});
  @override
  _VendorListTileState createState() => _VendorListTileState();
}

class _VendorListTileState extends State<VendorListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late double _scale, _scaleIcon;

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
    // print("scale:");
    // print(_scale);
    _scaleIcon = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: () {
        //   if (widget.vendor.status)
        Navigator.pushNamed(context, '/menu', arguments: widget.vendor);
      },
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
          child: Container(
            //  height: 200.0,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 5.0,
                  // spreadRadius: 2.0
                )
              ],
            ),
            child: Column(children: <Widget>[
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  child: !widget.vendor.status
                      ? ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.grey, BlendMode.saturation),
                          child: Image.network(
                              // 'images/restaurants_${vendor.name}.jpg',
                              'https://firebasestorage.googleapis.com/v0/b/foodapp-yafa.appspot.com/o/restaurants_KFC.jpg?alt=media&token=f91e71b2-46d3-4688-b63f-ea429b884aa4',
                              height: 200.0,
                              width: 400.0,
                              fit: BoxFit.fill),
                        )
                      : Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/foodapp-yafa.appspot.com/o/restaurants_KFC.jpg?alt=media&token=f91e71b2-46d3-4688-b63f-ea429b884aa4',
                          height: 200.0,
                          width: 400.0,
                          fit: BoxFit.fill),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Bookmark(
                        Vendor: widget.vendor,
                        bookmarkList: widget.bookmarkList)
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       bookmarked = bookmarked ? false : true;
                    //     });
                    //   },
                    //   child: Container(
                    //     height: 32.0,
                    //     width: 32.0,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(20.0)),
                    //     alignment: Alignment.center,
                    //     margin: EdgeInsets.only(top: 15.0, right: 10.0),
                    //     child: ScaleTransition(
                    //       scale: _animation,
                    //       child: Icon(
                    //         bookmarked
                    //             ? Icons.bookmark
                    //             : Icons.bookmark_outline,
                    //         size: 28.0,
                    //         color:
                    //             bookmarked ? Colors.green[600] : Colors.black,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              ]),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, bottom: 15.0, top: 10.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.vendor.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.green[600],
                              size: 18.0,
                            ),
                            SizedBox(width: 2.0),
                            Text(
                              (widget.vendor.rating).toString(),
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '/5',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500]),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text((widget.vendor.foodType.join(', ')),
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(widget.vendor.place,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400))
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
