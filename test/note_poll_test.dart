import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/widgets/notes/note_poll.dart';

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(
        host: 'http://localhost',
        accessToken: 'token',
        onUnauthorized: null,
      );

  String? path;
  Map? data;

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    this.path = path;
    this.data = data;
    return null as T;
  }
}

NoteModel _note({
  bool multiple = false,
  bool firstChoiceVoted = false,
  DateTime? expiresAt,
}) {
  return NoteModel(
    id: 'note-id',
    createdAt: DateTime(2026),
    files: [],
    localOnly: false,
    reactionEmojis: {},
    reactions: {},
    user: const UserLiteModel(
      avatarBlurhash: null,
      avatarDecorations: [],
      avatarUrl: null,
      emojis: {},
      host: null,
      id: 'user-id',
      makeNotesFollowersOnlyBefore: null,
      makeNotesHiddenBefore: null,
      name: 'User',
      onlineStatus: OnlineStatus.UNKNOWN,
      username: 'user',
    ),
    userId: 'user-id',
    visibility: NoteVisibility.public,
    poll: NotePollModel(
      multiple: multiple,
      expiresAt: expiresAt,
      choices: [
        NotePollModelChoices(
          votes: firstChoiceVoted ? 2 : 1,
          text: '选项 A',
          isVoted: firstChoiceVoted,
        ),
        const NotePollModelChoices(votes: 1, text: '选项 B', isVoted: false),
      ],
    ),
  );
}

Future<void> _pumpPoll(
  WidgetTester tester,
  NoteModel note, {
  required NotePollVote onVote,
}) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: NotePoll(data: note, onVote: onVote),
          ),
        ),
      ),
    ),
  );
}

Future<void> _confirmVote(WidgetTester tester, String choice) async {
  await tester.tap(find.text(choice));
  await tester.pumpAndSettle();
  expect(find.text('确定投票给“$choice”吗？'), findsOneWidget);
  await tester.tap(find.text(S.current.ok));
  await tester.pumpAndSettle();
}

void main() {
  test('votePoll sends the Misskey endpoint payload', () async {
    final client = _TestClient();
    await NotesService(client: client).votePoll(noteId: 'note-id', choice: 1);

    expect(client.path, '/notes/polls/vote');
    expect(client.data, {'noteId': 'note-id', 'choice': 1});
  });

  testWidgets('single-choice poll votes and then prevents another vote', (
    tester,
  ) async {
    final note = _note();
    final calls = <(String, int)>[];
    await _pumpPoll(
      tester,
      note,
      onVote: (noteId, choice) async => calls.add((noteId, choice)),
    );

    await _confirmVote(tester, '选项 A');

    expect(calls, [('note-id', 0)]);
    expect(note.poll!.choices[0].isVoted, isTrue);
    expect(note.poll!.choices[0].votes, 2);
    expect(find.textContaining(S.current.voteVoted), findsOneWidget);

    await tester.tap(find.text('选项 B'));
    await tester.pumpAndSettle();
    expect(calls, hasLength(1));
    expect(find.text('确定投票给“选项 B”吗？'), findsNothing);
  });

  testWidgets('multiple-choice poll permits each unselected choice once', (
    tester,
  ) async {
    final note = _note(multiple: true);
    final calls = <(String, int)>[];
    await _pumpPoll(
      tester,
      note,
      onVote: (noteId, choice) async => calls.add((noteId, choice)),
    );

    await _confirmVote(tester, '选项 A');
    await _confirmVote(tester, '选项 B');

    expect(calls, [('note-id', 0), ('note-id', 1)]);
    expect(note.poll!.choices.every((choice) => choice.isVoted), isTrue);

    await tester.tap(find.text('选项 A'));
    await tester.pumpAndSettle();
    expect(calls, hasLength(2));
  });

  testWidgets('expired poll does not open the vote confirmation', (
    tester,
  ) async {
    final note = _note(expiresAt: DateTime(2020));
    var called = false;
    await _pumpPoll(tester, note, onVote: (_, _) async => called = true);

    await tester.tap(find.text('选项 A'));
    await tester.pumpAndSettle();

    expect(called, isFalse);
    expect(find.textContaining(S.current.voteExpired), findsOneWidget);
    expect(find.text('确定投票给“选项 A”吗？'), findsNothing);
  });
}
