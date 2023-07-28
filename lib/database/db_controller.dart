import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbController {
  DbController._();

  late Database _database;

  static DbController? _instance;

  factory DbController() {
    return _instance ??= DbController._();
  }

  Database get database => _database;

  Future<void> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'app_db.sql');
    _database = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        db.execute("CREATE TABLE users("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "full_name TEXT,"
            "email TEXT,"
            "password TEXT"
            ")");

        db.execute("CREATE TABLE notes("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title TEXT,"
            "info TEXT,"
            "user_id INTEGER,"
            "FOREIGN KEY(user_id) references user(id)"
            ")");
      },
      onUpgrade: (db, oldVersion, newVersion) {},
      onDowngrade: (db, oldVersion, newVersion) {},
    );
  }
}
