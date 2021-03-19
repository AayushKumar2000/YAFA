import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafa/models/model_Vendor.dart';

class UserDatabase {
  late CollectionReference user;
  UserDatabase() {
    user = FirebaseFirestore.instance.collection('Users');
  }

  void setBookMark(VendorModel vendor) {
    user.doc('L90Bf5l3l3kM3XTrFSOI').update({
      'bookmarks': FieldValue.arrayUnion([_vendorMap(vendor)])
    }).then((v) => print("update"));
  }

  Map _vendorMap(VendorModel vendor) {
    return {
      "restaurantID": vendor.docID,
      "name": vendor.name,
      "place": vendor.place,
      "rating": vendor.rating
    };
  }

  void removeBookMark(VendorModel vendor) {
    user.doc('L90Bf5l3l3kM3XTrFSOI').update({
      'bookmarks': FieldValue.arrayRemove([_vendorMap(vendor)])
    }).then((v) => print("update"));
  }

  void removeBookMark2(Map bookmark) {
    user.doc('L90Bf5l3l3kM3XTrFSOI').update({
      'bookmarks': FieldValue.arrayRemove([bookmark])
    }).then((v) => print("update"));
  }

  Future<List<dynamic>> getBookmarks() async {
    DocumentSnapshot userData = await user.doc('L90Bf5l3l3kM3XTrFSOI').get();

    return userData.data()!['bookmarks'];
  }
}
