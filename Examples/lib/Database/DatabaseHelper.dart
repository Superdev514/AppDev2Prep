
import 'package:examappdev/User.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  //one instance of the DB // open db
  static Future<Database> getDatabase() async {

    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'myapp.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(''' 
          CREATE TABLE users (
            id      INTEGER PRIMARY KEY AUTOINCREMENT,
            name    TEXT NOT NULL,
            email   TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;

  }

  //insert
  static Future<int> insertUser(User user) async {
    final db = await getDatabase();
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //query
  static Future<List<User>> getAllUsers() async {
    final db = await getDatabase();
    final maps = await db.query('users');
    return maps.map((m) => User.fromMap(m)).toList();
  }

  //update
  static Future<int> updateUser(User user) async {
    final db = await getDatabase();
    return await db.update('users', user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  //delete
  static Future<int> deleteUser(int id) async {
    final db = await getDatabase();
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }




}