import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yafa/providers/orderState.dart';
import 'package:yafa/screens/showOrder.dart';
import 'package:yafa/services/database_order.dart';

class PushNotification {
  final FirebaseMessaging _fcm;

  PushNotification(this._fcm);

  Future initialise(context) async {
    // handler notification interaction

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("remote message $message");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      DatabaseOrder dbOrder = DatabaseOrder.instance;
      dbOrder.updateOrder(message.data);

      Provider.of<OrderState>(context, listen: false)
          .updateOrderState(message.data);
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
  }
}
