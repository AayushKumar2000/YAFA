import 'package:flutter/material.dart';

class OrderState extends ChangeNotifier {
  Map<String, String> state = {};

  void updateOrderState(data) {
    print("order state");
    state['${data["orderID"]}'] = data['status'];
    notifyListeners();
  }

  void removeState() {
    state = {};
  }
}
