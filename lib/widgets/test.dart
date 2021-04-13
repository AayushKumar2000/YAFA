import 'package:flutter/material.dart';
import 'package:yafa/services/database_order.dart';
import 'package:yafa/services/database_items.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    db();
    return Container(
      child: Text('text'),
    );
  }
}

void db() async {
  DatabaseOrder dbOrder = DatabaseOrder.instance;
  DatabaseItem dbItem = DatabaseItem.instance;

  // await dbOrder.executeDBCommands(
  //     "CREATE TABLE items(id TEXT PRIMARY KEY, vendor_id TEXT,name TEXT, count INTEGER)");

  // await dbOrder.executeDBCommands("DROP TABLE orders");

  // Order order = Order(
  //     order_id: "1212",
  //     order_price: 320.0,
  //     vendor_name: "burger kign",
  //     order_stage: "pending");
  // order = Order(
  //     order_id: "1213",
  //     order_price: 460.0,
  //     vendor_name: "burger kign",
  //     order_stage: "pending");
  // order = Order(
  //     order_id: "1214",
  //     order_price: 730.0,
  //     vendor_name: "burger kign",
  //     order_stage: "pending");
  // await dbOrder.insetOrder(order);
  // dbOrder.getData();

  // Order_Item item = Order_Item(
  //     item_count: 2, item_name: "6 Pc Hot & crispy Chicken", vendor_id: "1212");
  // await dbItem.insetItem(item);
  // item =
  //     Order_Item(item_count: 1, item_name: "Rice Dual Meal", vendor_id: "1212");
  // await dbItem.insetItem(item);
  // item =
  //     Order_Item(item_count: 5, item_name: "Large Popcorn", vendor_id: "1212");
  // await dbItem.insetItem(item);
  dbItem.getData();

//   List<Order> list;
//   //list = await dbOrder.orders();
//   // print(list[0].order_stage = "order ready");
//   // await dbOrder.updateDog(list[0]);
//   list = await dbOrder.findOrder("1212");
//   print("list ${list[0]}");
  dbOrder.getData();
}
