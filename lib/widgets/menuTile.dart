import 'package:yafa/cart.dart';
import 'package:yafa/models/model_Menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuTile extends StatelessWidget {
  late MenuModel menu;
  late String vendorID;
  late String vendorPlace;
  late String vendorName;

  MenuTile(
      {required this.menu,
      required this.vendorID,
      required this.vendorPlace,
      required this.vendorName});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(menu.name,
                      style: TextStyle(
                          letterSpacing: 0.25,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 1.0),
                  menu.type != ""
                      ? Text(
                          '${menu.type}',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.black54,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('\u20B9 ${menu.price}',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 5.0),
                  Text(
                    menu.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    width: 80.0,
                    height: 35.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false).addItem({
                          "itemID": menu.docID,
                          "itemName": menu.name,
                          "vendorID": vendorID,
                          "vendorName": vendorName,
                          "vendorPlace": vendorPlace,
                          "itemPrice": menu.price
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ADD',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 3.0),
                          Icon(
                            Icons.add,
                            size: 18.0,
                            color: Colors.white70,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 5.0),
                height: 120.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/foodapp-yafa.appspot.com/o/restaurants_KFC.jpg?alt=media&token=f91e71b2-46d3-4688-b63f-ea429b884aa4',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
