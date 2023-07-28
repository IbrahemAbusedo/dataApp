import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp18_data_app/bloc/events/crud_event.dart';
import 'package:vp18_data_app/bloc/states/crud_state.dart';
import 'package:vp18_data_app/database/controllers/note_db_controller.dart';
import 'package:vp18_data_app/models/note.dart';

/// {@template bloc}
/// Takes a `Stream` of `Events` as input
/// and transforms them into a `Stream` of `States` as output.
/// {@end_template}

// class NoteBloc extends Bloc<Event, State>{}

class NoteBloc extends Bloc<CrudEvent, CrudState> {
  NoteBloc(super.initialState) {
    on<CreateEvent<Note>>(_onCreateEvent);
    on<ReadEvent>(_onReadEvent);
    on<UpdateEvent<Note>>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  final NoteDbController _controller = NoteDbController();
  List<Note> _notes = <Note>[];

  void _onCreateEvent(CreateEvent<Note> event, Emitter<CrudState> emit) async {
    int id = await _controller.create(event.t);
    if (id != 0) {
      event.t.id = id;
      _notes.add(event.t);
      emit(ReadState<Note>(_notes));
    }
    emit(ProcessState(id != 0 ? "Operations success" : "Operations failed",
        id != 0, ProcessType.create));
  }

  void _onReadEvent(ReadEvent event, Emitter<CrudState> emit) async {
    emit(LoadingState());
    _notes = await _controller.read();
    emit(ReadState<Note>(_notes));
  }

  void _onUpdateEvent(UpdateEvent<Note> event, Emitter<CrudState> emit) async {
    bool updated = await _controller.update(event.t);
    if (updated) {
      int index = _notes.indexWhere((element) => element.id == event.t.id);
      if (index != -1) {
        _notes[index] = event.t;
        emit(ReadState<Note>(_notes));
      }
    }
    emit(ProcessState(updated ? "Operations success" : "Operations failed",
        updated, ProcessType.update));
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<CrudState> emit) async {
    bool deleted = await _controller.delete(_notes[event.index].id);
    if (deleted) {
      _notes.removeAt(event.index);
      emit(ReadState<Note>(_notes));
    }
    emit(ProcessState(deleted ? "Operations success" : "Operations failed",
        deleted, ProcessType.delete));
  }
}
