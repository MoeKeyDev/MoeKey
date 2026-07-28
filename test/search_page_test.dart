import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/services/hashtags_service.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/apis/services/user_service.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/search/search_filter.dart';
import 'package:moekey/pages/search/search_page.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/widgets/blur_widget.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  final requests = <({String path, Map? data})>[];

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    requests.add((path: path, data: data));
    if (path == '/hashtags/trend') {
      return [
            {
              'tag': 'flutter',
              'chart': [0, 1, 3, 1],
              'usersCount': 3,
            },
          ]
          as T;
    }
    return <dynamic>[] as T;
  }
}

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

MisskeyApis _testApis(_TestClient client) {
  final apis = MisskeyApis(
    instance: 'http://localhost',
    accessToken: '',
    onUnauthorized: null,
  );
  apis.hashtags = HashtagsService(client: client);
  apis.notes = NotesService(client: client);
  apis.user = UserService(client: client);
  return apis;
}

Future<void> _pumpSearchPage(
  WidgetTester tester, {
  required _TestClient client,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        misskeyApisProvider.overrideWithValue(_testApis(client)),
        currentLoginUserProvider.overrideWith(_TestCurrentLoginUser.new),
        instanceMetaProvider.overrideWith((ref) async => null),
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
        home: const SearchPage(),
      ),
    ),
  );
}

