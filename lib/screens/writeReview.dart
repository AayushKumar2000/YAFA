import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yafa/providers/user.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/screens/reviewList.dart';

class WriteReview extends StatefulWidget {
  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  double rating_value = 0.0;
  String review_content = "";
  Map loadedData = {};
  FirebaseAuth auth = FirebaseAuth.instance;
  String buttonText = "Submit";

  void onSubmit(vendorID) {
    print("review-> $rating_value : $review_content");
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Vendors').doc(vendorID);
    DocumentReference reviewDocumetReference = FirebaseFirestore.instance
        .collection('Vendors/$vendorID/Reviews')
        .doc(auth.currentUser!.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      DocumentSnapshot reviewSnapshot =
          await transaction.get(reviewDocumetReference);

      Map data = snapshot.data()!;
      int no_of_ratings =
          data['rating'] == null ? 0 : data['rating']['no_of_ratings'];
      double total_rating = data['rating'] == null
          ? 0
          : data['rating']['total_rating'].toDouble();

      if (reviewSnapshot.exists) {
        Map reviewData = reviewSnapshot.data()!;

        total_rating -= loadedData['rating'];
        total_rating += rating_value;
      } else {
        no_of_ratings += 1;
        total_rating += rating_value;
      }

      // writing to the review collection
      CurrentUser user = Provider.of<CurrentUser>(context, listen: false);
      print(review_content);
      transaction.set(reviewDocumetReference, {
        "name": user.user['name'],
        "time": time(),
        "rating": rating_value,
        "review": review_content
      });
      transaction.update(documentReference, {
        "rating": {"total_rating": total_rating, "no_of_ratings": no_of_ratings}
      });
    }).then((value) => {
          setState(() {
            buttonText = "Submited";
            loadedData = {"rating": rating_value, "review": review_content};
          })
        });
  }

  String time() {
    var dt = DateTime.now();
    var newDt = DateFormat.yMMMd().format(dt);
    var newDt2 = DateFormat.jm().format(dt);
    return "$newDt at $newDt2";
  }

  void getRatings(vendorID) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Vendors/$vendorID/Reviews")
        .doc(auth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      Map data = snapshot.data()!;
      loadedData = data;
      setState(() {
        rating_value = data['rating'];
        review_content = data['review'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("${loadedData['rating']} $rating_value");
    final Map vendor = ModalRoute.of(context)!.settings.arguments as Map;
    if (loadedData.isEmpty) getRatings(vendor['vendorID']);
    return SafeArea(
        child: Scaffold(
            body: Container(
      padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.all(0.0),
                alignment: Alignment.centerLeft,
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 25.0,
                ),
              ),
              Text(
                'Review',
                style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          RatingBar(
            initialRating: rating_value,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            // ignoreGestures: true,
            itemSize: 38.0,
            ratingWidget: RatingWidget(
              full: Icon(
                Icons.star,
                color: Colors.green,
              ),
              half: Icon(
                Icons.star_half,
                color: Colors.green,
              ),
              empty: Icon(
                Icons.star_border,
                color: Colors.grey,
              ),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
            onRatingUpdate: (rating) {
              setState(() {
                rating_value = rating;
                buttonText = "Submit";
              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
              controller: new TextEditingController.fromValue(
                  new TextEditingValue(
                      text: review_content,
                      selection: new TextSelection.collapsed(
                          offset: review_content.length))),
              maxLines: null,
              maxLength: 100,
              onChanged: (value) {
                review_content = value;
                setState(() {
                  buttonText = "Submit";
                });
              },
              cursorColor: Colors.green,
              decoration: InputDecoration(
                hintText: 'Write Something',
              )),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed:
                (rating_value != 0.0 && loadedData['rating'] != rating_value ||
                        review_content != "" &&
                            rating_value != 0.0 &&
                            loadedData['review'] != review_content)
                    ? () {
                        onSubmit(vendor['vendorID']);
                      }
                    : null,
            child: Text(buttonText),
            style: ElevatedButton.styleFrom(primary: Colors.green),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    )));
  }
}
