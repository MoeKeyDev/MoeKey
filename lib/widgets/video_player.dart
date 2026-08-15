import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player/video_player.dart' as native_video;

enum VideoPlaybackBackend { native, mediaKit }

enum VideoPlayerPresentation { note, preview }

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

bool supportsVideoWindowFullscreen(TargetPlatform platform) {
  return platform == TargetPlatform.macOS ||
      platform == TargetPlatform.windows ||
      platform == TargetPlatform.linux;
}

final sharedVideoControllerProvider = Provider.autoDispose
    .family<SharedVideoController, String>((ref, url) {
      final controller = SharedVideoController(
        url,
        backend: videoPlaybackBackend(defaultTargetPlatform),
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

/// A platform-neutral video controller shared by the timeline and preview.
///
/// Keeping this controller in a provider family means opening the preview does
/// not create a second decoder or lose the current playback position.
class SharedVideoController extends ChangeNotifier {
  SharedVideoController(this.url, {required this.backend}) {
    unawaited(_initialize());
  }

  final String url;
  final VideoPlaybackBackend backend;

  native_video.VideoPlayerController? _nativeController;
  Player? _mediaKitPlayer;
  VideoController? _mediaKitVideoController;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  bool initialized = false;
  bool muted = true;
  bool fullscreen = false;
  Object? error;

  native_video.VideoPlayerController? get nativeController => _nativeController;
  VideoController? get mediaKitVideoController => _mediaKitVideoController;

  bool get isPlaying => switch (backend) {
    VideoPlaybackBackend.native => _nativeController?.value.isPlaying ?? false,
    VideoPlaybackBackend.mediaKit => _mediaKitPlayer?.state.playing ?? false,
  };

  Duration get duration => switch (backend) {
    VideoPlaybackBackend.native =>
      _nativeController?.value.duration ?? Duration.zero,
    VideoPlaybackBackend.mediaKit =>
      _mediaKitPlayer?.state.duration ?? Duration.zero,
  };

  Duration get position => switch (backend) {
    VideoPlaybackBackend.native =>
      _nativeController?.value.position ?? Duration.zero,
    VideoPlaybackBackend.mediaKit =>
      _mediaKitPlayer?.state.position ?? Duration.zero,
  };

  double get aspectRatio {
    final value = _nativeController?.value.aspectRatio ?? 0;
    return value > 0 ? value : 16 / 9;
  }

  Future<void> _initialize() async {
    try {
      if (backend == VideoPlaybackBackend.native) {
        final controller = native_video.VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: native_video.VideoPlayerOptions(
            mixWithOthers: true,
          ),
        );
        _nativeController = controller;
        controller.addListener(_notifySafely);
        await controller.initialize();
        await controller.setVolume(muted ? 0 : 1);
      } else {
        final player = Player();
        _mediaKitPlayer = player;
        _mediaKitVideoController = VideoController(player);
        _subscriptions.addAll([
          player.stream.playing.listen((_) => _notifySafely()),
          player.stream.position.listen((_) => _notifySafely()),
          player.stream.duration.listen((_) => _notifySafely()),
          player.stream.error.listen((value) {
            error = value;
            _notifySafely();
          }),
        ]);
        await player.setVolume(muted ? 0 : 100);
        await player.open(Media(url), play: false);
      }
      initialized = true;
    } catch (exception, stackTrace) {
      error = exception;
      debugPrint('Failed to initialize video: $exception');
      debugPrintStack(stackTrace: stackTrace);
    }
    _notifySafely();
  }

  Future<void> togglePlayback() async {
    if (!initialized) return;
    if (backend == VideoPlaybackBackend.native) {
      if (isPlaying) {
        await _nativeController?.pause();
      } else {
        await _nativeController?.play();
      }
    } else {
      await _mediaKitPlayer?.playOrPause();
    }
    _notifySafely();
  }

  Future<void> seek(Duration value) async {
    if (backend == VideoPlaybackBackend.native) {
      await _nativeController?.seekTo(value);
    } else {
      await _mediaKitPlayer?.seek(value);
    }
  }

  Future<void> setMuted(bool value) async {
    muted = value;
    if (backend == VideoPlaybackBackend.native) {
      await _nativeController?.setVolume(value ? 0 : 1);
    } else {
      await _mediaKitPlayer?.setVolume(value ? 0 : 100);
    }
    _notifySafely();
  }

  /// Restores the shared player without notifying widgets while Flutter may
  /// be unmounting the preview route. A final notification is delivered after
  /// the current frame for any timeline player that still uses this instance.
  Future<void> restoreAfterPreview() async {
    _notificationHoldCount++;
    try {
      await setMuted(true);
      await exitFullscreen();
    } finally {
      _notificationHoldCount--;
      if (_notificationHoldCount == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySafely());
      }
    }
  }

  Future<void> toggleFullscreen() async {
    if (!supportsVideoWindowFullscreen(defaultTargetPlatform)) return;
    if (fullscreen) {
      await exitFullscreen();
    } else {
      await enterNativeFullscreen();
      fullscreen = true;
      _notifySafely();
    }
  }

  Future<void> exitFullscreen() async {
    if (!fullscreen) return;
    await exitNativeFullscreen();
    fullscreen = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (_disposed || _notificationHoldCount > 0) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_notificationScheduled) return;
      _notificationScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationScheduled = false;
        if (!_disposed && _notificationHoldCount == 0) notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  bool _disposed = false;
  bool _notificationScheduled = false;
  int _notificationHoldCount = 0;

  @override
  void dispose() {
    _disposed = true;
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    final nativeController = _nativeController;
    if (nativeController != null) {
      nativeController.removeListener(_notifySafely);
      unawaited(nativeController.dispose());
    }
    final player = _mediaKitPlayer;
    if (player != null) unawaited(player.dispose());
    super.dispose();
  }
}

class VideoPlayerComponent extends ConsumerWidget {
  const VideoPlayerComponent({
    super.key,
    required this.url,
    this.presentation = VideoPlayerPresentation.note,
    this.controlsVisible = true,
    this.onSurfaceTap,
    this.onZoomChanged,
  });

  final String url;
  final VideoPlayerPresentation presentation;
  final bool controlsVisible;
  final VoidCallback? onSurfaceTap;
  final ValueChanged<bool>? onZoomChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(sharedVideoControllerProvider(url));
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _VideoSurface(
        controller: controller,
        presentation: presentation,
        controlsVisible: controlsVisible,
        onSurfaceTap: onSurfaceTap,
        onZoomChanged: onZoomChanged,
      ),
    );
  }
}

