import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:yafa/providers/orderState.dart';
import 'package:yafa/services/database_order.dart';
import 'package:yafa/services/database_items.dart';
import 'package:yafa/widgets/loading.dart';

class ShowOrder extends StatefulWidget {
  @override
  _ShowOrderState createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> with WidgetsBindingObserver {
  DatabaseOrder dbOrder = DatabaseOrder.instance;

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

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          print("app in resumed");
          setState(() {});
        }
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    dbOrder.getData();
    Provider.of<OrderState>(context, listen: false).removeState();
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  onTap: () {
                    Navigator.pop(context, null);
                  },
                  child: Container(
                    //   margin: EdgeInsets.only(left: ),
                    width: 40,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 25.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Your Orders',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5.0),
              Divider(thickness: 1.5, color: Colors.grey[300]),
              SizedBox(height: 5.0),
              Container(
                child: FutureBuilder(
                    future: dbOrder.orders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return spinkitLoading;
                      }

                      return Container(child: orderItem(snapshot, context));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget? orderItem(snapshot, context) {
  DatabaseItem dbItem = DatabaseItem.instance;
  // Map<String, String> orderState =
  //     Provider.of<OrderState>(context, listen: true).orderState;

  // print("order state: $orderState");

  return Expanded(
    child: ListView.builder(
        // shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          Order order = snapshot.data[index];
          print(order.order_id);
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              //  border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.1, 0.3),
                    blurRadius: 2.2,
                    spreadRadius: 1.0)
              ],
            ),
            margin: EdgeInsets.only(bottom: 15.0, top: 15.0, right: 5, left: 5),
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: SizedBox(
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.vendor_name,
                            style: TextStyle(
                                fontSize: 17.5, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          Text(
                            order.vendor_place,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\u20B9${order.order_price.toString()}",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Divider(thickness: 1.5, color: Colors.grey[100]),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'ITEMS',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: dbItem.item(order.order_id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("error");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }
                          print(snapshot);
                          //return Text("");
                          return itemList(context, snapshot);
                        }),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'ORDER ID',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
                  ),
                  Text(
                    order.order_id,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'ORDERED ON',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
                  ),
                  Text(
                    order.order_time,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'ORDER STATUS',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey[350]),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Consumer<OrderState>(builder: (context, OrderState, child) {
                    String? v = OrderState.state["${order.order_id}"];
                    String x = v == null ? order.order_stage : v;

                    Color? TextColor, backgroundColor;
                    if (x == "Processing") {
                      TextColor = Colors.yellow[700];
                      backgroundColor = Colors.yellow[100];
                    } else if (x == "Delivered") {
                      TextColor = Colors.green[600];
                      backgroundColor = Colors.green[200];
                    } else if (x == "Canceled") {
                      TextColor = Colors.red[600];
                      backgroundColor = Colors.red[200];
                    } else if (x == "Ordered") {
                      TextColor = Colors.grey;
                      backgroundColor = Colors.grey[350];
                    } else if (x == "Ready") {
                      TextColor = Colors.blue[600];
                      backgroundColor = Colors.blue[200];
                    } else {
                      TextColor = Colors.black;
                      backgroundColor = Colors.white;
                    }
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(2.3)),
                      child: Text(
                        x,
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 15.0,
                            letterSpacing: 0.02,
                            fontWeight: FontWeight.w400),
                      ),
                    );

                    // return T
                  }),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(thickness: 1.5, color: Colors.grey[100]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.replay,
                            size: 20.0,
                            color: Colors.green[600],
                          ),
                          label: Text(
                            "Repeat Order",
                            style: TextStyle(color: Colors.green[600]),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        }),
  );
}

Widget itemList(context, snapshot) {
  //return Text("");
  return Expanded(
    child: SizedBox(
      // height: 200,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Order_Item item = snapshot.data[index];

              return Container(
                child: Text("${item.item_count} x  ${item.item_name}"),
              );
            }),
      ),
    ),
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
