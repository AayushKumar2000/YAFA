import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yafa/services/user_reviews.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/noResult.dart';

class ReviewList extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final Map vendor = ModalRoute.of(context)!.settings.arguments as Map;
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Column(
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
                      'Reviews',
                      style: TextStyle(
                          fontSize: 23.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Write a Review',
                          style: TextStyle(color: Colors.green[800]),
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Icon(
                          Icons.edit,
                          size: 20.5,
                          color: Colors.green[800],
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/writeReview',
                          arguments: {"vendorID": vendor['vendorID']});
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: FutureBuilder<List<UserReviewModel>>(
                      future: userReview().getReviews(vendor['vendorID']),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return NoResultFound(
                            primaryText: 'Oops! Something went wrong.',
                            secondaryBoldText: '',
                            secondaryText2: '',
                            secondaryText:
                                'Unable to fetch data from the server.',
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return spinkitLoading;
                        }
                        return ListView.separated(
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1.0, color: Colors.grey),
                          itemBuilder: (context, index) {
                            UserReviewModel review = snapshot.data![index];
                            return Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: reviewTile(review));
                          },
                        );
                      }),
                ),
              ],
            )),
      ),
    );
  }
}

Widget reviewTile(UserReviewModel review) {
  return ListTile(
    title: Row(
      children: [
        Text(
          review.name,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 10.0,
        ),
        RatingBar(
          initialRating: review.rating,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ignoreGestures: true,
          itemSize: 18.0,
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
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          onRatingUpdate: (rating) {},
        ),
      ],
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.time,
          style: TextStyle(fontSize: 13.0, color: Colors.grey[400]),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(review.review),
      ],
    ),
  );
}
