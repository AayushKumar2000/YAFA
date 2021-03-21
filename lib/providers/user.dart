import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yafa/services/database_user.dart';

class CurrentUser extends ChangeNotifier {
  Map<String, String> user = {};
  Future getUser() async {
    user = await UserDatabase().getUser();
  }

  CurrentUser() {
    print("5555555555555555555555555555555555");
    UserDatabase().getUser().then((v) => {user = v});
  }
}
