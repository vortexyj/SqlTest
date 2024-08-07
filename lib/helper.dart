import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'interview';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'example1.db');
    return await openDatabase(path, version: 3, onCreate: _createTable);
  }

  void _createTable(Database db, int version) async {
    version = 3;
    await db.execute('''
      CREATE TABLE $tableName (
        lineNo INTEGER PRIMARY KEY,
        productName TEXT,
        UnitNo INTEGER,
        price REAL,
        quantity REAL,
        total REAL,
        expiryDate TEXT
      )
    ''');
  }

  Future<void> insertPerson(Model person) async {
    final Database db = await database;
    await db.insert(tableName, person.toMap());
  }

  Future<List<Model>> getPersons() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Model(
        lineNo: maps[i]['lineNo'],
        productName: maps[i]['productName'],
        UnitNo: maps[i]['UnitNo'],
        price: maps[i]['price'],
        quantity: maps[i]['quantity'],
        total: maps[i]['total'],
        expiryDate: maps[i]['expiryDate'],
      );
    });
  }
}

class Model {
  final int? lineNo;
  final String? productName;
  final int? UnitNo;
  final double? price;
  final double? quantity;
  final double? total;
  final String? expiryDate;

  Model({
    this.lineNo,
    required this.productName,
    required this.UnitNo,
    required this.price,
    required this.quantity,
    required this.total,
    this.expiryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'lineNo': lineNo,
      'productName': productName,
      'UnitNo': UnitNo,
      'price': price,
      'quantity': quantity,
      'total': total,
      'expiryDate': expiryDate,
    };
  }
}
