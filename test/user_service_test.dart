import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/services/user_service.dart';

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  String? path;
  Map? data;

  @override
  Future<T> post<T>(
    String requestPath, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    path = requestPath;
    this.data = data;
    return <dynamic>[] as T;
  }
}

void main() {
  test('user media requests use the requested page size', () async {
    final client = _TestClient();
    final service = UserService(client: client);

    await service.notes(userId: 'target', withFiles: true, limit: 10);

    expect(client.path, '/users/notes');
    expect(client.data?['userId'], 'target');
    expect(client.data?['withFiles'], isTrue);
    expect(client.data?['limit'], 10);
  });

  test('user details can be requested in one batch', () async {
    final client = _TestClient();
    final service = UserService(client: client);

    final users = await service.showMany(userIds: ['user-a', 'user-b']);

    expect(client.path, '/users/show');
    expect(client.data, {
      'userIds': ['user-a', 'user-b'],
    });
    expect(users, isEmpty);
  });

  test('user notes support pagination in both directions', () async {
    final client = _TestClient();
    final service = UserService(client: client);

    await service.notes(
      userId: 'target',
      sinceId: 'newer-than-this',
      untilId: 'older-than-this',
      allowPartial: true,
      limit: 10,
    );

    expect(client.data?['sinceId'], 'newer-than-this');
    expect(client.data?['untilId'], 'older-than-this');
    expect(client.data?['allowPartial'], isTrue);
  });
}
