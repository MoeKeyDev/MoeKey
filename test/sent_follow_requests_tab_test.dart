import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/emojis.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/account_service.dart';
import 'package:moekey/apis/services/following_service.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/notifications/notifications_page.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/widgets/loading_weight.dart';

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

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  final paths = <String>[];

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    paths.add(path);
    if (path == '/following/requests/sent') {
      return [
            {
              'id': 'sent-1',
              'follower': _user(id: 'me', username: 'me'),
              'followee': _user(id: 'bob', username: 'bob'),
            },
          ]
          as T;
    }
    if (path == '/i/notifications-grouped' || path == '/notes/mentions') {
      return <dynamic>[] as T;
    }
    return null as T;
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

MisskeyApis _testApis(_TestClient client) {
  final apis = MisskeyApis(
    instance: 'http://localhost',
    accessToken: '',
    onUnauthorized: null,
  );
  apis.account = AccountService(client: client);
  apis.following = FollowingService(client: client);
  apis.notes = NotesService(client: client);
  return apis;
}

Future<void> _pumpNotifications(
  WidgetTester tester, {
  required _TestClient client,
  int initialIndex = 0,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentLoginUserProvider.overrideWith(_TestCurrentLoginUser.new),
        instanceMetaProvider.overrideWith((ref) async => null),
        apiEmojisProvider.overrideWith((ref) async => <String, EmojiSimple>{}),
        misskeyApisProvider.overrideWithValue(_testApis(client)),
      ],
      child: MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: NotificationsPage(initialIndex: initialIndex),
      ),
    ),
  );
}

void main() {
  testWidgets('sent requests are managed from a notifications tab', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();
    await _pumpNotifications(tester, client: client);
    await tester.pumpAndSettle();

    expect(find.text('关注请求'), findsOneWidget);
    expect(find.byIcon(TablerIcons.user), findsOneWidget);
    expect(find.byIcon(TablerIcons.upload), findsNothing);
    expect(client.paths, isNot(contains('/following/requests/sent')));

    await tester.tap(find.text('关注请求'));
    await tester.pumpAndSettle();

    expect(find.text('bob'), findsOneWidget);
    expect(client.paths, contains('/following/requests/sent'));

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('要取消申请关注bob吗？'), findsOneWidget);
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(client.paths, contains('/following/requests/cancel'));
    expect(find.byType(EmptyWidget), findsOneWidget);
  });

  testWidgets('legacy links can open the sent requests tab directly', (
    tester,
  ) async {
    final client = _TestClient();
    await _pumpNotifications(tester, client: client, initialIndex: 3);
    await tester.pumpAndSettle();

    expect(find.text('bob'), findsOneWidget);
    expect(client.paths, contains('/following/requests/sent'));
  });
}
