import 'package:firebase_auth/firebase_auth.dart';
import 'package:yafa/cart.dart';
import 'package:yafa/providers/upi.dart';

import 'package:yafa/providers/user.dart';
import 'package:yafa/screens/home.dart';
import 'package:yafa/screens/login.dart';
import 'package:yafa/screens/menu.dart';
import 'package:yafa/screens/otp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:yafa/screens/payment.dart';
import 'package:yafa/screens/pushNotification.dart';
import 'package:yafa/screens/transactionResponse.dart';
import 'package:yafa/services/messages.dart';
import 'package:yafa/widgets/test.dart';

void main() {
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

      return Text("initializing flutter fire coonection");
    },
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initState() {
    final pushNotificationService = PushNotification(_firebaseMessaging);
    pushNotificationService.initialise();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Cart>(create: (context) => Cart()),
        ChangeNotifierProvider<Vendor_UPI>(create: (context) => Vendor_UPI()),
        ChangeNotifierProvider<CurrentUser>(create: (context) => CurrentUser())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // initialRoute: '/signup',
        routes: {
          '/': (context) => handleAuth(),
          '/home': (context) => Home(),
          '/login': (context) => Login(),
          '/menu': (context) => Menu(),
          '/otp': (context) => otp(),
          '/transactionResponse': (context) => TransactionResponse(),
          '/payment': (context) => Payment(),
          '/test': (context) => Test()
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

  print("Handling a background message: ${message.data}");
  print('Message also contained a notification: ${message}');
}

Widget handleAuth() {
  FirebaseAuth auth = FirebaseAuth.instance;

  return auth.currentUser != null ? Home() : Login();
}
