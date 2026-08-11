import 'dart:async';

import '../apis/models/note.dart';

/// Local notes/create success events.
///
/// The server stream remains the source of truth for timelines. This event is
/// used for UI that already has the returned note available, such as reply
/// counters and an open reply thread.
final StreamController<NoteModel> _notePostedController =
    StreamController<NoteModel>.broadcast(sync: true);

Stream<NoteModel> get notePostedStream => _notePostedController.stream;

void emitNotePosted(NoteModel note) {
  _notePostedController.add(note);
}
