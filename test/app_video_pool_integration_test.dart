import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/pages/notes/note_page.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/image_preview/image_preview.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/video/app_video_pool.dart';
import 'package:moekey/widgets/notes/note_card.dart';
import 'package:moekey/widgets/notes/note_image.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';
import 'package:video_player/video_player.dart' as native;

import '../packages/moekey_video_pool/test/support/fake_playback.dart';

class _NoLoginUser extends CurrentLoginUser {
  @override
  LoginUser? build() => null;
}

class _LoginUser extends CurrentLoginUser {
  @override
  LoginUser build() => LoginUser(
    serverUrl: 'https://test',
    token: 'test',
    name: 'me',
    id: 'me',
    userInfo: UserFullModel(
      id: 'me',
      username: 'me',
      createdAt: DateTime(2026),
      followersCount: 0,
      followingCount: 0,
      notesCount: 0,
      onlineStatus: OnlineStatus.unknown,
    ),
  );
}

class _NoSocket extends MoekeyWebSocket {
  @override
  Future<WebSocketChannel?> build() async => null;
}

class _FixtureNotes extends NotesService {
  _FixtureNotes(this.data)
    : super(
        client: MisskeyApisHttpClient(
          host: 'http://localhost',
          accessToken: '',
          onUnauthorized: null,
        ),
      );
  final NoteModel data;
  @override
  Future<NoteModel?> show({required String noteId}) async => data;
  @override
  Future<List<NoteModel>> children({
    required String noteId,
    int limit = 30,
    String? untilId,
  }) async => [];
}

class _RenderableFake extends FakePlayback {
  final controller = native.VideoPlayerController.networkUrl(
    Uri.parse('https://test/video.mp4'),
  );
  @override
  native.VideoPlayerController get nativeController => controller;
  @override
  Future<void> release() async {
    await controller.dispose();
    await super.release();
  }
}

DriveFileModel file({bool sensitive = false, String id = 'video'}) =>
    DriveFileModel(
      id,
      'video.mp4',
      '2026-01-01',
      null,
      'video/mp4',
      'https://test/video.mp4',
      100,
      sensitive,
      null,
      const Properties(width: 640, height: 360),
      null,
    );
NoteModel note(List<DriveFileModel> files) => NoteModel.fromJson({
  'id': 'note',
  'createdAt': '2026-01-01T00:00:00Z',
  'files': files
      .map(
        (file) => {...file.toJson(), 'properties': file.properties?.toJson()},
      )
      .toList(),
  'localOnly': false,
  'reactionEmojis': <String, dynamic>{},
  'reactions': <String, dynamic>{},
  'userId': 'user',
  'visibility': 'public',
  'user': {
    'id': 'user',
    'username': 'user',
    'avatarDecorations': [],
    'emojis': <String, dynamic>{},
    'onlineStatus': 'unknown',
  },
});

