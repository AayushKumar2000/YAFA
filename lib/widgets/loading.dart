import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final Widget spinkitLoading = SpinKitThreeBounce(
  size: 35.0,
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  },
);
