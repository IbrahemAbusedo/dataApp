import 'package:get/get.dart';
import 'package:vp18_data_app/database/controllers/note_db_controller.dart';
import 'package:vp18_data_app/models/note.dart';
import 'package:vp18_data_app/models/process_response.dart';

class NoteGetxController extends GetxController {

  static NoteGetxController get to => Get.find<NoteGetxController>();

  RxBool loading = false.obs;
  RxList<Note> notes = <Note>[].obs;

  final NoteDbController _controller = NoteDbController();

  // TODO: Alt + Insert -> Override Methods -> onInit .
  @override
  void onInit() {
    read();
    super.onInit();
  }

  Future<ProcessResponse> create(Note note) async {
    int newRowId = await _controller.create(note);
    if (newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      // notifyListeners();
      // update();
    }
    return getResponse(newRowId != 0);
  }

  void read() async {
    loading.value = true;
    notes.value = await _controller.read();
    loading.value = false;
    // notifyListeners();
    // update();
  }

  Future<ProcessResponse> updateNote(Note note) async {
    bool updated = await _controller.update(note);
    if (updated) {
      int index = notes.indexWhere((element) => element.id == note.id);
      if (index != -1) {
        notes[index] = note;
        // notifyListeners();
        // update();
      }
    }
    return getResponse(updated);
  }

  Future<ProcessResponse> delete(int index) async {
    bool deleted = await _controller.delete(notes[index].id);
    if (deleted) {
      notes.removeAt(index);
      // notifyListeners();
      // update();
    }
    return getResponse(deleted);
  }

  ProcessResponse getResponse(bool success) {
    return ProcessResponse(
        success ? 'Operation completed successfully' : 'Operation failed',
        success);
  }
}
