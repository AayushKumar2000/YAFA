import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yafa/cart.dart';
import 'package:yafa/cart.dart';
import 'package:yafa/payments/payment_api.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Payment_api pay = Payment_api();

  @override
  Widget build(BuildContext context) {
    Map Vendor_upi = ModalRoute.of(context)!.settings.arguments as Map;

    Map cart = Provider.of<Cart>(context, listen: false).order;
    print(cart['totalPrice'].runtimeType);

    return FutureBuilder(
        future: pay.getUpiApps(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) return Text('Error in getting payment apps');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('loading apps...');
          }
          print(snapshot.data!.length);
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your Payment app',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final Map app = snapshot.data[index];
                          return GestureDetector(
                            onTap: () async {
                              Map res = await pay.startTransaction(
                                  app['packageName'],
                                  Vendor_upi['VendorName'],
                                  Vendor_upi['VendorUpiID'],
                                  //      cart['totalPrice'],
                                  2.0,
                                  "food1241");
                              print("res-> $res");

                              if (res['responseCode'] == "00") {
                                Provider.of<Cart>(context, listen: false)
                                    .emptyCart();
                              }
                              Navigator.of(context).popAndPushNamed(
                                  '/transactionResponse',
                                  arguments: res);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: Column(children: [
                                Image.memory(
                                  app['icon'],
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  app['name'],
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                )
                              ]),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
    ;
  }
}
