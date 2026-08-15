import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../apis/models/note.dart';

final deletedNoteIdsProvider = NotifierProvider<DeletedNoteIds, Set<String>>(
  DeletedNoteIds.new,
);

class DeletedNoteIds extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void markDeleted(String noteId) {
    state = {...state, noteId};
  }
}

bool isDeletedNoteEntry(NoteModel note, Set<String> deletedNoteIds) {
  if (deletedNoteIds.contains(note.id)) return true;
  final renote = note.renote;
  return note.text == null &&
      note.files.isEmpty &&
      renote != null &&
      deletedNoteIds.contains(renote.id);
}

List<NoteModel> excludeDeletedNotes(
  Iterable<NoteModel> notes,
  Set<String> deletedNoteIds,
) => [
  for (final note in notes)
    if (!isDeletedNoteEntry(note, deletedNoteIds)) note,
];
