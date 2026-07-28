import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/following_service.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/user.dart';

class _DelayedFollowClient extends MisskeyApisHttpClient {
  _DelayedFollowClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  final createCompleter = Completer<void>();

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    if (path == '/following/create') {
      await createCompleter.future;
      return null as T;
    }
    throw UnsupportedError(path);
  }
}

MisskeyApis _testApis(_DelayedFollowClient client) {
  final apis = MisskeyApis(
    instance: 'http://localhost',
    accessToken: '',
    onUnauthorized: null,
  );
  apis.following = FollowingService(client: client);
  return apis;
}

UserFullModel _user({bool isLocked = false}) {
  return UserFullModel(
    createdAt: DateTime.utc(2026, 7, 28),
    followersCount: 0,
    followingCount: 0,
    id: 'target-user',
    notesCount: 0,
    onlineStatus: OnlineStatus.unknown,
    isLocked: isLocked,
    username: 'target',
  );
}

void main() {
  test(
    'follow action publishes a distinct pending state before it completes',
    () async {
      final client = _DelayedFollowClient();
      final container = ProviderContainer(
        overrides: [misskeyApisProvider.overrideWithValue(_testApis(client))],
      );
      addTearDown(container.dispose);

      final provider = userInfoProvider(userModel: _user());
      final initial = await container.read(provider.future);
      final follow = container.read(provider.notifier).followingCreate();

      final pending = container.read(provider).value;
      expect(pending, isNot(same(initial)));
      expect(pending?.hasPendingFollowRequestFromYou, isTrue);

      client.createCompleter.complete();
      await follow;

      final completed = container.read(provider).value;
      expect(completed?.isFollowing, isTrue);
      expect(completed?.hasPendingFollowRequestFromYou, isFalse);
    },
  );

  test('locked users remain pending after a follow request succeeds', () async {
    final client = _DelayedFollowClient();
    final container = ProviderContainer(
      overrides: [misskeyApisProvider.overrideWithValue(_testApis(client))],
    );
    addTearDown(container.dispose);

    final provider = userInfoProvider(userModel: _user(isLocked: true));
    await container.read(provider.future);
    final follow = container.read(provider.notifier).followingCreate();

    client.createCompleter.complete();
    await follow;

    final completed = container.read(provider).value;
    expect(completed?.isFollowing, isFalse);
    expect(completed?.hasPendingFollowRequestFromYou, isTrue);
  });
}
