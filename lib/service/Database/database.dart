import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _database = "onomart.db";
  late final Future<Database> database;

  createTable(String query) async {
    database = openDatabase(
      join(await getDatabasesPath(), _database),
      // When you create a database, it also needs to create a table to store books.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement.
        return db.execute(
          query,
        );
      },
      // Set the version to perform database upgrades and downgrades.
      version: _version,
    );
  }

  Future<void> insertData(String table, Map<String, dynamic> data) async {
    // Get a reference to the database.
    final Database db = await database;

    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateData(
      String table, Map<String, dynamic> data, String where, var value) async {
    // Get a reference to the database.
    final Database db = await database;

    await db.update(
      table,
      data,
      where: "$where = ?",
      whereArgs: value,
    );
  }

  Future<void> delete(String table, String where, var value) async {
    final db = await database;
    await db.delete(
      table,
      where: "$where = ?",
      whereArgs: value,
    );
  }
}
