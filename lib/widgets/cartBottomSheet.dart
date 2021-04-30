import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yafa/cart.dart';
import 'package:yafa/providers/checkConnectivity.dart';
import 'package:yafa/providers/upi.dart';

class CartBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          cartBottomSheet(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'View Cart',
              style: TextStyle(
                  fontSize: 16.5,
                  color: Colors.white,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w600),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 26.0,
              color: Colors.white,
            )
          ],
        ));
    ;
  }
}

void cartBottomSheet(context) {
  showModalBottomSheet<dynamic>(
      // barrierColor: Colors.blue,
      backgroundColor: Colors.grey[200],
      elevation: 20.0,
      context: context,
      builder: (context) {
        return Consumer<Cart>(builder: (context, cart, child) {
          if (cart.order.isEmpty) Navigator.pop(context);
          // else
          //   return Container();

          return Container(
              padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
              height: 450.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          cart.order.isEmpty ? 0 : cart.order['items'].length,
                      itemBuilder: (BuildContext context, int index) {
                        print(cart.order['items'][index]);
                        return Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          padding: EdgeInsets.only(
                              left: 15.0, top: 5.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cart.order['items'][index]['itemName']}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 1.0),
                                      child: Text(
                                        '\u20B9 ${cart.order['items'][index]['price']}',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 6.0),
                                    height: 32.5,
                                    decoration: BoxDecoration(
                                        color: Colors.red[400],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              cart.removeItem(
                                                  cart.order['items'][index]
                                                      ['itemID'],
                                                  cart.order['items'][index]
                                                      ['price']);
                                            },
                                            child: Icon(Icons.remove,
                                                size: 15.0,
                                                color: Colors.white70)),
                                        Text(
                                            '${cart.order['items'][index]['count']}',
                                            style: TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white70)),
                                        TextButton(
                                            onPressed: () {
                                              cart.addItemCount(
                                                  cart.order['items'][index]
                                                      ['itemID'],
                                                  cart.order['items'][index]
                                                      ['price']);
                                            },
                                            child: Icon(
                                              Icons.add,
                                              size: 15.0,
                                              color: Colors.white70,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 1.5),
                                    child: Text(
                                      '\u20B9${cart.calculatePrice(cart.order['items'][index]['price'], cart.order['items'][index]['count'].toDouble(), "multiply")}',
                                      style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    height: 55.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.center,
                            colors: [
                          Colors.red.shade600,
                          Colors.red.shade700
                        ])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total  \u20B9${cart.order['totalPrice'] ?? ""}",
                          style: TextStyle(
                              fontSize: 16.5,
                              letterSpacing: 0.55,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () async {
                              ConnectivityResult result =
                                  Provider.of<CheckConnectivity>(context,
                                          listen: false)
                                      .connectivity;
                              print("connectivity place order: $result");
                              if (result != ConnectivityResult.none) {
                                Provider.of<Cart>(context, listen: false)
                                    .addTimeToOrder();
                                Vendor_UPI v = Provider.of<Vendor_UPI>(context,
                                    listen: false);
                                Navigator.pushNamed(context, '/payment',
                                    arguments: {
                                      "VendorName": v.name,
                                      "VendorUpiID": v.id
                                    });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  elevation: 30.0,
                                  content: Text(
                                      'No Internet Connection. Cannot Make Payment.'),
                                  duration: new Duration(seconds: 2),
                                ));
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Place Order',
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      color: Colors.white,
                                      letterSpacing: 0.55,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 26.0,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ));
        });
      });
}
