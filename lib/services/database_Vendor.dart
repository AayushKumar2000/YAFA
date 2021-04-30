import 'package:algolia_ns/algolia_ns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafa/models/model_Vendor.dart';

class VendorDatabase {
  Stream<List<VendorModel>> VednorStream() {
    //Stream<QuerySnapshot> VednorStream() {
    return FirebaseFirestore.instance.collection("Vendors").snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => VendorModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  Future<VendorModel> getVendor(String id) async {
    print("vendor get called");
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.doc('Vendors/$id').get();
    return VendorModel.fromJson(doc.data()!, doc.id);
  }

  Future<List<VendorModel>> getVendorForSearch(String query) async {
    // using agolia
    //
    // List<String> queryList = query.split(" ");
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection('Vendors')
    //     .where('foodName', arrayContainsAny: queryList)

    //     .get();
    // return querySnapshot.docs
    //     .map((doc) => VendorModel.fromJson(doc.data()!, doc.id))
    //     .toList();
    Algolia algolia = Algolia.init(
      applicationId: 'P7VJS2X8PX',
      apiKey: 'b08c42607241f55ef61893bfeb6146ae',
    );

    AlgoliaQuery queryAgolia = algolia.instance.index('filter_vendor');

    AlgoliaQuerySnapshot snapshot =
        await queryAgolia.search(query).getObjects();
    List<AlgoliaObjectSnapshot> _results = snapshot.hits!;
    print("agolia ${_results[0].data!['vendorID']}");
    return _results
        .map((doc) => VendorModel.fromJson(doc.data!, doc.data!['vendorID']))
        .toList();
  }
}
