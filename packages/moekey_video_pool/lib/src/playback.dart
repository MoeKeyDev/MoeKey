import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:video_player/video_player.dart';

typedef PlaybackFactory = VideoPlayback Function(String url);

/// Backend contract. Inject a factory to use another engine or a test backend.
abstract class VideoPlayback extends ChangeNotifier {
  VideoPlayerController? get nativeController => null;
  bool get initialized;
  bool get playing;
  bool get completed;
  Object? get error => null;
  double get speed;
  bool get muted => true;
  Duration get position;
  Duration get duration;
  Future<void> initialize();
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration value);
  Future<void> setSpeed(double value);
  Future<void> setMuted(bool value);

  /// Optional, bounded-size still image. Must not seek or start playback.
  /// Backends without snapshot support may return null.
  Future<ImageProvider<Object>?> captureThumbnail() async => null;
  Future<void> release();
}

class VideoPlayerPlayback extends VideoPlayback {
  VideoPlayerPlayback(String url, {VideoPlayerOptions? videoPlayerOptions})
    : controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: videoPlayerOptions,
      ) {
    controller.addListener(_changed);
  }
  final VideoPlayerController controller;
  @override
  VideoPlayerController get nativeController => controller;
  @override
  bool get initialized => controller.value.isInitialized;
  @override
  bool get playing => controller.value.isPlaying;
  @override
  bool get completed => controller.value.isCompleted;
  @override
  Object? get error => controller.value.errorDescription;
  @override
  double get speed => controller.value.playbackSpeed;
  @override
  bool get muted => controller.value.volume == 0;
  @override
  Duration get position => controller.value.position;
  @override
  Duration get duration => controller.value.duration;
  void _changed() => notifyListeners();
  @override
  Future<void> initialize() async {
    await controller.initialize();
    await controller.setLooping(false);
    await controller.setVolume(0);
  }

  @override
  Future<void> play() => controller.play();
  @override
  Future<void> pause() => controller.pause();
  @override
  Future<void> seek(Duration value) => controller.seekTo(value);
  @override
  Future<void> setSpeed(double value) => controller.setPlaybackSpeed(value);
  @override
  Future<void> setMuted(bool value) => controller.setVolume(value ? 0 : 1);
  @override
  Future<void> release() async {
    controller.removeListener(_changed);
    await controller.dispose();
    super.dispose();
  }
}
