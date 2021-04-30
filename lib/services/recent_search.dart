import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// data model for item
class RecentSearch {
  late final String search_title;
  late final String search_subTitle;
  late final String? search_vendorID;

  RecentSearch(
      {required this.search_title,
      required this.search_subTitle,
      required this.search_vendorID});

  Map<String, dynamic> toMap() {
    return {
      'search_title': search_title,
      'search_subtitle': search_subTitle,
      'vendor_id': search_vendorID
    };
  }
}

class DatabaseRecentSearch {
  static final _dbitem = "recentSearch.db";

  static final _db_Version = 1;

  // ignore: avoid_init_to_null
  static var _database = null;

  // Make this a singleton class.
  DatabaseRecentSearch._privateConstructor();
  static final DatabaseRecentSearch instance =
      DatabaseRecentSearch._privateConstructor();

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
            "CREATE TABLE recent_search( search_title TEXT ,search_subtitle TEXT, vendor_id TEXT NULL,PRIMARY KEY(search_title))");
      },
      version: 1,
    );
  }

  Future<void> insertSearch(RecentSearch search) async {
    Database db = await database;

    await db.insert(
      'recent_search',
      search.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeSearch(String searchTitle) async {
    Database db = await database;

    await db.delete(
      'recent_search',
      where: "search_title = ?",
      whereArgs: [searchTitle],
    );
  }

  Future<List<RecentSearch>> getSearches() async {
    final Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('recent_search');
    maps = List.from(maps.reversed);

    List<RecentSearch> l = List.generate(maps.length, (i) {
      return RecentSearch(
          search_title: maps[i]['search_title'],
          search_vendorID: maps[i]['vendor_id'],
          search_subTitle: maps[i]['search_subtitle']);
    });
    print(" revserved searches: $l");
    return l;
  }

  Future getData() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('recent_search');
    print(' recent search ${maps.reversed}');
  }
}
