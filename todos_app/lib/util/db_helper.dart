import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todosapp/model/Todo.dart';

// singleton
class DBHelper {

  String tableName = "tosdo";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  static final DBHelper _dbHelper = DBHelper._internal(); // private constructor

  DBHelper._internal(); // named constructor

  factory DBHelper() { // unnamed constructor
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if(_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo.db";
    var todosDb = await openDatabase(path, version: 1, onCreate: _createDb); // if db does not exist create a new one
    return todosDb;
  }

  void _createDb(Database db, int version) async {
    String sql = 'CREATE TABLE $tableName ($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)';
    print(sql);
    await db.execute(sql);
  }

  Future<int> insertToDo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tableName, todo.toMap());
    return result;
  }

  Future<List> getTodoList() async {
    Database db = await this.db;
    var result = await db.rawQuery('SELECT * FROM $tableName ORDER BY $colPriority');
    return result.toList();
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT count(*) from $tableName')
    );
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    var db = await this.db;
    var result = await db.update(tableName, todo.toMap(), where: "$colId = ?",  whereArgs: [todo.id]);
    return result;
  }

  Future<int> delete(int id) async {
    var db = await this.db;
    var result = await db.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
  }

}