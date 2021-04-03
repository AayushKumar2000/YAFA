import 'dart:io';

import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  /*
    order = {"vednorID":"",items:[{"itemName":"",itemID":"","count": 0,"price":0.0}], "totalPrice":"", 
    "totalItems":""}
   */
  late Map order = {};

  // void _calculateTotalPrice() {
  //   late double totalPrice = 0.0;
  //   order['items']
  //       .forEach((item) => {totalPrice += item['price'] * item['count']});

  //   order['totalPrice'] = totalPrice;
  // }

  double calculatePrice(double a, double b, String type) {
    switch (type) {
      case "add":
        {
          a = a + b;
          String st = a.toStringAsFixed(2);
          return double.parse(st);
        }
        break;

      case "sub":
        {
          a = a - b;
          String st = a.toStringAsFixed(2);
          return double.parse(st);
        }
        break;

      case "multiply":
        {
          a = a * b;
          String st = a.toStringAsFixed(2);
          return double.parse(st);
        }
        break;

      default:
        return 0.0;
    }
  }

  void addItemCount(String itemID, double price) {
    order['items'] = order['items']
        .map((item) => itemID == item['itemID']
            ? {
                'itemID': item['itemID'],
                'count': item['count'] + 1,
                "price": item['price'],
                "itemName": item['itemName']
              }
            : item)
        .toList();

    order['totalPrice'] = calculatePrice(order['totalPrice'], price, "add");
    order['totalItems'] = order['totalItems'] + 1;

    print(order);
    notifyListeners();
  }

  void emptyCart() {
    order = {};
    //  notifyListeners();
  }

  void addItem(Map item) {
    late List items = [];

    if (item['vendorID'] == order['vendorID']) {
      bool flag = false;
      print(1);

      order['items'].forEach((y) => {
            if (y['itemID'] == item['itemID'])
              {
                print(2),
                flag = true,
                items.add({
                  'itemID': y['itemID'],
                  'count': y['count'] + 1,
                  "price": item['itemPrice'],
                  "itemName": item['itemName']
                }),
                order['totalPrice'] = calculatePrice(
                    order['totalPrice'], item['itemPrice'], "add"),
                order['totalItems'] = order['totalItems'] + 1
              }
            else
              {
                print(3),
                items.add(y),
              }
          });

      if (!flag) {
        print(4);
        order['items'].add({
          "itemName": item['itemName'],
          'itemID': item['itemID'],
          'count': 1,
          "price": item['itemPrice']
        });
        order['totalPrice'] =
            calculatePrice(order['totalPrice'], item['itemPrice'], "add");
        order['totalItems'] = order['totalItems'] + 1;
      } else
        order['items'] = items;
    } else {
      print(5);

      order = {
        'vendorID': item['vendorID'],
        "totalPrice": item['itemPrice'],
        "totalItems": 1,
        'items': [
          {
            "itemName": item['itemName'],
            "itemID": item['itemID'],
            'count': 1,
            "price": item['itemPrice']
          }
        ]
      };
    }
    print(order);
    notifyListeners();
  }

  void removeItem(String itemID, double price) {
    late List items = [];

    order['items'].forEach((y) => {
          if (y['itemID'] == itemID)
            {
              print(2),
              if (y['count'] > 1)
                {
                  items.add({
                    'itemID': y['itemID'],
                    'count': y['count'] - 1,
                    "price": y['price'],
                    "itemName": y['itemName']
                  }),
                },
              order['totalPrice'] =
                  calculatePrice(order['totalPrice'], price, "sub"),
              order['totalItems'] = order['totalItems'] - 1
            }
          else
            {
              print(3),
              items.add(y),
            }
        });

    if (items.isNotEmpty)
      order['items'] = items;
    else
      order = {};
    print(order);
    notifyListeners();
  }
}
