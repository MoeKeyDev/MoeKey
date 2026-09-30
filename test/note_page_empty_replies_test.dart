import 'package:moekey/status/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/notes/note_page.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/server.dart';

class _TestCurrentLoginUser extends CurrentLoginUser {
  @override
  LoginUser build() {
    return LoginUser(
      serverUrl: 'https://example.com',
      token: 'token',
      userInfo: UserFullModel(
        createdAt: DateTime.utc(2026, 7, 28),
        followersCount: 0,
        followingCount: 0,
        id: 'me',
        notesCount: 0,
        onlineStatus: OnlineStatus.unknown,
        username: 'me',
      ),
      name: 'me',
      id: 'me',
    );
  }
}

class _NoSocket extends MoekeyWebSocket {
  @override
  Future<WebSocketChannel?> build() async => null;
}

class _EmptyReplies extends NotesService {
  _EmptyReplies()
    : super(
        client: MisskeyApisHttpClient(
          host: 'http://localhost',
          accessToken: '',
          onUnauthorized: null,
        ),
      );
  int requests = 0;
  @override
  Future<NoteModel?> show({required String noteId}) async =>
      _note(noteId)..repliesCount = 1;
  @override
  Future<List<NoteModel>> children({
    required String noteId,
    int limit = 30,
    String? untilId,
  }) async {
    requests++;
    return [];
  }
}

NoteModel _note(String id) {
  return NoteModel(
    id: id,
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
      onlineStatus: OnlineStatus.unknown,
      username: 'user',
    ),
    userId: 'user-id',
    visibility: NoteVisibility.public,
  );
}

void main() {
  testWidgets(
    'empty replies settle without repeatedly remounting the reply list',
    (tester) async {
      final service = _EmptyReplies();
      final apis = MisskeyApis(
        instance: 'http://localhost',
        accessToken: '',
        onUnauthorized: null,
      )..notes = service;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyApisProvider.overrideWithValue(apis),
            moekeyWebSocketProvider.overrideWith(_NoSocket.new),
            currentLoginUserProvider.overrideWith(_TestCurrentLoginUser.new),
            apiEmojisListProvider.overrideWith((ref) async => []),
            instanceMetaProvider.overrideWith((ref) async => null),
          ],
          child: MaterialApp(
            localizationsDelegates: [S.delegate],
            home: const NotesPage(noteId: 'note'),
          ),
        ),
      );
      // A stale reply count is normal when replies have been deleted or hidden.
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(service.requests, 1);
      final button = find.byKey(const ValueKey('older-author-notes-note'));
      expect(button, findsOneWidget);
      final buttonBox = find
          .descendant(of: button, matching: find.byType(AnimatedSize))
          .first;
      final top = tester.getTopLeft(buttonBox).dy;
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.getTopLeft(buttonBox).dy, top);
      }
      expect(service.requests, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