Future<void> _pumpSearchPageInShell(
  WidgetTester tester, {
  required _TestClient client,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        misskeyApisProvider.overrideWithValue(_testApis(client)),
        currentLoginUserProvider.overrideWith(_TestCurrentLoginUser.new),
        instanceMetaProvider.overrideWith((ref) async => null),
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
        home: Row(
          children: [
            const SizedBox(
              key: ValueKey('test-sidebar'),
              width: 80,
              height: double.infinity,
            ),
            Expanded(
              child: Navigator(
                onGenerateRoute: (_) =>
                    MaterialPageRoute<void>(builder: (_) => const SearchPage()),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('search header submits and shares query between tabs', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();

    await _pumpSearchPage(tester, client: client);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('search-query-field')), findsOneWidget);
    expect(find.byType(MkAppbar), findsOneWidget);
    expect(find.byType(BlurWidget), findsOneWidget);
    expect(find.byKey(const ValueKey('search-trends-refresh')), findsOneWidget);
    expect(find.byType(MkRefreshIndicator), findsOneWidget);
    expect(find.byKey(const ValueKey('search-filter-button')), findsNothing);
    expect(find.text('帖子'), findsNothing);
    expect(find.text('用户'), findsNothing);
    expect(find.text('#flutter'), findsOneWidget);
    expect(find.text('3 · 用户数'), findsOneWidget);
    expect(
      client.requests.any((request) => request.path == '/hashtags/trend'),
      isTrue,
    );
    expect(find.widgetWithText(FilledButton, '搜索'), findsNothing);

    final searchBox = find.byKey(const ValueKey('search-query-field'));
    final trendsCard = find.byKey(const ValueKey('search-trends-card'));
    expect(tester.getTopLeft(searchBox).dx, greaterThanOrEqualTo(16));
    expect(tester.getSize(searchBox).height, 38);
    expect(tester.getTopLeft(trendsCard).dx, tester.getTopLeft(searchBox).dx);
    expect(
      tester.getTopLeft(trendsCard).dy,
      greaterThan(tester.getBottomLeft(searchBox).dy),
    );

    await tester.tap(searchBox);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('search-overlay')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('search-overlay-query-field')),
      findsOneWidget,
    );
    expect(find.text('选项'), findsOneWidget);
    expect(find.text('起始日期'), findsOneWidget);
    expect(find.text('终止日期'), findsOneWidget);
    expect(find.text('全部'), findsOneWidget);
    expect(find.text('本站'), findsOneWidget);
    expect(find.text('指定服务器'), findsOneWidget);
    expect(find.text('指定用户'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('search-overlay-filter-user')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('search-overlay-select-user')),
      findsOneWidget,
    );
    final selectUser = find.byKey(const ValueKey('search-overlay-select-user'));
    final selectSelf = find.byKey(const ValueKey('search-overlay-select-self'));
    expect(selectSelf, findsOneWidget);
    expect(tester.getSize(selectSelf).width, 150);
    expect(
      tester.getSize(selectSelf).height,
      tester.getSize(selectUser).height,
    );
    await tester.tap(selectSelf);
    await tester.pump();
    expect(
      find.byKey(const ValueKey('search-overlay-remove-user')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('search-overlay-filter-all')));
    await tester.pump();

    final field = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-query-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(field, 'cats');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('search-overlay')), findsNothing);
    expect(find.byKey(const ValueKey('search-filter-button')), findsNothing);
    expect(find.byKey(const ValueKey('search-results-back')), findsOneWidget);
    expect(find.text('帖子'), findsOneWidget);
    expect(find.text('用户'), findsOneWidget);
    final noteRequest = client.requests.lastWhere(
      (request) => request.path == '/notes/search',
    );
    expect(noteRequest.data?['query'], 'cats');

    await tester.tap(find.text('用户'));
    await tester.pumpAndSettle();

    expect(client.requests.last.path, '/users/search');
    expect(client.requests.last.data?['query'], 'cats');

    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('search-overlay')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('search-overlay-query-field')),
        matching: find.text('cats'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('search-overlay-close')));
    await tester.pump();
    expect(find.byKey(const ValueKey('search-overlay')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('search-overlay')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('search-results-back')));
    await tester.pumpAndSettle();

    expect(find.text('#flutter'), findsOneWidget);
    expect(find.text('帖子'), findsNothing);
    expect(find.byKey(const ValueKey('search-filter-button')), findsNothing);
  });

  testWidgets('shared filter applies local scope to both searches', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();

    await _pumpSearchPage(tester, client: client);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();

    final field = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-query-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(field, 'flutter');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('search-overlay-filter-local')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('search-overlay-submit')));
    await tester.pumpAndSettle();

    final noteRequest = client.requests.lastWhere(
      (request) => request.path == '/notes/search',
    );
    await tester.tap(find.text('用户'));
    await tester.pumpAndSettle();
    final userRequest = client.requests.lastWhere(
      (request) => request.path == '/users/search',
    );
    expect(noteRequest.data?['query'], 'flutter');
    expect(noteRequest.data?['host'], '.');
    expect(userRequest.data?['query'], 'flutter');
    expect(userRequest.data?['origin'], 'local');
  });

  testWidgets('specified host applies to note search', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();

    await _pumpSearchPage(tester, client: client);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();
    final queryField = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-query-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(queryField, 'alice');
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('search-overlay-filter-host')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('search-overlay-host-field')),
      findsOneWidget,
    );
    final hostField = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-host-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(hostField, 'example.com');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('search-overlay-submit')));
    await tester.pumpAndSettle();

    final noteRequest = client.requests.lastWhere(
      (request) => request.path == '/notes/search',
    );
    expect(noteRequest.data?['query'], 'alice');
    expect(noteRequest.data?['host'], 'example.com');
  });

  testWidgets('note date range uses backend range parameters', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();
    final start = DateTime(2026, 7, 1, 8, 30);
    final end = DateTime(2026, 7, 28, 18, 45);

    await _pumpSearchPage(tester, client: client);
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SearchPage)),
    );
    container
        .read(searchFilterProvider.notifier)
        .update(
          scope: SearchFilterScope.all,
          host: '',
          rangeStartAt: start,
          rangeEndAt: end,
        );

    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();
    expect(find.text('2026/07/01 08:30'), findsOneWidget);
    expect(find.text('2026/07/28 18:45'), findsOneWidget);
    final queryField = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-query-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(queryField, 'range');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    final request = client.requests.lastWhere(
      (request) => request.path == '/notes/search',
    );
    expect(request.data?['rangeStartAt'], start.millisecondsSinceEpoch);
    expect(request.data?['rangeEndAt'], end.millisecondsSinceEpoch);
  });

  testWidgets('specified user applies user id and host to note search', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();
    final user = UserFullModel(
      createdAt: DateTime.utc(2026, 7, 28),
      followersCount: 0,
      followingCount: 0,
      host: 'remote.example',
      id: 'user-1',
      notesCount: 0,
      onlineStatus: OnlineStatus.unknown,
      username: 'alice',
    );

    await _pumpSearchPage(tester, client: client);
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SearchPage)),
    );
    container
        .read(searchFilterProvider.notifier)
        .update(scope: SearchFilterScope.user, host: '', user: user);

    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('search-overlay-remove-user')),
      findsOneWidget,
    );
    final queryField = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-query-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(queryField, 'from user');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    final request = client.requests.lastWhere(
      (request) => request.path == '/notes/search',
    );
    expect(request.data?['userId'], 'user-1');
    expect(request.data?['host'], 'remote.example');
  });

  testWidgets('user search exposes only server-supported origin options', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();

    await _pumpSearchPage(tester, client: client);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();
    final queryField = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-query-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(queryField, 'alice');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.text('用户'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('search-overlay-start-date')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('search-overlay-end-date')), findsNothing);
    expect(
      find.byKey(const ValueKey('search-overlay-filter-host')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('search-overlay-filter-user')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('search-overlay-filter-remote')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('search-overlay-filter-remote')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('search-overlay-submit')));
    await tester.pumpAndSettle();

    final userRequest = client.requests.lastWhere(
      (request) => request.path == '/users/search',
    );
    expect(userRequest.data?['query'], 'alice');
    expect(userRequest.data?['origin'], 'remote');
    expect(userRequest.data?['offset'], 0);
  });

  testWidgets('search controls stay above tabs on wide screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1100, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();

    await _pumpSearchPage(tester, client: client);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();

    final field = find.descendant(
      of: find.byKey(const ValueKey('search-overlay-query-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(field, 'wide');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    final searchTop = tester.getTopLeft(
      find.byKey(const ValueKey('search-query-field')),
    );
    final postsTop = tester.getTopLeft(find.text('帖子'));

    expect(searchTop.dy, lessThan(postsTop.dy));
  });

  testWidgets('search overlay stays inside the shell content area', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1100, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final client = _TestClient();

    await _pumpSearchPageInShell(tester, client: client);
    await tester.pumpAndSettle();
    final modalBarrierCount = find.byType(ModalBarrier).evaluate().length;

    await tester.tap(find.byKey(const ValueKey('search-query-field')));
    await tester.pumpAndSettle();

    final sidebar = find.byKey(const ValueKey('test-sidebar'));
    final overlay = find.byKey(const ValueKey('search-overlay'));
    expect(overlay, findsOneWidget);
    expect(find.byType(ModalBarrier), findsNWidgets(modalBarrierCount));
    expect(tester.getTopLeft(overlay).dx, tester.getTopRight(sidebar).dx);
    expect(tester.getSize(overlay).width, 1020);
  });
}
