import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:video_player/video_player.dart' as native_video;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';

enum VideoPlayerPresentation { note, preview }

bool supportsVideoWindowFullscreen(TargetPlatform platform) {
  return platform == TargetPlatform.macOS ||
      platform == TargetPlatform.windows ||
      platform == TargetPlatform.linux;
}

/// UI facade over a pool attachment. It never owns a native player.
class SharedVideoController extends ChangeNotifier {
  SharedVideoController(this.video, {this.listenToProgress = false}) {
    video.addListener(_notifySafely);
    if (listenToProgress) video.progress.addListener(_notifySafely);
  }
  final FeedVideo video;
  final bool listenToProgress;
  native_video.VideoPlayerController? get nativeController => video.controller;
  bool get initialized => video.ready;
  bool get muted => video.muted;
  bool fullscreen = false;
  Object? get error => video.error;
  bool get isPlaying => video.isPlaying;
  Duration get duration => video.session?.player.duration ?? Duration.zero;
  Duration get position => video.progress.value;
  double get aspectRatio {
    final value = nativeController?.value.aspectRatio ?? 0;
    return value > 0 ? value : 16 / 9;
  }

  Future<void> togglePlayback() => isPlaying ? video.pause() : video.play();
  Future<void> seek(Duration value) => video.seekTo(value);
  Future<void> setMuted(bool value) => video.setMuted(value);

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
    if (_disposed) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_notificationScheduled) return;
      _notificationScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationScheduled = false;
        if (!_disposed) notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  bool _disposed = false;
  bool _notificationScheduled = false;

  @override
  void dispose() {
    _disposed = true;
    video.removeListener(_notifySafely);
    if (listenToProgress) video.progress.removeListener(_notifySafely);
    super.dispose();
  }
}

class VideoPlayerComponent extends HookConsumerWidget {
  const VideoPlayerComponent({
    super.key,
    required this.video,
    this.cover,
    this.placeholder,
    this.presentation = VideoPlayerPresentation.note,
    this.controlsVisible = true,
    this.onSurfaceTap,
    this.onZoomChanged,
  });

  final FeedVideo video;
  final Widget? cover;
  final Widget? placeholder;
  final VideoPlayerPresentation presentation;
  final bool controlsVisible;
  final VoidCallback? onSurfaceTap;
  final ValueChanged<bool>? onZoomChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = presentation == VideoPlayerPresentation.preview;
    final controller = useMemoized(
      () => SharedVideoController(video, listenToProgress: preview),
      [video, preview],
    );
    useEffect(() => controller.dispose, [controller]);
    final visible = VideoFeedView.isVisibleOf(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _VideoSurface(
        controller: controller,
        renderVideo: visible,
        cover:
            cover ??
            (video.thumbnail == null
                ? placeholder
                : Image(
                    image: video.thumbnail!,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    frameBuilder: (_, child, frame, synchronous) =>
                        synchronous || frame != null
                        ? child
                        : placeholder ?? const SizedBox.expand(),
                  )),
        presentation: presentation,
        controlsVisible: controlsVisible,
        onSurfaceTap: onSurfaceTap,
        onZoomChanged: onZoomChanged,
      ),
    );
  }
}

/// Acquires the same attachment state when a preview page becomes selected.
class PreviewVideoPlayerComponent extends HookWidget {
  const PreviewVideoPlayerComponent({
    super.key,
    required this.video,
    required this.active,
    this.startPlaying = true,
    required this.controlsVisible,
    this.onSurfaceTap,
    this.onZoomChanged,
  });
  final FeedVideo video;
  final bool active;
  final bool startPlaying;
  final bool controlsVisible;
  final VoidCallback? onSurfaceTap;
  final ValueChanged<bool>? onZoomChanged;
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      if (!active) return null;
      var cancelled = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (cancelled || !video.registered) return;
        // Selecting a preview is an explicit user action, including manual paging.
        await video.setMuted(false);
        if (!cancelled && video.registered && startPlaying) await video.play();
      });
      return () {
        cancelled = true;
        if (identical(video.pool.current, video) && video.registered) {
          unawaited(video.setMuted(true));
        }
        unawaited(exitNativeFullscreen());
      };
    }, [video, active]);
    return VideoPlayerComponent(
      video: video,
      presentation: VideoPlayerPresentation.preview,
      controlsVisible: controlsVisible,
      onSurfaceTap: onSurfaceTap,
      onZoomChanged: onZoomChanged,
    );
  }
}

class _VideoSurface extends StatelessWidget {
  const _VideoSurface({
    required this.controller,
    required this.renderVideo,
    this.cover,
    required this.presentation,
    required this.controlsVisible,
    this.onSurfaceTap,
    this.onZoomChanged,
  });

  final SharedVideoController controller;
  final bool renderVideo;
  final Widget? cover;
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
    if (!controller.initialized || !renderVideo) {
      return Stack(
        fit: StackFit.expand,
        children: [
          cover ?? const ColoredBox(color: Colors.black),
          if (renderVideo && controller.video.preparing)
            const Center(child: CircularProgressIndicator.adaptive()),
          if (presentation == VideoPlayerPresentation.note)
            _NoteVideoControls(controller: controller),
          if (presentation == VideoPlayerPresentation.preview &&
              controlsVisible)
            _PreviewVideoControls(controller: controller),
        ],
      );
    }

    final child = native_video.VideoPlayer(controller.nativeController!);

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
      await windowManager.setFullScreen(true);
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
      await windowManager.setFullScreen(false);
    }
  } catch (exception, stackTrace) {
    debugPrint('Failed to exit native fullscreen: $exception');
    debugPrintStack(stackTrace: stackTrace);
  }
}
