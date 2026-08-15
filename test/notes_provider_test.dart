import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/notes.dart';

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  final conversationNoteIds = <String>[];

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    if (path == '/notes/show') {
      return _noteJson(
            'current',
            replyId: 'direct',
            reply: _noteJson('direct', replyId: 'middle'),
          )
          as T;
    }
    if (path == '/notes/conversation') {
      final noteId = data!['noteId'] as String;
      conversationNoteIds.add(noteId);
      return switch (noteId) {
            'direct' => [_noteJson('middle', replyId: 'root')],
            'middle' => [_noteJson('root')],
            _ => <Map<String, dynamic>>[],
          }
          as T;
    }
    throw StateError('Unexpected request: $path');
  }
}

Map<String, dynamic> _noteJson(
  String id, {
  String? replyId,
  Map<String, dynamic>? reply,
}) {
  return {
    'id': id,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'files': <dynamic>[],
    'localOnly': false,
    'reactionEmojis': <String, dynamic>{},
    'reactions': <String, int>{},
    'replyId': replyId,
    'reply': reply,
    'user': {
      'avatarBlurhash': null,
      'avatarDecorations': <dynamic>[],
      'avatarUrl': null,
      'emojis': <String, String>{},
      'host': null,
      'id': 'user-id',
      'makeNotesFollowersOnlyBefore': null,
      'makeNotesHiddenBefore': null,
      'name': 'User',
      'onlineStatus': 'unknown',
      'username': 'user',
    },
    'userId': 'user-id',
    'visibility': 'public',
  };
}

MisskeyApis _testApis(_TestClient client) {
  final apis = MisskeyApis(
    instance: 'http://localhost',
    accessToken: '',
    onUnauthorized: null,
  );
  apis.notes = NotesService(client: client);
  return apis;
}

void main() {
  test('note page provider loads the complete ancestor conversation', () async {
    final client = _TestClient();
    final container = ProviderContainer(
      overrides: [misskeyApisProvider.overrideWithValue(_testApis(client))],
    );
    addTearDown(container.dispose);

    final state = await container.read(notesProvider('current').future);

    expect(state.conversation.map((note) => note.id), [
      'root',
      'middle',
      'direct',
    ]);
    expect(client.conversationNoteIds, ['direct', 'middle']);
  });
}
