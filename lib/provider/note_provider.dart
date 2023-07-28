import 'package:flutter/material.dart';
import 'package:vp18_data_app/database/controllers/note_db_controller.dart';
import 'package:vp18_data_app/models/note.dart';
import 'package:vp18_data_app/models/process_response.dart';

class NoteProvider extends ChangeNotifier {

  bool loading = false;

  List<Note> notes = <Note>[];
  final NoteDbController _controller = NoteDbController();

  Future<ProcessResponse> create(Note note) async {
    int newRowId = await _controller.create(note);
    if(newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      notifyListeners();
    }
    return getResponse(newRowId != 0);
  }

  void read() async {
    loading = true;
    notes = await _controller.read();
    loading = false;
    notifyListeners();
  }

  Future<ProcessResponse> update(Note note) async {
    bool updated = await _controller.update(note);
    if(updated) {
      int index = notes.indexWhere((element) => element.id == note.id);
      if(index != -1) {
        notes[index] = note;
        notifyListeners();
      }
    }
    return getResponse(updated);
  }

  Future<ProcessResponse> delete(int index) async {
    bool deleted = await _controller.delete(notes[index].id);
    if(deleted) {
      notes.removeAt(index);
      notifyListeners();
    }
    return getResponse(deleted);
  }


  ProcessResponse getResponse(bool success) {
    return ProcessResponse(success ? 'Operation completed successfully' : 'Operation failed', success);
  }
}