import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yafa/services/database_user.dart';

class CurrentUser extends ChangeNotifier {
  Map<String, String> user = {};
  Future getUser() async {
    print(5555);
    user = await UserDatabase().getUser();
  }
}
