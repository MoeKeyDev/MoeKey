import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/status/note_deletion_registry.dart';

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

NoteModel _note(String id, {NoteModel? renote, String? text = 'text'}) {
  return NoteModel(
    id: id,
    createdAt: DateTime.utc(2026),
    files: [],
    localOnly: false,
    reactionEmojis: {},
    reactions: {},
    renote: renote,
    renoteId: renote?.id,
    text: text,
    user: _user,
    userId: _user.id,
    visibility: NoteVisibility.public,
  );
}

void main() {
  test('Riverpod deletion state filters notes in every shared list', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final original = _note('original');
    final pureRenote = _note('renote', renote: original, text: null);
    final unrelated = _note('unrelated');

    container.read(deletedNoteIdsProvider.notifier).markDeleted(original.id);
    final deletedIds = container.read(deletedNoteIdsProvider);

    expect(deletedIds, contains(original.id));
    expect(excludeDeletedNotes([original, pureRenote, unrelated], deletedIds), [
      unrelated,
    ]);
  });
}
