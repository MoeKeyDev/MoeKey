import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart' as native_video;

part 'video_player.g.dart';

enum VideoPlaybackBackend { native, mediaKit }

@visibleForTesting
VideoPlaybackBackend videoPlaybackBackend(TargetPlatform platform) {
  return switch (platform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS => VideoPlaybackBackend.native,
    TargetPlatform.linux ||
    TargetPlatform.windows ||
    TargetPlatform.fuchsia => VideoPlaybackBackend.mediaKit,
  };
}

/// media_kit is retained only for platforms where Flutter's official
/// video_player has no endorsed implementation (currently Windows & Linux).
@riverpod
VideoController fallbackVideoPlayerState(
  Ref ref, {
  required String url,
  bool play = false,
}) {
  final player = Player();
  final controller = VideoController(player);
  unawaited(_openFallbackVideo(player, url, play: play));
  ref.onDispose(() {
    unawaited(player.dispose());
  });
  return controller;
}

Future<void> _openFallbackVideo(
  Player player,
  String url, {
  required bool play,
}) async {
  try {
    await player.open(Media(url), play: play);
  } catch (exception, stacktrace) {
    debugPrint('Failed to open fallback video: $exception');
    debugPrintStack(stackTrace: stacktrace);
  }
}

Future<void> enterNativeFullscreen() async {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      await const MethodChannel(
        'com.alexmercerind/media_kit_video',
      ).invokeMethod('Utils.EnterNativeFullscreen');
    }
  } catch (exception, stacktrace) {
    debugPrint(exception.toString());
    debugPrint(stacktrace.toString());
  }
}

Future<void> exitNativeFullscreen() async {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      await const MethodChannel(
        'com.alexmercerind/media_kit_video',
      ).invokeMethod('Utils.ExitNativeFullscreen');
    }
  } catch (exception, stacktrace) {
    debugPrint(exception.toString());
    debugPrint(stacktrace.toString());
  }
}

class VideoPlayerComponent extends HookConsumerWidget {
  const VideoPlayerComponent({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (videoPlaybackBackend(defaultTargetPlatform) ==
        VideoPlaybackBackend.native) {
      return _NativeVideoPlayer(url: url);
    }
    final controller = ref.watch(fallbackVideoPlayerStateProvider(url: url));
    return Video(
      controller: controller,
      onEnterFullscreen: enterNativeFullscreen,
      onExitFullscreen: exitNativeFullscreen,
    );
  }
}

class _NativeVideoPlayer extends StatefulWidget {
  const _NativeVideoPlayer({required this.url});

  final String url;

  @override
  State<_NativeVideoPlayer> createState() => _NativeVideoPlayerState();
}

class _NativeVideoPlayerState extends State<_NativeVideoPlayer> {
  late native_video.VideoPlayerController controller;
  Object? initializationError;

  @override
  void initState() {
    super.initState();
    _createController();
  }

  @override
  void didUpdateWidget(_NativeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url == widget.url) return;
    unawaited(controller.dispose());
    initializationError = null;
    _createController();
  }

  void _createController() {
    controller = native_video.VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      videoPlayerOptions: native_video.VideoPlayerOptions(mixWithOthers: true),
    );
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await controller.initialize();
      if (mounted) setState(() {});
    } catch (error, stackTrace) {
      debugPrint('Failed to initialize native video: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) setState(() => initializationError = error);
    }
  }

  @override
  void dispose() {
    unawaited(controller.dispose());
    super.dispose();
  }

  Future<void> _openFullscreen() async {
    await enterNativeFullscreen();
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: _NativeVideoSurface(
              controller: controller,
              fullscreen: true,
              onFullscreen: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
    );
    await exitNativeFullscreen();
  }

  @override
  Widget build(BuildContext context) {
    if (initializationError != null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: Icon(Icons.error_outline, color: Colors.white70)),
      );
    }
    if (!controller.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    return _NativeVideoSurface(
      controller: controller,
      onFullscreen: _openFullscreen,
    );
  }
}

class _NativeVideoSurface extends StatefulWidget {
  const _NativeVideoSurface({
    required this.controller,
    required this.onFullscreen,
    this.fullscreen = false,
  });

  final native_video.VideoPlayerController controller;
  final VoidCallback onFullscreen;
  final bool fullscreen;

  @override
  State<_NativeVideoSurface> createState() => _NativeVideoSurfaceState();
}

class _NativeVideoSurfaceState extends State<_NativeVideoSurface> {
  bool showControls = true;
  Timer? hideControlsTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_playerChanged);
  }

  @override
  void didUpdateWidget(_NativeVideoSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    oldWidget.controller.removeListener(_playerChanged);
    widget.controller.addListener(_playerChanged);
  }

  @override
  void dispose() {
    hideControlsTimer?.cancel();
    widget.controller.removeListener(_playerChanged);
    super.dispose();
  }

  void _playerChanged() {
    if (mounted) setState(() {});
  }

  void _toggleControls() {
    setState(() => showControls = !showControls);
    _scheduleControlsHide();
  }

  Future<void> _togglePlayback() async {
    if (widget.controller.value.isPlaying) {
      await widget.controller.pause();
      hideControlsTimer?.cancel();
      if (mounted) setState(() => showControls = true);
    } else {
      await widget.controller.play();
      if (mounted) {
        setState(() => showControls = true);
        _scheduleControlsHide();
      }
    }
  }

  void _scheduleControlsHide() {
    hideControlsTimer?.cancel();
    if (!widget.controller.value.isPlaying) return;
    hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => showControls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.value;
    final controlsVisible = showControls || !value.isPlaying;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleControls,
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: value.aspectRatio > 0 ? value.aspectRatio : 16 / 9,
                child: native_video.VideoPlayer(widget.controller),
              ),
            ),
            if (controlsVisible) ...[
              Center(
                child: IconButton.filledTonal(
                  onPressed: _togglePlayback,
                  iconSize: 32,
                  icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
                ),
              ),
              Positioned(
                left: 8,
                right: 4,
                bottom: 4,
                child: Row(
                  children: [
                    Expanded(
                      child: native_video.VideoProgressIndicator(
                        widget.controller,
                        allowScrubbing: true,
                        colors: const native_video.VideoProgressColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.white38,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.onFullscreen,
                      icon: Icon(
                        widget.fullscreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
