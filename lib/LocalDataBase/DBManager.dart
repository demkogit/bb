import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

import '../ProductItem.dart';

class DBManager {
  Database _database;

  Future openDB() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), 'application_data.db'),
          version: 1, onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE cart(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)");
        await db.execute('create table location(loc TEXT)');
      });
    }
  }

  Future delete(String table) async {
    await openDB();
    await _database.delete(table);
  }

  Future<int> insertLocation(Map<String, String> location) async {
    await openDB();
    await _database.delete('location');
    return await _database.insert("location", location);
  }

  Future<Map> getLocation() async {
    await openDB();
    final List<Map<String, dynamic>> mapList =
        await _database.query('location');
    //print(mapList.first);
    if (mapList.isEmpty)
      return null;
    else
      return mapList.first;
  }

  Future<int> updateLocation(Map<String, String> location) async {
    await openDB();
    return await _database.update('location', location,
        where: "loc = ?", whereArgs: [location['loc']]);
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    await openDB();
    return await _database.update('shopping_cart', product,
        where: "id = ?", whereArgs: [product['id']]);
  }

    Future<int> insertProduct(Map<String, dynamic> product) async {
    await openDB();
    //await _database.delete('location');
    return await _database.insert("cart", product);
  }
}
