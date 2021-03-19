class MenuModel {
  String docID;
  String name;
  String type;
  double price;
  String description;

  MenuModel(
      {required this.name,
      required this.type,
      required this.price,
      required this.description,
      required this.docID});

  factory MenuModel.fromJson(Map<String, dynamic> parsedJSON, String id) {
    return MenuModel(
        docID: id,
        name: parsedJSON['name'],
        price: (parsedJSON['price']).toDouble(),
        type: parsedJSON['type'] ?? "",
        description: parsedJSON['description'] ?? "");
  }
}
