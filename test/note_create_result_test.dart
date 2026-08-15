import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/status/notes_listener.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/websocket.dart';
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

  test('notes/update response exposes the updated note', () {
    final updated = _note('note-id')..text = 'updated';

    final decoded = decodeUpdatedNoteResponse({
      'updatedNote': updated.toJson(),
    });

    expect(decoded.id, 'note-id');
    expect(decoded.text, 'updated');
  });

  test('submitted edit fields replace a stale notes/update response', () {
    final staleResponse = _note('note-id')
      ..text = 'before'
      ..cw = 'old warning'
      ..reactions = {'like': 3};
    final state = NoteCreateDialogStateModel()
      ..text = 'after'
      ..cw = ''
      ..isCw = false;

    final updated = applySubmittedEditFields(staleResponse, state);

    expect(updated.text, 'after');
    expect(updated.cw, isNull);
    expect(updated.textAst, isNotEmpty);
    expect(updated.reactions, {'like': 3});
  });

  test(
    'notes/update without a response body falls back to the source note',
    () {
      final source = _note('note-id');

      expect(decodeUpdatedNoteResponse(null, fallback: source), same(source));
    },
  );

  test('editing mutates the list-owned note instance in place', () {
    final listNote = _note('note-id')
      ..text = 'before'
      ..cw = 'old warning'
      ..reactions = {'like': 3};
    final updated = _note('note-id')
      ..text = 'after'
      ..cw = null
      ..reactions = {'like': 0};

    applyEditableNoteFields(listNote, updated);

    expect(listNote.text, 'after');
    expect(listNote.cw, isNull);
    expect(listNote.reactions, {'like': 3});
  });

  test('local edit event reaches an active NoteListener provider', () async {
    final listNote = _note('note-id')
      ..text = 'before'
      ..reactions = {'like': 3};
    final updated = _note('note-id')
      ..text = 'after'
      ..reactions = {'like': 0};
    final container = ProviderContainer(
      overrides: [
        currentLoginUserProvider.overrideWithValue(null),
        moekeyWebSocketProvider.overrideWithBuild((_, _) => null),
      ],
    );
    var notifications = 0;
    final subscription = container.listen(
      noteListenerProvider(listNote),
      (_, _) => notifications++,
      fireImmediately: true,
    );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    container.read(notesListenerProvider.notifier).emitNoteUpdated(updated);

    expect(container.read(noteListenerProvider(listNote)), same(listNote));
    expect(listNote.text, 'after');
    expect(listNote.reactions, {'like': 3});
    expect(notifications, 2);
  });

  test(
    'note update payload only contains fields supported by notes/update',
    () {
      final state = NoteCreateDialogStateModel()
        ..editId = 'note-id'
        ..text = 'updated'
        ..cw = 'content warning'
        ..isCw = true
        ..fileIds = ['file-id']
        ..visibility = NoteVisibility.followers
        ..localOnly = true;

      expect(buildNoteUpdateData(state), {
        'noteId': 'note-id',
        'text': 'updated',
        'cw': 'content warning',
        'fileIds': ['file-id'],
      });
    },
  );

  test('note update payload omits empty fileIds for compatible instances', () {
    final state = NoteCreateDialogStateModel()
      ..editId = 'note-id'
      ..text = 'updated'
      ..fileIds = [];

    expect(buildNoteUpdateData(state), {
      'noteId': 'note-id',
      'text': 'updated',
      'cw': null,
    });
  });

  test('redraft and edit forms restore the original note settings', () {
    final original = _note('note-id')
      ..text = 'original text'
      ..cw = 'content warning'
      ..localOnly = true
      ..visibility = NoteVisibility.specified
      ..visibleUserIds = ['recipient-id'];
    final state = NoteCreateDialogStateModel()..applyInitialNote(original);

    expect(state.text, 'original text');
    expect(state.cw, 'content warning');
    expect(state.isCw, isTrue);
    expect(state.localOnly, isTrue);
    expect(state.visibility, NoteVisibility.specified);
    expect(state.visibleUserIds, ['recipient-id']);
  });

  test('redraft deletes the original only when publishing', () async {
    final calls = <String>[];
    final state = NoteCreateDialogStateModel()
      ..deleteOnPostId = 'original-note-id';

    expect(calls, isEmpty);

    final result = await publishAfterDeletingOriginal(
      deleteOnPostId: state.deleteOnPostId,
      deleteOriginal: (noteId) async => calls.add('delete:$noteId'),
      publish: () async {
        calls.add('publish');
        return 'created-note-id';
      },
    );

    expect(result, 'created-note-id');
    expect(calls, ['delete:original-note-id', 'publish']);
  });

  test('ordinary publishing never requests deletion', () async {
    final calls = <String>[];

    await publishAfterDeletingOriginal(
      deleteOnPostId: null,
      deleteOriginal: (noteId) async => calls.add('delete:$noteId'),
      publish: () async => calls.add('publish'),
    );

    expect(calls, ['publish']);
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
