import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// data model for item
class Order_Item {
  late final String item_name;
  late final int item_count;
  late final String order_id;

  Order_Item(
      {required this.item_count,
      required this.item_name,
      required this.order_id});

  Map<String, dynamic> toMap() {
    return {'name': item_name, 'count': item_count, 'order_id': order_id};
  }
}

class DatabaseItem {
  static final _dbitem = "itemDatabase.db";

  static final _db_Version = 1;

  // ignore: avoid_init_to_null
  static var _database = null;

  // Make this a singleton class.
  DatabaseItem._privateConstructor();
  static final DatabaseItem instance = DatabaseItem._privateConstructor();

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
      join(path, _dbitem),
      onCreate: (db, version) async {
        print("on create");
        await db.execute(
            "CREATE TABLE items( order_id TEXT,name TEXT, count INTEGER,PRIMARY KEY(order_id, name))");
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
    List<Map<String, dynamic>> maps = await db.query('items');
    print(maps);
  }

  Future<void> insetItem(Order_Item item) async {
    Database db = await database;

    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Order_Item>> item(String id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('items', where: "order_id=?", whereArgs: [id]);
    ;

    return List.generate(maps.length, (i) {
      return Order_Item(
          item_count: maps[i]['count'],
          item_name: maps[i]['name'],
          order_id: maps[i]['order_id']);
    });
  }
}
