import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/services/account_service.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/notifications.dart';
import 'package:moekey/status/websocket.dart';

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  int notificationRequests = 0;

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    if (path == '/i/notifications-grouped') {
      notificationRequests++;
      return <dynamic>[] as T;
    }
    if (path == '/notes/mentions') {
      return <dynamic>[] as T;
    }
    return null as T;
  }
}

MisskeyApis _testApis(_TestClient client) {
  final apis = MisskeyApis(
    instance: 'http://localhost',
    accessToken: '',
    onUnauthorized: null,
  );
  apis.account = AccountService(client: client);
  apis.notes = NotesService(client: client);
  return apis;
}

void main() {
  test('new notification refreshes the cached notification list', () async {
    final client = _TestClient();
    final container = ProviderContainer(
      overrides: [misskeyApisProvider.overrideWithValue(_testApis(client))],
    );
    final subscription = container.listen(
      notificationsProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    final notifications = await container.read(notificationsProvider.future);
    expect(client.notificationRequests, 1);
    expect(notifications.hasMore, isFalse);

    moekeyStreamMainChannelController.add({
      'type': 'notification',
      'body': {'id': 'notification-1'},
    });
    moekeyStreamMainChannelController.add({
      'type': 'notification',
      'body': {'id': 'notification-2'},
    });

    await _waitUntil(() => client.notificationRequests == 2);
    await container.read(notificationsProvider.future);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    expect(client.notificationRequests, 2);

    moekeyStreamMainChannelController.add({
      'type': 'unreadNotification',
      'body': {'id': 'notification-2'},
    });
    await Future<void>.delayed(const Duration(milliseconds: 250));
    expect(client.notificationRequests, 2);
  });

  test('empty mentions stop pagination', () async {
    final client = _TestClient();
    final container = ProviderContainer(
      overrides: [misskeyApisProvider.overrideWithValue(_testApis(client))],
    );
    addTearDown(container.dispose);

    final mentions = await container.read(
      mentionsNotificationsProvider().future,
    );
    final messages = await container.read(
      mentionsNotificationsProvider(specified: true).future,
    );

    expect(mentions.hasMore, isFalse);
    expect(messages.hasMore, isFalse);
  });
}

Future<void> _waitUntil(bool Function() condition) async {
  final timeout = DateTime.now().add(const Duration(seconds: 3));
  while (!condition()) {
    if (DateTime.now().isAfter(timeout)) {
      fail('Timed out waiting for the notification list to refresh.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
