import 'package:yafa/cart.dart';
import 'package:yafa/payments/test_payment.dart';
import 'package:yafa/screens/home.dart';
import 'package:yafa/screens/login.dart';
import 'package:yafa/screens/menu.dart';
import 'package:yafa/screens/otp.dart';
import 'package:yafa/screens/signup.dart';
import 'package:yafa/widgets/payment.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Cart>(
      create: (context) => Cart(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/home': (context) => Home(),
          '/login': (context) => login(),
          '/signup': (context) => signup(),
          '/menu': (context) => Menu(),
          '/otp': (context) => otp()
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
