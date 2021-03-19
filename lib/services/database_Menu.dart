import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafa/models/model_Menu.dart';

class MenuDatabase {
  Future<List<MenuModel>> getMenu(String id) async {
    print("id:" + id);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Vendors')
        .doc(id)
        .collection('Menu')
        .get();
    // .then((QuerySnapshot querySnapshot) => {
    //       querySnapshot.docs.forEach((doc) {
    //         print(doc["name"]);
    //       })
    //     });

    return querySnapshot.docs
        .map((doc) => MenuModel.fromJson(doc.data()!, doc.id))
        .toList();
  }
}
