import 'package:yafa/models/model_Menu.dart';
import 'package:yafa/services/database_Menu.dart';
import 'package:yafa/widgets/bottomCart.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/menuTile.dart';
import 'package:yafa/widgets/vendorList.dart';
import 'package:flutter/cupertino.dart';
import 'package:yafa/models/model_Vendor.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  late Future<List<MenuModel>> menu;
  late VendorModel VendorDetail;

  void initState() {}

  

  @override
  Widget build(BuildContext context) {
    final VendorModel VendorDetail =
        ModalRoute.of(context)!.settings.arguments as VendorModel;

    return SafeArea(
        child: Scaffold(
            body: FutureBuilder(
                future: MenuDatabase().getMenu(VendorDetail.docID),
                builder: (context, AsyncSnapshot<List<MenuModel>> snapshot) {
                  print(snapshot);
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return spinkitLoading;
                  }

                  return Container(
                      //padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/foodapp-yafa.appspot.com/o/restaurants_Dominic%20Pizza.jpg?alt=media&token=a0699595-3cfd-4f62-8713-8eb94b6ee585'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: EdgeInsets.only(left: 20.0, bottom: 35.0),
                        margin: EdgeInsets.only(bottom: 15.0),
                        width: MediaQuery.of(context).size.width,
                        child: Stack(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                                VendorDetail.name,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 3.5,
                              ),
                              Row(
                                children: [
                                  RatingBar(
                                    initialRating: VendorDetail.rating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ignoreGestures: true,
                                    itemSize: 22.0,
                                    ratingWidget: RatingWidget(
                                      full: Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      ),
                                      half: Icon(
                                        Icons.star_half,
                                        color: Colors.white,
                                      ),
                                      empty: Icon(
                                        Icons.star_border,
                                        color: Colors.white,
                                      ),
                                    ),
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    VendorDetail.rating.toString(),
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                VendorDetail.foodType.join(', '),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      SizedBox(height: 10.0),
                      Expanded(
                        child: ListView.separated(
                            itemCount: snapshot.data!.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1.0, color: Colors.grey),
                            itemBuilder: (context, index) {
                              return MenuTile(
                                  menu: snapshot.data![index],
                                  vendorID: VendorDetail.docID);
                            }),
                      ),
                      BottomCart()
                    ],
                  ));
                })));
  }
}
