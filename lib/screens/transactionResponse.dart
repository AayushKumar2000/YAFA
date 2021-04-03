import 'package:flutter/material.dart';
import 'package:yafa/widgets/orderTrasaction.dart';

class TransactionResponse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map response = ModalRoute.of(context)!.settings.arguments as Map;

    bool status = response['responseCode'] == "00" ? true : false;
    String message = !status
        ? "Transaction Failed!\n \t\tTry Again Later"
        : "Transaction Successfull!";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            splashRadius: 25.0,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 28.0,
            ),
            onPressed: () {
              if (!status) {
                Navigator.of(context).pop();
              } else
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
            }),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                status
                    ? Icons.check_circle_outline_sharp
                    : Icons.cancel_outlined,
                size: 70.0,
                color: status ? Colors.green[600] : Colors.red,
              ),
              Text(
                message,
                style: TextStyle(
                    fontSize: 20.0,
                    decoration: TextDecoration.none,
                    color: status ? Colors.green[600] : Colors.red),
              )
              ,OrderTransaction()
            ],
          ),
        ),
      ),
    );
  }
}
