import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_example/helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Model> persons = [];

  @override
  void initState() {
    super.initState();
    _queryPersons();
  }

  Future<void> _queryPersons() async {
    List<Model> fetchedPersons = await dbHelper.getPersons();
    setState(() {
      persons = fetchedPersons;
    });
  }

  Future<void> _insertPerson() async {
    Model person = Model(
        productName: 'John Doe',
        UnitNo: 30,
        price: 30,
        quantity: 20,
        total: 10,
        expiryDate: DateTime.now().toIso8601String());
    await dbHelper.insertPerson(person);
    await _queryPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insertPerson,
              child: Text('Insert and view'),
            ),
            SizedBox(height: 20),
            Text('Database:'),
            Column(
              children: persons.map((person) {
                return ListTile(
                  title: Text(
                      '${person.lineNo}, ${person.productName}, ${person.UnitNo}, ${person.quantity}, ${person.total} , ${person.expiryDate}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
