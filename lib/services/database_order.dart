import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// data model for order
class Order {
  late final String order_id;
  late final double order_price;
  late final String vendor_name;
  late String order_stage;

  Order(
      {required this.order_id,
      required this.order_price,
      required this.vendor_name,
      required this.order_stage});

  Map<String, dynamic> toMap() {
    return {
      'id': order_id,
      'vendor_name': vendor_name,
      'price': order_price,
      'state': order_stage
    };
  }
}

class DatabaseOrder {
  static final _db_order = "orderDatabase.db";
  static final _dbitem = "itemDatabase.db";

  static final _db_Version = 1;

  // ignore: avoid_init_to_null
  static var _database = null;

  // Make this a singleton class.
  DatabaseOrder._privateConstructor();
  static final DatabaseOrder instance = DatabaseOrder._privateConstructor();

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await _initDatabase();
      return _database;
    }
  }

  _initDatabase() async {
    print("init database");
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, _db_order),
      onCreate: (db, version) async {
        print("on create");
        await db.execute(
            "CREATE TABLE orders(id TEXT NOT NULL PRIMARY KEY, vendor_name TEXT, price DOUBLE, state TEXT)");
      },
      version: 1,
    );
  }

  Future<void> executeDBCommands(String query) async {
    Database db = await database;
    db.execute(query);
  }

  Future getData() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('orders');
    print(maps);
  }

  Future<void> insetOrder(Order order) async {
    Database db = await database;

    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Order>> orders() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('orders');

    return List.generate(maps.length, (i) {
      return Order(
          order_id: maps[i]['id'],
          vendor_name: maps[i]['vendor_name'],
          order_price: maps[i]['price'],
          order_stage: maps[i]['state']);
    });
  }

  Future<List<Order>> findOrder(String id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('orders', where: "id=?", whereArgs: [id]);

    return List.generate(maps.length, (i) {
      return Order(
          order_id: maps[i]['id'],
          vendor_name: maps[i]['vendor_name'],
          order_price: maps[i]['price'],
          order_stage: maps[i]['state']);
    });
  }

  Future<void> updateDog(Order order) async {
    final Database db = await database;

    await db.update(
      'orders',
      order.toMap(),
      where: "id = ?",
      whereArgs: [order.order_id],
    );
  }
}
