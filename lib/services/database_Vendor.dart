import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafa/models/model_Vendor.dart';

class VendorDatabase {
  Stream<List<VendorModel>> VednorStream() {
    //Stream<QuerySnapshot> VednorStream() {
    return FirebaseFirestore.instance.collection("Vendors").snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => VendorModel.fromJson(doc.data()!, doc.id))
            .toList());
  }
}
