import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserReviewModel {
  late String name;
  late double rating;
  late String review;
  late String time;

  UserReviewModel(
      {required this.name,
      required this.rating,
      required this.review,
      required this.time});

  factory UserReviewModel.fromJson(Map<String, dynamic> parsedJSON) {
    return UserReviewModel(
        rating: (parsedJSON['rating']).toDouble(),
        name: parsedJSON['name'],
        time: parsedJSON['time'],
        review: parsedJSON['review']);
  }
}

class userReview {
  Future<List<UserReviewModel>> getReviews(vendorID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Vendors/$vendorID/Reviews')
        .get();

    return querySnapshot.docs
        .map((doc) => UserReviewModel.fromJson(doc.data()))
        .toList();
  }
}
