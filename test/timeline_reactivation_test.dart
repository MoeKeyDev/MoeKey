import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/database/timeline.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/timeline/timeline_page.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/note_deletion_registry.dart';
import 'package:moekey/status/timeline.dart';
import 'package:moekey/status/websocket.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';

class _TestTimelineDatabase extends TimelineDatabase {
  _TestTimelineDatabase() : super(server: 'test', userId: 'test');

  @override
  Future<TimelineCacheData?> getTimeline(String name) async => null;

  @override
  Future<void> setTimeline(String name, List<NoteModel> list) async {}
}

class _TestNotesService extends NotesService {
  _TestNotesService({this.empty = false})
    : super(
        client: MisskeyApisHttpClient(
          host: 'http://localhost',
          accessToken: '',
          onUnauthorized: null,
        ),
      );

  final bool empty;
  int requests = 0;

  @override
  Future<List<NoteModel>> timeline({
    String api = 'timeline',
    int limit = 10,
    String? untilId,
    String? sinceId,
  }) async {
    requests++;
    if (empty) return [];
    if (requests == 1) return [_note('note-1')];
    return [_note('note-2'), _note('note-1')];
  }
}

class _DelayedNotesService extends _TestNotesService {
  final completer = Completer<List<NoteModel>>();

  @override
  Future<List<NoteModel>> timeline({
    String api = 'timeline',
    int limit = 10,
    String? untilId,
    String? sinceId,
  }) {
    requests++;
    return completer.future;
  }
}

class _FirstLocalLoadNotesService extends _TestNotesService {
  final localCompleter = Completer<List<NoteModel>>();

