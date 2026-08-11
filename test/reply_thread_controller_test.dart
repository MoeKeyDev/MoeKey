import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/widgets/notes/reply_thread_controller.dart';

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

NoteModel _note(String id, {String? replyId, int repliesCount = 0}) {
  return NoteModel(
    id: id,
    createdAt: DateTime.utc(2026),
    files: [],
    localOnly: false,
    reactionEmojis: {},
    reactions: {},
    repliesCount: repliesCount,
    replyId: replyId,
    text: id,
    user: _user,
    userId: _user.id,
    visibility: NoteVisibility.public,
  );
}

void main() {
  test(
    'loads reply data recursively but exposes one flat ordered list',
    () async {
      final posted = StreamController<NoteModel>.broadcast(sync: true);
      addTearDown(posted.close);
      final requests = <(String, int, String?)>[];
      final replies = <String, List<NoteModel>>{
        'root': [
          _note('a', replyId: 'root', repliesCount: 1),
          _note('b', replyId: 'root'),
        ],
        'a': [_note('a-1', replyId: 'a', repliesCount: 1)],
        'a-1': [_note('a-2', replyId: 'a-1')],
      };
      final controller = ReplyThreadController(
        rootNoteId: 'root',
        postedNotes: posted.stream,
        maxDepth: 3,
        loadChildren: (noteId, limit, untilId) async {
          requests.add((noteId, limit, untilId));
          return replies[noteId] ?? [];
        },
      );
      addTearDown(controller.dispose);

      await controller.loadInitial();

      expect(controller.entries.map((entry) => entry.note.id), [
        'a',
        'a-1',
        'a-2',
        'b',
      ]);
      expect(controller.entries.map((entry) => entry.depth), [0, 1, 2, 0]);
      expect(requests, [('root', 30, null), ('a', 5, null), ('a-1', 5, null)]);
    },
  );

  test('inserts locally posted replies once using their parent id', () async {
    final posted = StreamController<NoteModel>.broadcast(sync: true);
    addTearDown(posted.close);
    final existing = _note('existing', replyId: 'root');
    final controller = ReplyThreadController(
      rootNoteId: 'root',
      postedNotes: posted.stream,
      loadChildren: (noteId, limit, untilId) async => [existing],
    );
    addTearDown(controller.dispose);
    await controller.loadInitial();

    final local = _note('local', replyId: 'root');
    posted.add(local);
    posted.add(local);

    expect(controller.entries.map((entry) => entry.note.id), [
      'local',
      'existing',
    ]);
  });

  test(
    'a local nested reply becomes visible without a recursive widget',
    () async {
      final posted = StreamController<NoteModel>.broadcast(sync: true);
      addTearDown(posted.close);
      final parent = _note('parent', replyId: 'root');
      final controller = ReplyThreadController(
        rootNoteId: 'root',
        postedNotes: posted.stream,
        loadChildren: (noteId, limit, untilId) async => [parent],
      );
      addTearDown(controller.dispose);
      await controller.loadInitial();

      posted.add(_note('nested', replyId: 'parent'));

      expect(controller.entries.map((entry) => entry.note.id), [
        'parent',
        'nested',
      ]);
      expect(controller.entries.map((entry) => entry.depth), [0, 1]);
    },
  );

  test(
    'paginates only root replies with the last remote reply as cursor',
    () async {
      final posted = StreamController<NoteModel>.broadcast(sync: true);
      addTearDown(posted.close);
      final requests = <(String, int, String?)>[];
      final controller = ReplyThreadController(
        rootNoteId: 'root',
        rootLimit: 2,
        postedNotes: posted.stream,
        loadChildren: (noteId, limit, untilId) async {
          requests.add((noteId, limit, untilId));
          if (untilId == null) {
            return [_note('a', replyId: 'root'), _note('b', replyId: 'root')];
          }
          return [_note('c', replyId: 'root')];
        },
      );
      addTearDown(controller.dispose);

      await controller.loadInitial();
      expect(controller.hasMoreRootReplies, isTrue);
      posted.add(_note('local', replyId: 'root'));
      await controller.loadMoreRoot();

      expect(requests, [('root', 2, null), ('root', 2, 'b')]);
      expect(controller.entries.map((entry) => entry.note.id), [
        'local',
        'a',
        'b',
        'c',
      ]);
      expect(controller.hasMoreRootReplies, isFalse);
    },
  );

  test('recursively loads children of a newly paginated root reply', () async {
    final posted = StreamController<NoteModel>.broadcast(sync: true);
    addTearDown(posted.close);
    final requests = <(String, int, String?)>[];
    final controller = ReplyThreadController(
      rootNoteId: 'root',
      rootLimit: 1,
      postedNotes: posted.stream,
      loadChildren: (noteId, limit, untilId) async {
        requests.add((noteId, limit, untilId));
        if (noteId == 'paged') {
          return [_note('nested', replyId: 'paged')];
        }
        if (untilId == null) return [_note('first', replyId: 'root')];
        return [_note('paged', replyId: 'root', repliesCount: 1)];
      },
    );
    addTearDown(controller.dispose);

    await controller.loadInitial();
    await controller.loadMoreRoot();

    expect(requests, [
      ('root', 1, null),
      ('root', 1, 'first'),
      ('paged', 5, null),
    ]);
    expect(controller.entries.map((entry) => entry.note.id), [
      'first',
      'paged',
      'nested',
    ]);
    expect(controller.entries.map((entry) => entry.depth), [0, 0, 1]);
  });
}
