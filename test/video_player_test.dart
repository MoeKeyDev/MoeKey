import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/video_player.dart';

void main() {
  test('Apple and mobile platforms use their native video backend', () {
    expect(
      videoPlaybackBackend(TargetPlatform.macOS),
      VideoPlaybackBackend.native,
    );
    expect(
      videoPlaybackBackend(TargetPlatform.iOS),
      VideoPlaybackBackend.native,
    );
    expect(
      videoPlaybackBackend(TargetPlatform.android),
      VideoPlaybackBackend.native,
    );
  });

  test('desktop platforms without an endorsed backend use media_kit', () {
    expect(
      videoPlaybackBackend(TargetPlatform.windows),
      VideoPlaybackBackend.mediaKit,
    );
    expect(
      videoPlaybackBackend(TargetPlatform.linux),
      VideoPlaybackBackend.mediaKit,
    );
  });

  test('window fullscreen control is only available on desktop', () {
    expect(supportsVideoWindowFullscreen(TargetPlatform.macOS), isTrue);
    expect(supportsVideoWindowFullscreen(TargetPlatform.windows), isTrue);
    expect(supportsVideoWindowFullscreen(TargetPlatform.linux), isTrue);
    expect(supportsVideoWindowFullscreen(TargetPlatform.android), isFalse);
    expect(supportsVideoWindowFullscreen(TargetPlatform.iOS), isFalse);
  });
}
