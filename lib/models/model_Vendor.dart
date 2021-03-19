class VendorModel {
  String docID;
  String name;
  String place;
  bool status;
  double rating;
  List<String> foodType;

  VendorModel(
      {required this.name,
      required this.place,
      required this.status,
      required this.rating,
      required this.foodType,
      required this.docID});

  factory VendorModel.fromJson(Map<String, dynamic> parsedJSON, String id) {
    var foodTypefromJson = parsedJSON['foodType'];

    List<String> foodType = new List<String>.from(foodTypefromJson);
    return new VendorModel(
        docID: id,
        name: parsedJSON['name'],
        place: parsedJSON['place'],
        status: parsedJSON['status'],
        rating: parsedJSON['rating'],
        foodType: foodType);
  }
}
