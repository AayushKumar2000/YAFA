import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

class CheckConnectivity extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  CheckConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityResult = result;
      notifyListeners();
    });
  }

  ConnectivityResult get connectivity => _connectivityResult;

  Future<ConnectivityResult> initialLoad() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult;
  }
}
