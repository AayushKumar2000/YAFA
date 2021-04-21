class VendorModel {
  String docID;
  String name;
  String place;
  bool status;
  double rating;
  String vendor_upiID;
  String vendor_upiName;
  List<String> foodType;

  VendorModel(
      {required this.name,
      required this.place,
      required this.status,
      required this.vendor_upiID,
      required this.vendor_upiName,
      required this.rating,
      required this.foodType,
      required this.docID});

  factory VendorModel.fromJson(Map<String, dynamic> parsedJSON, String id) {
    print("vendor models: ${parsedJSON['status']}");
    var foodTypefromJson = parsedJSON['foodType'];
    bool containUPI = parsedJSON['upi'] != null ? true : false;
    List<String> foodType = new List<String>.from(foodTypefromJson);
    return new VendorModel(
        docID: id,
        vendor_upiName: containUPI ? parsedJSON['upi']['name'] : "",
        vendor_upiID: containUPI ? parsedJSON['upi']['id'] : "",
        name: parsedJSON['name'],
        place: parsedJSON['place'],
        status: parsedJSON['status'],
        rating: parsedJSON['rating'],
        foodType: foodType);
  }
}
