import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pool.dart';

/// Bounds visibility sampling to the list viewport and coalesces it per frame.
/// The caller owns [pool]; removing this widget does not dispose the pool.
class VideoPoolViewport extends StatefulWidget {
  const VideoPoolViewport({
    super.key,
    required this.pool,
    required this.child,
    this.observeScroll = true,
    this.observeAppLifecycle = true,
    this.active = true,
  });

  final VideoPool pool;
  final Widget child;

  /// Additional eligibility, for example whether this viewport's tab is selected.
  /// A covered route is inactive even when this is true.
  final bool active;
  final bool observeScroll;
  final bool observeAppLifecycle;

  @override
  State<VideoPoolViewport> createState() => _VideoPoolViewportState();
}

class _VideoPoolViewportState extends State<VideoPoolViewport>
    with WidgetsBindingObserver {
  final viewportKey = GlobalKey();
  final Set<VoidCallback> samplers = {};
  bool _scheduled = false;
  bool _routeActive = true;
  bool get active => widget.active && _routeActive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(VideoPoolViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    sample();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeActive = ModalRoute.isCurrentOf(context) ?? true;
    sample();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.observeAppLifecycle) {
      widget.pool.setForeground(state == AppLifecycleState.resumed);
      sample();
    }
  }

  void sample() {
    if (_scheduled || !mounted) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted) return;
      for (final callback in List.of(samplers)) {
        callback();
      }
      widget.pool.schedule();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    samplers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _VideoViewportBinding(
    owner: this,
    pool: widget.pool,
    child: SizedBox(
      key: viewportKey,
      child: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (_) {
          sample();
          return false;
        },
        child: SizeChangedLayoutNotifier(
          child: NotificationListener<ScrollMetricsNotification>(
            onNotification: (notification) {
              if (notification.depth == 0) sample();
              return false;
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.depth == 0) {
                  if (active &&
                      widget.observeScroll &&
                      (notification is ScrollUpdateNotification ||
                          notification is OverscrollNotification)) {
                    widget.pool.onScroll();
                  }
                  sample();
                }
                return false;
              },
              child: widget.child,
            ),
          ),
        ),
      ),
    ),
  );
}

class _VideoViewportBinding extends InheritedWidget {
  const _VideoViewportBinding({
    required this.owner,
    required this.pool,
    required super.child,
  });

  final _VideoPoolViewportState owner;
  final VideoPool pool;

  @override
  bool updateShouldNotify(_VideoViewportBinding oldWidget) =>
      owner != oldWidget.owner || pool != oldWidget.pool;
}

class _VideoViewVisibility extends InheritedWidget {
  const _VideoViewVisibility({
    required this.isVisible,
    required this.fraction,
    required super.child,
  });
  final bool isVisible;
  final ValueListenable<double> fraction;
  @override
  bool updateShouldNotify(_VideoViewVisibility oldWidget) =>
      oldWidget.isVisible != isVisible || oldWidget.fraction != fraction;
}

/// Registers an attachment view and exposes its shared logical state.
/// Use a stable [videoKey] to preserve identity independently of list ordering.
class VideoFeedView extends StatefulWidget {
  const VideoFeedView({
    super.key,
    this.scope = 'default',
    this.videoKey,
    required this.noteId,
    required this.listIndex,
    required this.listSubIndex,
    required this.url,
    required this.builder,
    this.enable = true,
  });

  /// Visibility of this widget, independently of other views sharing FeedVideo.
  static bool isVisibleOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_VideoViewVisibility>()
          ?.isVisible ??
      false;

  static ValueListenable<double>? visibilityOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_VideoViewVisibility>()
      ?.fraction;

  final String scope;
  final Object? videoKey;
  final String noteId;
  final int listIndex;
  final int listSubIndex;
  final String url;
  final bool enable;
  final Widget Function(BuildContext, FeedVideo) builder;

  @override
  State<VideoFeedView> createState() => _VideoFeedViewState();
}

class _VideoFeedViewState extends State<VideoFeedView> {
  FeedVideo? _video;
  final ValueNotifier<double> _visibility = ValueNotifier(0);
  _VideoPoolViewportState? _viewport;

  void _register(VideoPool pool) {
    _video = pool.register(
      scope: widget.scope,
      noteId: widget.noteId,
      listIndex: widget.listIndex,
      listSubIndex: widget.listSubIndex,
      url: widget.url,
      enable: widget.enable,
      owner: this,
      videoKey: widget.videoKey,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final binding = context
        .dependOnInheritedWidgetOfExactType<_VideoViewportBinding>();
    if (binding == null) {
      throw FlutterError('VideoFeedView requires a VideoPoolViewport ancestor');
    }
    _viewport?.samplers.remove(_sample);
    _viewport = binding.owner;
    if (_video == null || !identical(_video!.pool, binding.pool)) {
      if (_video != null) _video!.pool.unregister(_video!, owner: this);
      _register(binding.pool);
    }
    _viewport!.samplers.add(_sample);
    _viewport!.sample();
  }

  @override
  void didUpdateWidget(VideoFeedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoKey != widget.videoKey ||
        oldWidget.url != widget.url ||
        oldWidget.scope != widget.scope ||
        oldWidget.noteId != widget.noteId) {
      if (_video != null) _video!.pool.unregister(_video!, owner: this);
      _register(_viewport!.widget.pool);
    }
    _video!.updatePosition(
      listIndex: widget.listIndex,
      listSubIndex: widget.listSubIndex,
    );
    _video!.pool.updateReferenceEnabled(_video!, this, widget.enable);
    _viewport?.sample();
  }

  void _sample() {
    if (!mounted) return;
    final box = context.findRenderObject();
    final viewport = _viewport?.viewportKey.currentContext?.findRenderObject();
    if (box is! RenderBox ||
        viewport is! RenderBox ||
        !box.hasSize ||
        !viewport.hasSize) {
      return;
    }
    final rect = box.localToGlobal(Offset.zero) & box.size;
    final visible = viewport.localToGlobal(Offset.zero) & viewport.size;
    final intersection = rect.intersect(visible);
    final area =
        math.max(0.0, intersection.width) * math.max(0.0, intersection.height);
    final fraction = _viewport!.active && widget.enable
        ? visibleFraction(
            area,
            rect.width * rect.height,
            visible.width * visible.height,
          )
        : 0.0;
    final wasVisible = _visibility.value > 0;
    _visibility.value = fraction;
    if (wasVisible != (fraction > 0)) setState(() {});
    _video!.pool.updateVisibility(_video!, fraction, owner: this);
  }

  @override
  void dispose() {
    _viewport?.samplers.remove(_sample);
    if (_video != null) _video!.pool.unregister(_video!, owner: this);
    _visibility.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _VideoViewVisibility(
    isVisible: _visibility.value > 0,
    fraction: _visibility,
    child: Builder(builder: (context) => widget.builder(context, _video!)),
  );
}
