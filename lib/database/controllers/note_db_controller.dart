import 'package:vp18_data_app/database/db_operations.dart';
import 'package:vp18_data_app/models/note.dart';
import 'package:vp18_data_app/pref/shared_pref_controller.dart';

class NoteDbController extends DbOperations<Note> {

  //TODO: * CRUD :
  //TODO: - C (Create) => Insert
  //TODO: - D (Delete) => Delete
  //TODO: - R (Read) => Select
  //TODO: - U (Update) => Update

  NoteDbController._();
  static NoteDbController? _instance;

  int userId = SharedPrefController().getValue<int>(PrefKeys.id.name)!;

  factory NoteDbController() {
    return _instance ??= NoteDbController._();
  }

  @override
  Future<int> create(Note t) async {
    // return database.rawInsert("INSERT INTO notes (title, info, user_id) VALUE(?,?,?)",[t.title, t.info, t.userId]);
    return database.insert(Note.tableName, t.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    // int countOfDeletedRows = await database.rawDelete("DELETE FROM notes WHERE ID = ?", [id]);
    int countOfDeletedRows =
        await database.delete(Note.tableName, where: "id = ? AND user_id = ?", whereArgs: [id, userId]);
    return countOfDeletedRows == 1;
  }

  @override
  Future<List<Note>> read() async {
    //List<Map<String, dynamic>> rows = await database.rawQuery("SELECT * FROM notes");
    List<Map<String, dynamic>> rows = await database.query(Note.tableName,where: "user_id = ?", whereArgs: [userId]);
    return rows.map((e) => Note.fromMap(e)).toList();
  }

  @override
  Future<Note?> show(int id) async {
    //List<Map<String, dynamic>> rows = await database.rawQuery("SELECT * FROM notes WHERE id = ? ", [id]);
    List<Map<String, dynamic>> rows =
        await database.query(Note.tableName, where: "id = ?", whereArgs: [id]);
    return rows.isNotEmpty ? Note.fromMap(rows.first) : null;
  }

  @override
  Future<bool> update(Note t) async {
    //int countOfUpdateRows = await database.rawUpdate("UPDATE notes SET title = ?,info = ?, user_id = ? " WHERE id = ?, [t.title, t.info, t.userId, t.id]);t.toMap();
    int countOfUpdateRows = await database
        .update(Note.tableName, t.toMap(), where: "id = ? AND user_id = ?", whereArgs: [t.id, userId]);
    return countOfUpdateRows == 1;
  }
}