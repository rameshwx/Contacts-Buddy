import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'contact_model.dart';

class DatabaseHelper {
  static const tableName = 'contacts';
  static const databaseVersion = 1;

  static const idTable = 'id';
  static const nameTable = 'name';
  static const numberTable = 'number';
  static const emailTable = 'email';

  static Future _onCreate(Database db, int version) {
    return db.execute("""CREATE TABLE $tableName(
        $idTable INTEGER PRIMARY KEY AUTOINCREMENT,
        $nameTable TEXT,
        $numberTable INTEGER,
        $emailTable TEXT)""");
  }

  static Future open() async {
    final rootPath = await getDatabasesPath();

    final dbPath = path.join(rootPath, 'contactbuddy.db');

    print('db opened');

    return openDatabase(dbPath, onCreate: _onCreate, version: databaseVersion);
  }

  static Future insertContact(Map<String, dynamic> row) async {
    final db = await open();

    return await db.insert(tableName, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Contact>> getAllContacts() async {
    final db = await open();

    List<Map<String, dynamic>> mapList = await db.query(tableName);

    return List.generate(
        mapList.length, (index) => Contact.fromMap(mapList[index]));
  }

  static Future updateContact(Map<String, dynamic> row, int id) async {
    final db = await open();
    return await db
        .update(tableName, row, where: '$idTable = ?', whereArgs: [id]);
  }

  static Future deleteContact(int id) async {
    final db = await open();
    return await db.delete(tableName, where: '$idTable = ?', whereArgs: [id]);
  }
}
