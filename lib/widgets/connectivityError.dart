import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: MediaQuery.of(context).size.width,
          // color: Colors.white,
          // alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 38.0,
                color: Colors.green[600],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'No Internet Connection',
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600]),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'You are not connected to the internet. \nMake sure  WiFi is on and Airplane mode is off.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500]),
              ),
            ],
          )),
    );
  }
}