  @override
  Future<List<NoteModel>> timeline({
    String api = 'timeline',
    int limit = 10,
    String? untilId,
    String? sinceId,
  }) {
    requests++;
    if (api == 'local-timeline' && !localCompleter.isCompleted) {
      return localCompleter.future;
    }
    return Future.value([]);
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

MisskeyApis _testApis(_TestNotesService notes) {
  final apis = MisskeyApis(
    instance: 'http://localhost',
    accessToken: '',
    onUnauthorized: null,
  );
  apis.notes = notes;
  return apis;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('an active timeline receives notes from the shared broadcast', () async {
    final notes = _TestNotesService();
    final container = ProviderContainer(
      overrides: [
        timelineDatabaseProvider.overrideWith(
          (ref) async => _TestTimelineDatabase(),
        ),
        misskeyApisProvider.overrideWithValue(_testApis(notes)),
        moekeyWebSocketProvider.overrideWithBuild((ref, _) async => null),
      ],
    );
    final provider = timelineProvider(api: 'timeline');
    final subscription = container.listen(
      provider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    container.read(provider.notifier).setStreamActive(true);
    final initial = await container.read(provider.future);
    expect(initial.isLatestLoaded, isTrue);
    expect(initial.list.map((note) => note.id), ['note-1']);

    moekeyStreamController.add(
      MoekeyEvent(
        type: MoekeyEventType.data,
        data: {
          'type': 'channel',
          'body': {
            'id': 'timeline-timeline',
            'type': 'note',
            'body': jsonDecode(jsonEncode(_note('note-2').toJson())),
          },
        },
      ),
    );
    await container.pump();
    await Future<void>.delayed(Duration.zero);
    await container.pump();

    final updated = container.read(provider).value!;
    expect(updated.isLatestLoaded, isTrue);
    expect(updated.list.map((note) => note.id), ['note-2', 'note-1']);
    expect(notes.requests, 1);

    container.read(provider.notifier).setStreamActive(false);
    moekeyStreamController.add(
      MoekeyEvent(
        type: MoekeyEventType.data,
        data: {
          'type': 'channel',
          'body': {
            'id': 'timeline-timeline',
            'type': 'note',
            'body': jsonDecode(jsonEncode(_note('note-3').toJson())),
          },
        },
      ),
    );
    await container.pump();
    await Future<void>.delayed(Duration.zero);
    await container.pump();

    expect(
      container.read(provider).value!.list.map((note) => note.id),
      isNot(contains('note-3')),
    );
  });

  test('activation reconciliation is limited to one HTTP page', () async {
    final notes = _TestNotesService();
    final container = ProviderContainer(
      overrides: [
        timelineDatabaseProvider.overrideWith(
          (ref) async => _TestTimelineDatabase(),
        ),
        misskeyApisProvider.overrideWithValue(_testApis(notes)),
        moekeyWebSocketProvider.overrideWithBuild((ref, _) async => null),
      ],
    );
    final provider = timelineProvider(api: 'timeline');
    final subscription = container.listen(
      provider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    final notifier = container.read(provider.notifier)..setStreamActive(true);
    await container.read(provider.future);
    await notifier.refreshLatest(force: true);

    expect(container.read(provider).value!.list.map((note) => note.id), [
      'note-2',
      'note-1',
    ]);
    expect(notes.requests, 2);
  });

  test('deleting a note removes it from the timeline data source', () async {
    final notes = _TestNotesService();
    final container = ProviderContainer(
      overrides: [
        timelineDatabaseProvider.overrideWith(
          (ref) async => _TestTimelineDatabase(),
        ),
        misskeyApisProvider.overrideWithValue(_testApis(notes)),
        moekeyWebSocketProvider.overrideWithBuild((ref, _) async => null),
      ],
    );
    final provider = timelineProvider(api: 'timeline');
    final subscription = container.listen(
      provider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    await container.read(provider.future);
    expect(container.read(provider).value!.list, hasLength(1));

    container.read(deletedNoteIdsProvider.notifier).markDeleted('note-1');
    await container.pump();

    expect(container.read(provider).value!.list, isEmpty);
  });

  testWidgets('initial timeline loading shows the refresh indicator', (
    tester,
  ) async {
    final notes = _DelayedNotesService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timelineDatabaseProvider.overrideWith(
            (ref) async => _TestTimelineDatabase(),
          ),
          misskeyApisProvider.overrideWithValue(_testApis(notes)),
          moekeyWebSocketProvider.overrideWithBuild((ref, _) async => null),
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
          home: const TimelinePage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(RefreshProgressIndicator), findsOneWidget);

    notes.completer.complete([]);
    await tester.pumpAndSettle();
  });

  testWidgets('a timeline tab shows the indicator only on its first visit', (
    tester,
  ) async {
    final notes = _FirstLocalLoadNotesService();
    final tabKey = GlobalKey<MkTabBarRefreshScrollState>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timelineDatabaseProvider.overrideWith(
            (ref) async => _TestTimelineDatabase(),
          ),
          misskeyApisProvider.overrideWithValue(_testApis(notes)),
          moekeyWebSocketProvider.overrideWithBuild((ref, _) async => null),
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
          home: TimelinePage(mkTabBarListKey: tabKey),
        ),
      ),
    );
    await tester.pumpAndSettle();

    tabKey.currentState!.tabController.animateTo(1);
    await tester.pump();
    // Finish the tab transition without waiting for the intentionally pending
    // refresh animation to settle.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(RefreshProgressIndicator), findsOneWidget);

    notes.localCompleter.complete([]);
    await tester.pumpAndSettle();
    tabKey.currentState!.tabController.animateTo(0);
    await tester.pumpAndSettle();
    tabKey.currentState!.tabController.animateTo(1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(RefreshProgressIndicator), findsNothing);
  });

  testWidgets('switching every timeline tab does not mutate during build', (
    tester,
  ) async {
    final notes = _TestNotesService(empty: true);
    final tabKey = GlobalKey<MkTabBarRefreshScrollState>();
    final shellVisible = ValueNotifier(true);
    addTearDown(shellVisible.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timelineDatabaseProvider.overrideWith(
            (ref) async => _TestTimelineDatabase(),
          ),
          misskeyApisProvider.overrideWithValue(_testApis(notes)),
          moekeyWebSocketProvider.overrideWithBuild((ref, _) async => null),
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
          home: ValueListenableBuilder<bool>(
            valueListenable: shellVisible,
            builder: (context, visible, _) => TickerMode(
              enabled: visible,
              child: TimelinePage(mkTabBarListKey: tabKey),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(TimelinePage)),
    );
    expect(
      container
          .read(timelineProvider(api: 'timeline').notifier)
          .debugStreamActive,
      isTrue,
    );

    final homeLabel = find.byKey(const ValueKey('timeline-tab-label-0'));
    final localLabel = find.byKey(const ValueKey('timeline-tab-label-1'));
    final homeExpandedWidth = tester.getSize(homeLabel).width;
    expect(homeExpandedWidth, greaterThan(0));
    expect(tester.getSize(localLabel).width, 0);

    tabKey.currentState!.tabController.offset = 0.5;
    await tester.pump();
    expect(
      tester.getSize(homeLabel).width,
      inExclusiveRange(0, homeExpandedWidth),
    );
    expect(tester.getSize(localLabel).width, greaterThan(0));
    tabKey.currentState!.tabController.offset = 0;
    await tester.pump();

    tabKey.currentState!.tabController.animateTo(1);
    await tester.pumpAndSettle();
    expect(
      container
          .read(timelineProvider(api: 'timeline').notifier)
          .debugStreamActive,
      isFalse,
    );
    expect(
      container
          .read(timelineProvider(api: 'local-timeline').notifier)
          .debugStreamActive,
      isTrue,
    );
    moekeyStreamController.add(
      MoekeyEvent(
        type: MoekeyEventType.data,
        data: {
          'type': 'channel',
          'body': {
            'id': 'timeline-timeline',
            'type': 'note',
            'body': jsonDecode(jsonEncode(_note('hidden-home-note').toJson())),
          },
        },
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(
      container
          .read(timelineProvider(api: 'timeline'))
          .value!
          .list
          .map((note) => note.id),
      isNot(contains('hidden-home-note')),
    );

    for (final index in [2, 3, 0, 2, 0]) {
      tabKey.currentState!.tabController.animateTo(index);
      await tester.pump();
      await tester.pumpAndSettle();
    }

    shellVisible.value = false;
    await tester.pump();
    await tester.pump();
    for (final api in [
      'timeline',
      'local-timeline',
      'hybrid-timeline',
      'global-timeline',
    ]) {
      expect(
        container.read(timelineProvider(api: api).notifier).debugStreamActive,
        isFalse,
      );
    }
    moekeyStreamController.add(
      MoekeyEvent(
        type: MoekeyEventType.data,
        data: {
          'type': 'channel',
          'body': {
            'id': 'timeline-timeline',
            'type': 'note',
            'body': jsonDecode(jsonEncode(_note('hidden-shell-note').toJson())),
          },
        },
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(
      container
          .read(timelineProvider(api: 'timeline'))
          .value!
          .list
          .map((note) => note.id),
      isNot(contains('hidden-shell-note')),
    );

    expect(tester.takeException(), isNull);
  });
}
