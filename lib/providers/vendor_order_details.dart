import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yafa/services/vendor_order.dart';

class VendorOrderDetails extends ChangeNotifier {
  double today_total_amount = 0.0;
  int today_total_orders = 0;

  addPrice(List<VendorFireStoreOrderModel> list) {
    int totalOrders = 0;
    var dt = DateTime.now();
    var newDt = DateFormat.yMMMd().format(dt);
    today_total_orders = 0;
    today_total_amount = 0.0;
    print("vendor order provider ");
    list.forEach((element) {
      if (element.time.contains(newDt)) {
        today_total_orders += 1;
        today_total_amount += element.totalPrice;
        String st = today_total_amount.toStringAsFixed(2);
        today_total_amount = double.parse(st);
      }
    });

    notifyListeners();
  }
}
