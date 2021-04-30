import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Payment_api {
  late final _paymentChannel;
  Payment_api() {
    _paymentChannel = const MethodChannel("samples.flutter.dev/payments");
    print("hello");
  }

  Future<List?> getUpiApps() async {
    print(123);
    try {
      List x = await _paymentChannel.invokeMethod('getUpiApps');
      // Map app = x[2];
      print(x);
      return x;
      // print("package ${app['packageName']}");
      // String res = await _paymentChannel
      //     .invokeMethod('startTransaction', {"app": app['packageName']});
      //  print("transaction result: $res");
    } on PlatformException catch (e) {
      print('platform exception $e');
    }
  }

  Future<Map> startTransaction(
      String app, String upi_name, String upi_id, double am, String tr) async {
    String res = await _paymentChannel.invokeMethod('startTransaction', {
      "app": app,
      "mid": upi_id,
      "mn": upi_name,
      "am": am.toString(),
      "tr": tr
    });
    print("transaction result: $res");
    return extractResponse(res);
  }

  Map extractResponse(String u) {
    Map<String, String> res = {};
    u = "http://www.example.com/x?" + u;
    res = Uri.parse(u).queryParameters;
    return res;
  }
}
