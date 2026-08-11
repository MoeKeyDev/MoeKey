import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog_state.dart';
import 'package:moekey/widgets/notes/note_children.dart';

const _user = UserLiteModel(
  avatarBlurhash: null,
  avatarDecorations: [],
  avatarUrl: null,
  emojis: {},
  host: null,
  id: 'user-id',
  makeNotesFollowersOnlyBefore: null,
  makeNotesHiddenBefore: null,
  name: 'User',
  onlineStatus: OnlineStatus.unknown,
  username: 'user',
);

NoteModel _note(String id, {String? replyId}) {
  return NoteModel(
    id: id,
    createdAt: DateTime.utc(2026),
    files: [],
    localOnly: false,
    reactionEmojis: {},
    reactions: {},
    replyId: replyId,
    text: id,
    user: _user,
    userId: _user.id,
    visibility: NoteVisibility.public,
  );
}

void main() {
  test('notes/create response exposes the created note', () {
    final created = _note('reply-id', replyId: 'parent-id');

    final decoded = decodeCreatedNoteResponse({
      'createdNote': created.toJson(),
    });

    expect(decoded.id, 'reply-id');
    expect(decoded.replyId, 'parent-id');
  });

  test('created note response must include createdNote', () {
    expect(
      () => decodeCreatedNoteResponse(<String, dynamic>{}),
      throwsFormatException,
    );
  });

  test('locally posted replies are prepended and deduplicated', () {
    final existing = _note('existing', replyId: 'parent-id');
    final posted = _note('posted', replyId: 'parent-id');

    final merged = mergeReplyNotes([existing, posted], [posted]);

    expect(merged.map((note) => note.id), ['posted', 'existing']);
  });

  test('reply visibility never extends beyond the target note', () {
    expect(
      resolveReplyVisibility(NoteVisibility.public, NoteVisibility.home),
      NoteVisibility.home,
    );
    expect(
      resolveReplyVisibility(NoteVisibility.followers, NoteVisibility.home),
      NoteVisibility.followers,
    );
    expect(
      resolveReplyVisibility(NoteVisibility.public, NoteVisibility.followers),
      NoteVisibility.followers,
    );
    expect(
      resolveReplyVisibility(NoteVisibility.public, NoteVisibility.specified),
      NoteVisibility.specified,
    );
    expect(
      resolveReplyVisibility(
        NoteVisibility.specified,
        NoteVisibility.followers,
      ),
      NoteVisibility.specified,
    );
  });

  test('specified visibility includes recipient ids and is not local', () {
    final state = NoteCreateDialogStateModel()
      ..visibility = NoteVisibility.specified
      ..localOnly = true
      ..visibleUserIds.addAll(['recipient-a', 'recipient-b']);

    expect(state.toMap()['visibleUserIds'], ['recipient-a', 'recipient-b']);
    expect(state.toMap()['localOnly'], isFalse);
  });
}
