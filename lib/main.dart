import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:yafa/cart.dart';
import 'package:yafa/providers/checkConnectivity.dart';
import 'package:yafa/providers/orderState.dart';
import 'package:yafa/providers/upi.dart';

import 'package:yafa/providers/user.dart';
import 'package:yafa/providers/vendor_order_details.dart';
import 'package:yafa/screens/editMenu.dart';
import 'package:yafa/screens/home.dart';
import 'package:yafa/screens/login.dart';
import 'package:yafa/screens/menu.dart';
import 'package:yafa/screens/otp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:yafa/screens/payment.dart';
import 'package:yafa/screens/pushNotification.dart';
import 'package:yafa/screens/reviewList.dart';
import 'package:yafa/screens/vendor_Order.dart';
import 'package:yafa/screens/writeReview.dart';
import 'package:yafa/screens/searchResult.dart';
import 'package:yafa/screens/showOrder.dart';
import 'package:yafa/screens/transactionResponse.dart';
import 'package:yafa/widgets/connectivityError.dart';
import 'package:yafa/widgets/loading.dart';
import 'package:yafa/widgets/test.dart';
import 'package:yafa/services/database_order.dart';
import 'package:connectivity/connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(home: fireBaseConnection()));
}

Widget fireBaseConnection() {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  return FutureBuilder(
    future: _initialization,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }
      // once complete show your application
      if (snapshot.connectionState == ConnectionState.done) {
        return App();
      }

      return Container(
        color: Colors.white,
      );
    },
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  readCounter() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();
      print("file content $contents");
    } catch (e) {
      // If encountering an error, return 0.
      print("file error $e");
      return 0;
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        {
          print("app in paused");
          final file = await _localFile;
          print("file: $file");
          file.writeAsString('hi there , how you are doing');
        }
        break;
      case AppLifecycleState.detached:
        {
          print("app in detached");
          // final file = await _localFile;

          // file.writeAsString('hi there , how you are doing');
        }
        break;
    }
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  Widget build(BuildContext context) {
    readCounter();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Cart>(create: (context) => Cart()),
        ChangeNotifierProvider<Vendor_UPI>(create: (context) => Vendor_UPI()),
        ChangeNotifierProvider<CurrentUser>(create: (context) => CurrentUser()),
        ChangeNotifierProvider<OrderState>(create: (context) => OrderState()),
        ChangeNotifierProvider<VendorOrderDetails>(
            create: (context) => VendorOrderDetails()),
        ChangeNotifierProvider<CheckConnectivity>(
            create: (context) => CheckConnectivity())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/editMenu',

        routes: {
          '/': (context) => handleAuth(),
          '/home': (context) => Home(),
          '/login': (context) => Login(),
          '/menu': (context) => Menu(),
          '/otp': (context) => otp(),
          '/transactionResponse': (context) => TransactionResponse(),
          '/payment': (context) => Payment(),
          '/showOrder': (context) => ShowOrder(),
          '/recentSearchResult': (context) => SearchResult(),
          '/review': (context) => ReviewList(),
          '/writeReview': (context) => WriteReview(),
          '/test': (context) => Test(),
          '/editMenu': (context) => EditMenu(),
          '/vendorOrder': (context) => VendorOrder()
        },

        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case '/':
        //       return PageTransition(child: App(), type: PageTransitionType.scale);
        //       break;
        //     case '/menu':
        //       return PageTransition(
        //           child: Menu(),
        //           type: PageTransitionType.leftToRight,
        //           settings: settings);
        //       break;
        //     // default:
        //     //   return null;
        //   }
        // }
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  DatabaseOrder dbOrder = DatabaseOrder.instance;
  dbOrder.updateOrder(message.data);

  print("Handling a background message: ${message.data}");
  print('Message also contained a notification: ${message}');
}

Widget handleAuth() {
  FirebaseAuth auth = FirebaseAuth.instance;

  return auth.currentUser != null ? Home() : Login();
}