class _VideoSurface extends StatelessWidget {
  const _VideoSurface({
    required this.controller,
    required this.presentation,
    required this.controlsVisible,
    this.onSurfaceTap,
    this.onZoomChanged,
  });

  final SharedVideoController controller;
  final VideoPlayerPresentation presentation;
  final bool controlsVisible;
  final VoidCallback? onSurfaceTap;
  final ValueChanged<bool>? onZoomChanged;

  @override
  Widget build(BuildContext context) {
    if (controller.error != null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: Icon(Icons.error_outline, color: Colors.white70)),
      );
    }
    if (!controller.initialized) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final child = switch (controller.backend) {
      VideoPlaybackBackend.native => native_video.VideoPlayer(
        controller.nativeController!,
      ),
      VideoPlaybackBackend.mediaKit => Video(
        controller: controller.mediaKitVideoController!,
        controls: NoVideoControls,
      ),
    };

    return ColoredBox(
      color: presentation == VideoPlayerPresentation.preview
          ? Colors.transparent
          : Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (presentation == VideoPlayerPresentation.preview)
            _ZoomableVideoView(
              aspectRatio: controller.aspectRatio,
              onTap: onSurfaceTap,
              onZoomChanged: onZoomChanged,
              child: child,
            )
          else
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSurfaceTap,
              child: Center(
                child: AspectRatio(
                  aspectRatio: controller.aspectRatio,
                  child: child,
                ),
              ),
            ),
          if (presentation == VideoPlayerPresentation.note)
            _NoteVideoControls(controller: controller)
          else if (controlsVisible)
            _PreviewVideoControls(controller: controller),
        ],
      ),
    );
  }
}

