import 'package:flutter/material.dart';

class Vendor_UPI extends ChangeNotifier {
  late String name;
  late String id;

  addUpi(n, id) {
    this.name = n;
    this.id = id;
  }
}
