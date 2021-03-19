import 'package:flutter/material.dart';
import 'package:yafa/payments/test_payment.dart';

class Payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Payment_api pay = Payment_api();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: TextButton(
                onPressed: () {
                  pay.getUpiApps();
                },
                child: Text('payment')),
          ),
        ),
      ),
    );
  }
}
