class VendorModel {
  String docID;
  String name;
  String place;
  bool status;
  double total_rating;
  int no_of_ratings;
  double rating;
  String vendor_upiID;
  String vendor_upiName;
  List<String> foodType;

  VendorModel(
      {required this.name,
      required this.place,
      required this.status,
      required this.vendor_upiID,
      required this.rating,
      required this.vendor_upiName,
      required this.total_rating,
      required this.no_of_ratings,
      required this.foodType,
      required this.docID});

  factory VendorModel.fromJson(Map<String, dynamic> parsedJSON, String id) {
    var foodTypefromJson = parsedJSON['foodType'];
    bool containUPI = parsedJSON['upi'] != null ? true : false;
    List<String> foodType = new List<String>.from(foodTypefromJson);
    double rating = parsedJSON['rating'] == null
        ? 0
        : (parsedJSON['rating']['total_rating'] /
                parsedJSON['rating']['no_of_ratings']) ??
            0.0;
    String st = rating.toStringAsFixed(1);
    rating = double.parse(st);
    if (rating.isNaN) rating = 0;

    print("rating ${rating}");
    return new VendorModel(
        docID: id,
        vendor_upiName: containUPI ? parsedJSON['upi']['name'] : "",
        vendor_upiID: containUPI ? parsedJSON['upi']['id'] : "",
        name: parsedJSON['name'],
        place: parsedJSON['place'],
        status: parsedJSON['status'],
        total_rating: (parsedJSON['rating'] == null
                ? 0
                : parsedJSON['rating']['total_rating'])
            .toDouble(),
        no_of_ratings: parsedJSON['rating'] == null
            ? 0
            : parsedJSON['rating']['no_of_ratings'],
        rating: rating,
        foodType: foodType);
  }
}