void main() {
  setUp(() async {
    await S.load(const Locale("en"));
  });
  testWidgets(
    'actual timeline media and preview share attachment, session and speed',
    (tester) async {
      final pool = VideoPool(
        dwell: Duration.zero,
        factory: (_) => _RenderableFake(),
      );
      final data = note([file()]);
      late NoteVideoContext origin;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(
              body: AppVideoViewport(
                child: AppVideoPosition(
                  index: 7,
                  child: SizedBox(
                    width: 640,
                    child: TimeLineImage(
                      files: data.files,
                      note: data,
                      mainAxisExtent: 400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/image-preview',
            builder: (_, state) {
              final extra = state.extra! as Map<String, dynamic>;
              origin = extra['videoContext'] as NoteVideoContext;
              return ImagePreviewPage(
                note: data,
                galleryItems: extra['galleryItems'],
                heroKeys: extra['heroKeys'],
                initialIndex: extra['initialIndex'],
                videoContext: origin,
                videoSubIndexes: extra['videoSubIndexes'],
                initialVideoPlaying: extra['initialVideoPlaying'],
              );
            },
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appVideoPoolProvider.overrideWithValue(pool),
            currentLoginUserProvider.overrideWith(_NoLoginUser.new),
            instanceMetaProvider.overrideWith((ref) async => null),
            apiEmojisListProvider.overrideWith((ref) async => []),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final video = pool.tiles.single;
      expect(video.listIndex, 7);
      final session = video.session;
      expect(video.isPlaying, true);
      final seek = video.seekTo(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await seek;
      final speed = video.setPlaybackSpeed(1.5);
      await tester.pumpAndSettle();
      await speed;
      await tester.tap(find.byType(NoteImage), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(pool.tiles.single, same(video));
      expect(video.referenceCount, 2);
      expect(origin.listKey, video.scope);
      expect(origin.listIndex, 7);
      expect(video.videoKey, origin.attachmentKey('video'));
      expect(video.session, same(session));
      expect(video.progress.value, const Duration(seconds: 4));
      expect(video.playbackSpeed, 1.5);
      router.pop();
      await tester.pumpAndSettle();
      expect(video.referenceCount, 1);
      expect(video.session, same(session));
      expect(video.playbackSpeed, 1.5);
      await tester.pumpWidget(const SizedBox.shrink());
      await pool.shutdown();
      router.dispose();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'actual note navigation carries list identity and keeps the same video state',
    (tester) async {
      final pool = VideoPool(
        dwell: Duration.zero,
        factory: (_) => _RenderableFake(),
      );
      final data = note([file()])..text = 'A video note';
      final apis = MisskeyApis(
        instance: 'http://localhost',
        accessToken: '',
        onUnauthorized: null,
      )..notes = _FixtureNotes(data);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(
              body: AppVideoViewport(
                child: SingleChildScrollView(
                  child: NoteCard(
                    data: data,
                    borderRadius: BorderRadius.zero,
                    videoListIndex: 3,
                  ),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/notes/:id',
            builder: (_, state) {
              final extra = state.extra! as Map<String, dynamic>;
              return NotesPage(
                noteId: state.pathParameters['id']!,
                previewNote: extra['note'],
                videoContext: extra['videoContext'],
              );
            },
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appVideoPoolProvider.overrideWithValue(pool),
            currentLoginUserProvider.overrideWith(_LoginUser.new),
            misskeyApisProvider.overrideWithValue(apis),
            moekeyWebSocketProvider.overrideWith(_NoSocket.new),
            instanceMetaProvider.overrideWith((ref) async => null),
            apiEmojisListProvider.overrideWith((ref) async => []),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final video = pool.tiles.single;
      final session = video.session;
      await tester.tap(
        find
            .byWidgetPredicate(
              (widget) => widget is MFMText && widget.text == 'A video note',
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(find.byType(NotesPage), findsOneWidget);
      expect(pool.tiles.single, same(video));
      expect(video.referenceCount, 2);
      expect(video.listIndex, 3);
      expect(video.session, same(session));
      router.pop();
      await tester.pumpAndSettle();
      expect(video.referenceCount, 1);
      expect(video.session, same(session));
      await tester.pumpWidget(const SizedBox.shrink());
      await pool.shutdown();
      router.dispose();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('sensitive media toggles eligibility without replacing its state', (
    tester,
  ) async {
    final pool = VideoPool(factory: (_) => _RenderableFake())
      ..setForeground(false);
    final data = note([file(sensitive: true)]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appVideoPoolProvider.overrideWithValue(pool),
          currentLoginUserProvider.overrideWith(_NoLoginUser.new),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AppVideoViewport(
              child: SizedBox(
                width: 500,
                child: TimeLineImage(
                  files: data.files,
                  note: data,
                  mainAxisExtent: 400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final video = pool.tiles.single;
    expect(video.enable, false);
    expect(pool.liveCount, 0);
    await tester.tap(find.byType(NoteImage));
    await tester.pumpAndSettle();
    expect(pool.tiles.single, same(video));
    expect(video.enable, true);
    expect(video.visibility, greaterThan(0));
    // Hide button is the top-right gesture target; no native player was created.
    await tester.tapAt(
      tester.getTopRight(find.byType(NoteImage)) + const Offset(-20, 20),
    );
    await tester.pumpAndSettle();
    expect(pool.tiles.single, same(video));
    expect(video.enable, false);
    await tester.pumpWidget(const SizedBox.shrink());
    await pool.shutdown();
  });

  testWidgets('retained tabs only expose their selected viewport', (
    tester,
  ) async {
    final pool = VideoPool(factory: (_) => FakePlayback())
      ..setForeground(false);
    final selected = ValueNotifier(0);
    Widget tile() => Builder(
      builder: (context) {
        final identity = NoteVideoContext.of(context, 'note');
        return VideoFeedView(
          scope: identity.listKey,
          videoKey: identity.attachmentKey('video'),
          noteId: 'note',
          listIndex: 0,
          listSubIndex: 0,
          url: 'https://test/video.mp4',
          builder: (_, _) =>
              const SizedBox(width: double.infinity, height: 200),
        );
      },
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appVideoPoolProvider.overrideWithValue(pool),
          currentLoginUserProvider.overrideWith(_NoLoginUser.new),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<int>(
              valueListenable: selected,
              builder: (_, index, _) => Stack(
                children: [
                  for (var i = 0; i < 2; i++)
                    AppVideoActivity(
                      active: index == i,
                      child: AppVideoViewport(child: tile()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final a = pool.tiles.first;
    final b = pool.tiles.last;
    expect(a.visibility, 1);
    expect(b.visibility, 0);
    expect(a.scope, isNot(b.scope));
    selected.value = 1;
    await tester.pumpAndSettle();
    expect(a.visibility, 0);
    expect(b.visibility, 1);
    expect(pool.activeScope, b.scope);
    await tester.pumpWidget(const SizedBox.shrink());
    await pool.shutdown();
    selected.dispose();
  });
}
