import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/emojis.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/following_service.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/notifications/notifications_group_list.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/reactions.dart';

class _TestCurrentLoginUser extends CurrentLoginUser {
  @override
  LoginUser? build() => null;
}

class _TestClient extends MisskeyApisHttpClient {
  _TestClient()
    : super(host: 'http://localhost', accessToken: '', onUnauthorized: null);

  Completer<void>? pending;
  Object? failure;
  String? lastPath;
  Map? lastData;
  bool pendingFollowRequest = true;
  bool isFollowed = false;
  final paths = <String>[];

  @override
  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    lastPath = path;
    lastData = data;
    paths.add(path);
    if (path == '/users/show') {
      return <String, dynamic>{
            'hasPendingFollowRequestToYou': pendingFollowRequest,
            'isFollowed': isFollowed,
          }
          as T;
    }
    await pending?.future;
    if (failure case final failure?) {
      throw failure;
    }
    if (path == '/following/requests/accept') {
      pendingFollowRequest = false;
      isFollowed = true;
    } else if (path == '/following/requests/reject') {
      pendingFollowRequest = false;
      isFollowed = false;
    }
    return null as T;
  }
}

void main() {
  Future<void> pumpNotification(
    WidgetTester tester,
    NotificationModel notification, {
    MisskeyApis? apis,
  }) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentLoginUserProvider.overrideWith(_TestCurrentLoginUser.new),
          instanceMetaProvider.overrideWith((ref) async => null),
          apiEmojisProvider.overrideWith(
            (ref) async => <String, EmojiSimple>{},
          ),
          if (apis != null) misskeyApisProvider.overrideWithValue(apis),
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
          home: Scaffold(
            body: NotificationItemCard(
              data: notification,
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }

  NotificationModel notification(String type) {
    return NotificationModel(
      id: type,
      createdAt: DateTime.utc(2026, 7, 27),
      type: type,
    );
  }

  const user = UserLiteModel(
    avatarBlurhash: null,
    avatarDecorations: [],
    avatarUrl: null,
    emojis: {},
    host: null,
    id: 'author',
    makeNotesFollowersOnlyBefore: null,
    makeNotesHiddenBefore: null,
    name: 'Author',
    onlineStatus: OnlineStatus.unknown,
    username: 'author',
  );

  NoteModel note({NoteReactionAcceptance? reactionAcceptance}) {
    return NoteModel(
      id: 'note',
      createdAt: DateTime.utc(2026, 7, 27),
      files: const [],
      localOnly: false,
      reactionAcceptance: reactionAcceptance,
      reactionEmojis: const {},
      reactions: const {},
      text: 'Note summary',
      user: user,
      userId: user.id,
      visibility: NoteVisibility.public,
    );
  }

  MisskeyApis testApis(_TestClient client) {
    final apis = MisskeyApis(
      instance: 'http://localhost',
      accessToken: '',
      onUnauthorized: null,
    );
    apis.following = FollowingService(client: client);
    return apis;
  }

  testWidgets('chat invitations are explicitly unsupported', (tester) async {
    await pumpNotification(tester, notification('chatRoomInvitationReceived'));
    await tester.pump();

    expect(find.text('暂不支持聊天室邀请'), findsOneWidget);
    expect(find.byIcon(TablerIcons.messages), findsWidgets);
    expect(find.text('接受'), findsNothing);
  });

  testWidgets('future notification types use the help icon and raw type', (
    tester,
  ) async {
    await pumpNotification(tester, notification('futureNotification'));
    await tester.pump();

    expect(find.byIcon(TablerIcons.help), findsOneWidget);
    expect(find.text('futureNotification'), findsOneWidget);
  });

  testWidgets('achievement titles are localized with raw-value fallback', (
    tester,
  ) async {
    await pumpNotification(
      tester,
      notification('achievementEarned').copyWith(achievement: 'notes10'),
    );
    await tester.pump();
    expect(find.text('一些帖子'), findsOneWidget);

    await pumpNotification(
      tester,
      notification(
        'achievementEarned',
      ).copyWith(achievement: 'futureAchievement'),
    );
    await tester.pump();
    expect(find.text('futureAchievement'), findsOneWidget);
  });

  final tablerIconCases = <String, IconData>{
    'follow': TablerIcons.plus,
    'mention': TablerIcons.at,
    'reply': TablerIcons.arrow_back_up,
    'renote': TablerIcons.repeat,
    'quote': TablerIcons.quote,
    'pollEnded': TablerIcons.chart_arrows,
    'scheduledNotePosted': TablerIcons.send,
    'scheduledNotePostFailed': TablerIcons.alert_triangle,
    'receiveFollowRequest': TablerIcons.clock,
    'followRequestAccepted': TablerIcons.check,
    'roleAssigned': TablerIcons.badges,
    'chatRoomInvitationReceived': TablerIcons.messages,
    'achievementEarned': TablerIcons.medal,
    'exportCompleted': TablerIcons.archive,
    'login': TablerIcons.login_2,
    'createToken': TablerIcons.key,
    'app': TablerIcons.apps,
    'test': TablerIcons.bell,
    'renote:grouped': TablerIcons.repeat,
  };

  for (final MapEntry(key: type, value: icon) in tablerIconCases.entries) {
    testWidgets('$type uses its specified Tabler icon', (tester) async {
      var value = notification(type);
      if (type == 'scheduledNotePosted' ||
          type == 'pollEnded' ||
          type == 'mention' ||
          type == 'reply' ||
          type == 'renote' ||
          type == 'quote' ||
          type == 'renote:grouped') {
        value = value.copyWith(note: note());
      }
      if (type == 'roleAssigned') {
        value = value.copyWith(role: const NotificationRole(name: 'Moderator'));
      }
      await pumpNotification(tester, value);
      await tester.pump();

      expect(find.byIcon(icon), findsWidgets);
    });
  }

  testWidgets('reaction notifications use the actual reaction widget', (
    tester,
  ) async {
    await pumpNotification(
      tester,
      notification(
        'reaction',
      ).copyWith(note: note(), reaction: '\$moekey-test-reaction'),
    );
    await tester.pump();

    expect(find.byType(ReactionsIcon), findsOneWidget);
  });

  testWidgets('grouped reaction icon follows reaction acceptance', (
    tester,
  ) async {
    await pumpNotification(
      tester,
      notification('reaction:grouped').copyWith(
        note: note(reactionAcceptance: NoteReactionAcceptance.likeOnly),
      ),
    );
    await tester.pump();
    expect(find.byIcon(TablerIcons.heart), findsOneWidget);

    await pumpNotification(
      tester,
      notification('reaction:grouped').copyWith(note: note()),
    );
    await tester.pump();
    expect(find.byIcon(TablerIcons.plus), findsOneWidget);
  });

  testWidgets('role and app images replace their fallback badge or avatar', (
    tester,
  ) async {
    await pumpNotification(
      tester,
      notification('roleAssigned').copyWith(
        role: const NotificationRole(
          name: 'Moderator',
          iconUrl: 'https://example.com/role.png',
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(MkImage), findsOneWidget);

    await pumpNotification(
      tester,
      notification(
        'app',
      ).copyWith(icon: 'https://example.com/app.png', body: 'App notification'),
    );
    await tester.pump();
    expect(find.byType(MkImage), findsOneWidget);
    expect(find.byIcon(TablerIcons.apps), findsNothing);
  });

  testWidgets('follow request actions expose loading and success state', (
    tester,
  ) async {
    final client = _TestClient()..pending = Completer<void>();
    await pumpNotification(
      tester,
      notification('receiveFollowRequest').copyWith(userId: 'requester'),
      apis: testApis(client),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('接受'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(client.paths, contains('/following/requests/accept'));

    client.pending!.complete();
    await tester.pumpAndSettle();
    expect(find.text('已接受关注请求'), findsOneWidget);
    expect(find.text('拒绝'), findsNothing);
  });

  testWidgets('follow request failures restore actions and show feedback', (
    tester,
  ) async {
    final client = _TestClient()..failure = StateError('request failed');
    await pumpNotification(
      tester,
      notification('receiveFollowRequest').copyWith(userId: 'requester'),
      apis: testApis(client),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('拒绝'));
    await tester.pumpAndSettle();
    expect(client.paths, contains('/following/requests/reject'));
    expect(find.text('操作失败，请稍后重试'), findsOneWidget);
    expect(find.text('接受'), findsOneWidget);
    expect(find.text('拒绝'), findsOneWidget);
  });

  testWidgets('follow request labels are centered in equal-width buttons', (
    tester,
  ) async {
    final client = _TestClient();
    await pumpNotification(
      tester,
      notification('receiveFollowRequest').copyWith(userId: 'requester'),
      apis: testApis(client),
    );
    await tester.pumpAndSettle();

    final acceptButton = find.ancestor(
      of: find.text('接受'),
      matching: find.byType(FilledButton),
    );
    final rejectButton = find.ancestor(
      of: find.text('拒绝'),
      matching: find.byType(FilledButton),
    );
    final acceptRect = tester.getRect(acceptButton);
    final rejectRect = tester.getRect(rejectButton);
    expect(acceptRect.width, closeTo(rejectRect.width, 0.01));
    expect(
      tester.getRect(find.text('接受')).center.dx,
      closeTo(acceptRect.center.dx, 0.01),
    );
    expect(
      tester.getRect(find.text('拒绝')).center.dx,
      closeTo(rejectRect.center.dx, 0.01),
    );
  });

  testWidgets('follow request state is restored from the server relationship', (
    tester,
  ) async {
    final acceptedClient = _TestClient()
      ..pendingFollowRequest = false
      ..isFollowed = true;
    await pumpNotification(
      tester,
      notification('receiveFollowRequest').copyWith(userId: 'requester'),
      apis: testApis(acceptedClient),
    );
    await tester.pumpAndSettle();
    expect(find.text('已接受关注请求'), findsOneWidget);
    expect(find.text('接受'), findsNothing);

    final handledClient = _TestClient()
      ..pendingFollowRequest = false
      ..isFollowed = false;
    await pumpNotification(
      tester,
      notification('receiveFollowRequest').copyWith(userId: 'requester'),
      apis: testApis(handledClient),
    );
    await tester.pumpAndSettle();
    expect(find.text('完成'), findsOneWidget);
    expect(find.text('拒绝'), findsNothing);
  });

  testWidgets('scheduled-note success opens the native note route', (
    tester,
  ) async {
    final scheduledNote = note()..id = 'scheduled-note';
    final scheduledNotification = notification(
      'scheduledNotePosted',
    ).copyWith(note: scheduledNote);
    late final GoRouter router;
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: NotificationItemCard(
              data: scheduledNotification,
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        GoRoute(
          path: '/notes/:id',
          builder: (context, state) =>
              Text('note-page-${state.pathParameters['id']}'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentLoginUserProvider.overrideWith(_TestCurrentLoginUser.new),
          instanceMetaProvider.overrideWith((ref) async => null),
          apiEmojisProvider.overrideWith(
            (ref) async => <String, EmojiSimple>{},
          ),
        ],
        child: MaterialApp.router(
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('定时帖子发布成功'));
    await tester.pumpAndSettle();
    expect(find.text('note-page-scheduled-note'), findsOneWidget);
  });
}
