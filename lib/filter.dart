import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafa/models/model_Vendor.dart';

class FilterList {
  List<VendorModel> vendorList;
  List<String> filters;

  FilterList({required this.filters, required this.vendorList});

  List<VendorModel> filter() {
    List<VendorModel> result = [];
    bool containRating = filters.contains('Rating 4.0+');

    if (containRating)
      vendorList = vendorList.where((v) => v.rating >= 4.0).toList();

    bool containOnlineStatus = filters.contains('Online');

    if (containOnlineStatus)
      vendorList = vendorList.where((v) => v.status).toList();

    print("filter $filters");
    bool flag = false;
    filters.forEach((filter) => {
          if (filter != "Rating 4.0+" && filter != "Online")
            {
              result.addAll(List<VendorModel>.from(
                  vendorList.where((v) => v.foodType.contains(filter)))),
              flag = true
            },
          print("result ${result.length}, $flag")
        });

    return result.length == 0 && !flag ? vendorList : result.toSet().toList();
    ;
  }
}
