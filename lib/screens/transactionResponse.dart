import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yafa/cart.dart';
import 'package:yafa/services/database_order.dart';
import 'package:yafa/providers/user.dart';
import 'package:yafa/widgets/loading.dart';

class TransactionResponse extends StatefulWidget {
  @override
  _TransactionResponseState createState() => _TransactionResponseState();
}

class _TransactionResponseState extends State<TransactionResponse> {
  late Map response;
  late bool status;
  int orderServerResponse = 0;

  void sendOrderToServer() {
    print("sendOrderToServer called");
    var payloadData = {}, payload = {}, x = {};
    Map order = Provider.of<Cart>(context, listen: false).order;
    Map user = Provider.of<CurrentUser>(context, listen: false).user;
    payloadData["vendorID"] = order['vendorID'];
    payloadData["orderID"] = order['orderID'];
    payloadData["time"] = order['time'];
    payloadData["items"] = order['items'];
    payloadData["totalPrice"] = order['totalPrice'];
    payloadData["totalItems"] = order['totalItems'];
    payloadData["customerID"] = user['userID'];
    payloadData['timeStamp'] = DateTime.now().millisecondsSinceEpoch;
    x["userID"] = user['userID'];
    x["data"] = payloadData;

    payload['message'] = x;

    print("payload $payload");

    http
        .post(
            Uri.https(
                "xqbjtrf7i5.execute-api.us-east-1.amazonaws.com", '/dev/order'),
            headers: {"messageGroupID": "1"},
            body: json.encode(payload))
        .then((res) {
      if (res.statusCode == 200) {
        DatabaseOrder dbOrder = DatabaseOrder.instance;
        Map<String, dynamic> x = {
          "status": "Ordered",
          "orderID": order['orderID']
        };
        dbOrder.updateOrder(x);
      }

      print("server response: r${res.statusCode}");
      setState(() {
        orderServerResponse = res.statusCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map response = ModalRoute.of(context)!.settings.arguments as Map;
    status = response['responseCode'] == "00" ? true : false;
    if (orderServerResponse == 0 && status) sendOrderToServer();
    String message = !status
        ? "Transaction Failed!\n \t\tTry Again Later"
        : "Transaction Successfull!";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            splashRadius: 25.0,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 28.0,
            ),
            onPressed: () {
              print("responseL: $status");
              if (orderServerResponse != 0 && status || !status) {
                if (!status) {
                  Navigator.of(context).pop();
                } else {
                  Provider.of<Cart>(context, listen: false).emptyCart();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                }
              }
            }),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                status
                    ? Icons.check_circle_outline_sharp
                    : Icons.cancel_outlined,
                size: 70.0,
                color: status ? Colors.green[600] : Colors.red,
              ),
              Text(
                message,
                style: TextStyle(
                    fontSize: 20.0,
                    decoration: TextDecoration.none,
                    color: status ? Colors.green[600] : Colors.red),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                  '${status && orderServerResponse == 0 ? 'Please wait Placing your Order' : orderServerResponse == 200 ? "Your Order placed successfully" : "Sorry, Couldn't place your order"}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0)),
              SizedBox(height: 5.0),
              orderServerResponse == 0 && status
                  ? spinkitLoadingCircle
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
