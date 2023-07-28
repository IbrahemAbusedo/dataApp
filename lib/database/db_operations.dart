import 'package:sqflite/sqlite_api.dart';
import 'package:vp18_data_app/database/db_controller.dart';

abstract class DbOperations<T> {

  //TODO: * CRUD :
  //TODO: - C (Create) => Insert
  //TODO: - D (Delete) => Delete
  //TODO: - R (Read) => Select
  //TODO: - U (Update) => Update

  Database database = DbController().database;

  Future<int> create(T t);

  Future<List<T>> read();

  Future<T?> show(int id);

  Future<bool> update(T t);

  Future<bool> delete(int id);
}
