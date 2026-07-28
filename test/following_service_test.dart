import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/services/following_service.dart';

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  String? lastPath;
  Map? lastData;

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    lastPath = path;
    lastData = data;
    return [
          {
            'id': 'request-1',
            'follower': _user(id: 'follower', username: 'alice'),
            'followee': _user(id: 'followee', username: 'bob'),
          },
        ]
        as T;
  }
}

Map<String, dynamic> _user({required String id, required String username}) {
  return {
    'avatarBlurhash': null,
    'avatarDecorations': <dynamic>[],
    'avatarUrl': null,
    'emojis': <String, String>{},
    'host': null,
    'id': id,
    'makeNotesFollowersOnlyBefore': null,
    'makeNotesHiddenBefore': null,
    'name': username,
    'onlineStatus': 'unknown',
    'username': username,
  };
}

void main() {
  late _TestClient client;
  late FollowingService service;

  setUp(() {
    client = _TestClient();
    service = FollowingService(client: client);
  });

  test('loads sent follow requests with a since-id cursor', () async {
    final requests = await service.requestsSent(
      limit: 5,
      sinceId: 'newer-than',
    );

    expect(client.lastPath, '/following/requests/sent');
    expect(client.lastData, {'limit': 5, 'sinceId': 'newer-than'});
    expect(requests.single.id, 'request-1');
    expect(requests.single.follower.username, 'alice');
    expect(requests.single.followee.username, 'bob');
  });
}
