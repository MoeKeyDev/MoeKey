import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/video/fvp_video_playback.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/video_player.dart';
import 'package:moekey/video/app_video_pool.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';

void main() {
  testWidgets(
    'placeholder remains until cached cover is decoded without playback',
    (tester) async {
      final result = Completer<ImageProvider<Object>?>();
      final pool = VideoPool(thumbnailLoader: (_) => result.future);
      final video = pool.register(
        scope: 'default',
        noteId: 'note',
        listIndex: 0,
        listSubIndex: 0,
        url: 'https://test/video',
      );
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SizedBox(
              width: 320,
              height: 180,
              child: VideoPlayerComponent(
                video: video,
                controlsVisible: false,
                placeholder: const Text('blurhash placeholder'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('blurhash placeholder'), findsOneWidget);
      final rgba = Uint8List(8 * 8 * 4);
      result.complete(MemoryImage(encodeVideoThumbnail((rgba, 8, 8))));
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pump();
      expect(find.text('blurhash placeholder'), findsNothing);
      expect(find.byType(Image), findsOneWidget);
      expect(pool.liveCount, 0);
      await tester.pumpWidget(const SizedBox());
      await pool.shutdown();
    },
  );

  test(
    'all platforms use the video_player adapter backed by FVP at startup',
    () {
      for (final platform in TargetPlatform.values) {
        debugDefaultTargetPlatformOverride = platform;
        final playback = createAppVideoPlayback('https://test/video.mp4');
        expect(playback, isA<VideoPlayerPlayback>());
        expect(playback.nativeController, isNotNull);
      }
      debugDefaultTargetPlatformOverride = null;
    },
  );

  test('window fullscreen control is only available on desktop', () {
    expect(supportsVideoWindowFullscreen(TargetPlatform.macOS), isTrue);
    expect(supportsVideoWindowFullscreen(TargetPlatform.windows), isTrue);
    expect(supportsVideoWindowFullscreen(TargetPlatform.linux), isTrue);
    expect(supportsVideoWindowFullscreen(TargetPlatform.android), isFalse);
    expect(supportsVideoWindowFullscreen(TargetPlatform.iOS), isFalse);
  });
}
