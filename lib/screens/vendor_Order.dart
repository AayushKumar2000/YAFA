import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yafa/providers/vendor_order_details.dart';
import 'dart:convert';

import 'package:yafa/services/vendor_order.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/noResult.dart';

class VendorOrder extends StatefulWidget {
  @override
  _VendorOrderState createState() => _VendorOrderState();
}

class _VendorOrderState extends State<VendorOrder> {
  double today_total_amount = 0.0;
  int today_total_orders = 0;
  sendRequest(userID, status, orderID, context) {
    var payloadData = {}, payload = {}, x = {};

    Random random = new Random();
    payloadData['orderID'] = orderID;
    payloadData['status'] = status;

    x['userID'] = userID;
    x['data'] = payloadData;
    x['temp'] = random.nextInt(10);

    payload['message'] = x;
    print(payload);
    http
        .post(
            Uri.https("xqbjtrf7i5.execute-api.us-east-1.amazonaws.com",
                '/dev/notification'),
            headers: {"messageGroupID": "1"},
            body: json.encode(payload))
        .then((res) => {
              print("server response: r${res.statusCode}"),
              if (res.statusCode == 200)
                {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Request Send',
                    ),
                    duration: new Duration(seconds: 2),
                  ))
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 26.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Orders'),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: StreamBuilder<List<VendorFireStoreOrderModel>>(
              stream: VendorFireStoreOrder().getOrders(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("error ${snapshot.error}");
                  return NoResultFound(
                    primaryText: 'Oops! Something went wrong.',
                    secondaryBoldText: '',
                    secondaryText2: '',
                    secondaryText: 'Unable to fetch data from the server.',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return spinkitLoading;
                }

                Future.delayed(const Duration(milliseconds: 500), () async {
                  Provider.of<VendorOrderDetails>(context, listen: false)
                      .addPrice(snapshot.data!);
                });

                print("order $snapshot");
                snapshot.data!
                    .sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<VendorOrderDetails>(
                        builder: (context, todatOrder, child) {
                          return Container(
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today Orders:  ${todatOrder.today_total_orders}",
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Today Amount:  \u20B9 ${todatOrder.today_total_amount}",
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            VendorFireStoreOrderModel order =
                                snapshot.data![index];

                            return orderTile(order, context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget orderTile(VendorFireStoreOrderModel order, context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //  border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(0.1, 0.3),
              blurRadius: 2.2,
              spreadRadius: 1.0)
        ],
      ),
      margin: EdgeInsets.only(bottom: 15.0, top: 15.0, right: 5, left: 5),
      padding:
          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER ID',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
                  ),
                  Text(
                    order.orderID,
                    style:
                        TextStyle(fontSize: 17.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                "\u20B9${order.totalPrice.toString()}",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Divider(thickness: 1.5, color: Colors.grey[100]),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'CUSTOMER ID',
            style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
          ),
          Text(
            order.customerID,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'ORDERED ON',
            style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
          ),
          Text(
            order.time,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'DELIVERED AT',
            style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
          ),
          Text(
            order.deliveredTime,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'TOTAL ITEMS',
            style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
          ),
          Text(
            order.totalItem.toString(),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'ITEMS',
            style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
          ),
          Container(
            height: 20.0 * order.items.length,
            child: Column(
              children: [
                Expanded(
                    child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      itemBuilder: (context, index) {
                        return itemList(order.items[index]);
                      }),
                )),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Divider(thickness: 1.5, color: Colors.grey[100]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: Text('Order Ready'),
                onPressed: order.status == "Delivered"
                    ? null
                    : () {
                        sendRequest(
                            order.customerID, "Ready", order.orderID, context);
                      },
              ),
              ElevatedButton(
                  child: Text('Order Delivered'),
                  onPressed: order.status == "Delivered"
                      ? null
                      : () async {
                          await VendorFireStoreOrder()
                              .changeOrderStatus(order.docID);
                          sendRequest(order.customerID, "Delivered",
                              order.orderID, context);
                        })
            ],
          )
        ],
      ),
    );
  }

  Widget itemList(item) {
    return Container(
      child: Text('${item['itemName']}  x  ${item['count']}'),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
