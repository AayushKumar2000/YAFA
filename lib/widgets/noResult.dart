import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoResultFound extends StatelessWidget {
  String primaryText, secondaryText, secondaryBoldText, secondaryText2;
  NoResultFound(
      {required this.primaryText,
      required this.secondaryText,
      required this.secondaryBoldText,
      required this.secondaryText2});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            primaryText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19.0,
                wordSpacing: 2.0,
                color: Colors.green[600],
                letterSpacing: 0.35),
          ),
          SizedBox(
            height: 2.0,
          ),
          new RichText(
            textAlign: TextAlign.center,
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent

              style: new TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: Colors.grey[500],
                  letterSpacing: 0.25),
              children: <TextSpan>[
                new TextSpan(text: secondaryText),
                new TextSpan(
                    text: secondaryBoldText,
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(text: secondaryText2),
              ],
            ),
          )
          // Text(
          //   secondaryText,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //       fontWeight: FontWeight.w400,
          //       fontSize: 16.0,
          //       color: Colors.grey[500],
          //       letterSpacing: 0.25),
          // )
        ],
      ),
    );
  }
}
