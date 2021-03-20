import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yafa/models/model_Vendor.dart';

class UserDatabase {
  late CollectionReference user;
  late User? currentUser;
  UserDatabase() {
    user = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    currentUser = auth.currentUser;
  }
  void addUser(name, email) {
    if (currentUser != null)
      user
          .doc(currentUser!.uid)
          .set({"name": name, "email": email, "bookmarks": []})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    ;
  }

  void setBookMark(VendorModel vendor) {
    user.doc(currentUser!.uid).update({
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
    user.doc(currentUser!.uid).update({
      'bookmarks': FieldValue.arrayRemove([_vendorMap(vendor)])
    }).then((v) => print("update"));
  }

  void removeBookMark2(Map bookmark) {
    user.doc(currentUser!.uid).update({
      'bookmarks': FieldValue.arrayRemove([bookmark])
    }).then((v) => print("update"));
  }

  Future<List<dynamic>> getBookmarks() async {
    DocumentSnapshot userData = await user.doc(currentUser!.uid).get();

    return userData.data()!['bookmarks'];
  }
}
