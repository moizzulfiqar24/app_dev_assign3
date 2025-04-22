import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/note_model.dart';
import '../utils/shared_pref_util.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final List<Note> _noteList = [];

  NoteBloc() : super(NoteInitial()) {
    on<LoadNotes>((_, emit) async {
      final storedNotes = await SharedPrefUtil.retrieveNotes();
      _noteList
        ..clear()
        ..addAll(storedNotes);
      _reorderPinnedFirst();
      emit(NotesLoaded(List.of(_noteList)));
    });

    on<AddNote>((event, emit) async {
      _noteList.add(event.note);
      _reorderPinnedFirst();
      await SharedPrefUtil.persistNotes(_noteList);
      emit(NotesLoaded(List.of(_noteList)));
    });

    on<UpdateNote>((event, emit) async {
      final idx = _noteList.indexOf(event.oldNote);
      if (idx >= 0) {
        _noteList[idx] = event.updatedNote;
        _reorderPinnedFirst();
        await SharedPrefUtil.persistNotes(_noteList);
        emit(NotesLoaded(List.of(_noteList)));
      }
    });

    on<DeleteNote>((event, emit) async {
      _noteList.remove(event.note);
      _reorderPinnedFirst();
      await SharedPrefUtil.persistNotes(_noteList);
      emit(NotesLoaded(List.of(_noteList)));
    });

    on<TogglePinNote>((event, emit) async {
      final idx = _noteList.indexOf(event.note);
      if (idx >= 0) {
        _noteList[idx].isPinned = !_noteList[idx].isPinned;
        _reorderPinnedFirst();
        await SharedPrefUtil.persistNotes(_noteList);
        emit(NotesLoaded(List.of(_noteList)));
      }
    });
  }

  void _reorderPinnedFirst() {
    _noteList.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });
  }
}
