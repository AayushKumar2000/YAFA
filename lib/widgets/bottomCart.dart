import 'package:yafa/cart.dart';
import 'package:yafa/widgets/cartBottomSheet.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomCart extends StatefulWidget {
  @override
  _BottomCartState createState() => _BottomCartState();
}

class _BottomCartState extends State<BottomCart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      print('order ${cart.order.isEmpty}');
      return cart.order.isEmpty
          ? Container()
          : Container(
              padding: EdgeInsets.only(
                  left: 15.0, top: 10.0, right: 15.0, bottom: 10.0),
              height: 60.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.center,
                      colors: [Colors.red.shade600, Colors.red.shade700])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        "\u20B9 ${cart.order['totalPrice'] ?? ""}",
                        style: TextStyle(
                            fontSize: 16.0,
                            letterSpacing: 0.55,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "${cart.order['totalItems'] ?? ""} ${cart.order['totalItems'] == 1 ? "item" : "items"} ",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            letterSpacing: 0.2,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                  Container(
                    //  margin: EdgeInsets.only(right: 5.0),

                    child: CartBottomSheet(),
                  )
                ],
              ));
    });
  }
}
