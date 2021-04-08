import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotification {
  final FirebaseMessaging _fcm;

  PushNotification(this._fcm);

  Future initialise() async {
    // handler notification interaction

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("remote message $message");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
  }
}
