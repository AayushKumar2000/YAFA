import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VendorFireStoreOrderModel {
  late String customerID;
  late List<dynamic> items;
  late String orderID;
  late String time;
  late int totalItem;
  late double totalPrice;
  late String deliveredTime;
  late int timeStamp;
  late String status;
  late String docID;

  VendorFireStoreOrderModel(
      {required this.customerID,
      required this.items,
      required this.orderID,
      required this.status,
      required this.time,
      required this.deliveredTime,
      required this.totalItem,
      required this.timeStamp,
      required this.docID,
      required this.totalPrice});

  factory VendorFireStoreOrderModel.fromJson(
      Map<String, dynamic> parsedJSON, String id) {
    return new VendorFireStoreOrderModel(
        customerID: parsedJSON['customerID'],
        orderID: parsedJSON['orderID'],
        time: parsedJSON['time'],
        status: parsedJSON['status'] ?? "",
        deliveredTime: parsedJSON['deliveredTime'] ?? "",
        timeStamp: parsedJSON['timeStamp'],
        totalItem: parsedJSON['totalItems'],
        totalPrice: parsedJSON['totalPrice'],
        docID: id,
        items: parsedJSON['items']);
  }
}

class VendorFireStoreOrder {
  Stream<List<VendorFireStoreOrderModel>> getOrders(
      {vendorID = "EN5JRmSmNRHySxIfM665"}) {
    return FirebaseFirestore.instance
        .collection("Vendors/$vendorID/Orders")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => VendorFireStoreOrderModel.fromJson(doc.data(), doc.id),
            )
            .toList());
  }

  Future<String> changeOrderStatus(docID) async {
    String vendorID = "EN5JRmSmNRHySxIfM665";
    await FirebaseFirestore.instance
        .collection("Vendors/$vendorID/Orders")
        .doc(docID)
        .update({"status": "Delivered", "deliveredTime": addTime()});
    return " ";
  }

  String addTime() {
    var dt = DateTime.now();
    var newDt = DateFormat.yMMMd().format(dt);
    var newDt2 = DateFormat.jm().format(dt);
    return "$newDt at $newDt2";
  }
}