class _ZoomableVideoView extends StatefulWidget {
  const _ZoomableVideoView({
    required this.aspectRatio,
    required this.child,
    this.onTap,
    this.onZoomChanged,
  });

  final double aspectRatio;
  final Widget child;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onZoomChanged;

  @override
  State<_ZoomableVideoView> createState() => _ZoomableVideoViewState();
}

class _ZoomableVideoViewState extends State<_ZoomableVideoView> {
  final TransformationController _transformationController =
      TransformationController();
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_transformationChanged);
  }

  void _transformationChanged() {
    final zoomed = _transformationController.value.getMaxScaleOnAxis() > 1.001;
    if (zoomed != _zoomed && mounted) {
      setState(() => _zoomed = zoomed);
      widget.onZoomChanged?.call(zoomed);
    }
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    if (_zoomed) {
      _transformationController.value = Matrix4.identity();
      return;
    }
    const scale = 2.0;
    final position = details.localPosition;
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(
        -position.dx * (scale - 1),
        -position.dy * (scale - 1),
        0,
        1,
      )
      ..scaleByDouble(scale, scale, 1, 1);
  }

  @override
  void dispose() {
    if (_zoomed) widget.onZoomChanged?.call(false);
    _transformationController.removeListener(_transformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onDoubleTapDown: _handleDoubleTapDown,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1,
        maxScale: 5,
        panEnabled: _zoomed,
        scaleEnabled: true,
        clipBehavior: Clip.hardEdge,
        child: SizedBox.expand(
          child: Center(
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteVideoControls extends StatelessWidget {
  const _NoteVideoControls({required this.controller});

  final SharedVideoController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      right: 8,
      bottom: 8,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: Text(
                _formatVideoDuration(controller.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const Spacer(),
          IconButton.filled(
            visualDensity: VisualDensity.compact,
            tooltip: controller.muted ? '取消静音' : '静音',
            onPressed: () => controller.setMuted(!controller.muted),
            icon: Icon(
              controller.muted ? Icons.volume_off : Icons.volume_up,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewVideoControls extends StatelessWidget {
  const _PreviewVideoControls({required this.controller});

  final SharedVideoController controller;

  @override
  Widget build(BuildContext context) {
    final durationMs = controller.duration.inMilliseconds;
    final positionMs = controller.position.inMilliseconds.clamp(0, durationMs);
    return Stack(
      children: [
        Center(
          child: IconButton.filledTonal(
            onPressed: controller.togglePlayback,
            iconSize: 34,
            icon: Icon(controller.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 0,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(
                  '${_formatVideoDuration(controller.position)} / '
                  '${_formatVideoDuration(controller.duration)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    value: positionMs.toDouble(),
                    max: durationMs > 0 ? durationMs.toDouble() : 1,
                    onChanged: durationMs > 0
                        ? (value) => controller.seek(
                            Duration(milliseconds: value.round()),
                          )
                        : null,
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () => controller.setMuted(!controller.muted),
                  icon: Icon(
                    controller.muted ? Icons.volume_off : Icons.volume_up,
                  ),
                ),
                if (supportsVideoWindowFullscreen(defaultTargetPlatform))
                  IconButton(
                    color: Colors.white,
                    tooltip: controller.fullscreen ? '退出全屏' : '全屏播放',
                    onPressed: controller.toggleFullscreen,
                    icon: Icon(
                      controller.fullscreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _formatVideoDuration(Duration value) {
  final hours = value.inHours;
  final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
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
  } catch (exception, stackTrace) {
    debugPrint('Failed to enter native fullscreen: $exception');
    debugPrintStack(stackTrace: stackTrace);
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
  } catch (exception, stackTrace) {
    debugPrint('Failed to exit native fullscreen: $exception');
    debugPrintStack(stackTrace: stackTrace);
  }
}
