import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Payment_api {
  late final _paymentChannel;
  Payment_api() {
    _paymentChannel = const MethodChannel('samples.flutter.dev/payments');
  }

  Future<void> getUpiApps() async {
    try {
      await _paymentChannel.invokeMethod('getUpiApps');
    } on PlatformException catch (e) {
      print('platform exception $e');
    }
  }
}
