import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';
import 'package:video_player/video_player.dart' show VideoPlayerOptions;
import 'fvp_video_playback.dart';
import 'video_thumbnail_cache.dart';
import '../status/server.dart';
import '../widgets/mk_image.dart' show resolvePostMediaUrl;

/// One pool for timeline, note details and media previews in this app scope.
final appVideoPoolProvider = Provider<VideoPool>((ref) {
  ref.watch(
    currentLoginUserProvider.select((user) => (user?.serverUrl, user?.id)),
  );
  final covers = VideoThumbnailCache();
  final pool = VideoPool(
    thumbnailLoader: covers.read,
    prepareVisibleThumbnails: true,
    // One playing, one prepared next, plus two recently used sessions.
    maxSessions: 4,
    factory: (url) => FvpVideoPlayback(
      resolvePostMediaUrl(
        url,
        serverUrl: ref.read(currentLoginUserProvider)?.serverUrl,
      ),
      thumbnailCache: covers,
      thumbnailKey: url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    ),
  );
  ref.onDispose(pool.dispose);
  return pool;
});

/// FVP is registered once at startup; every attachment uses the existing
/// video_player adapter, preserving pooling, progress and shared sessions.
VideoPlayback createAppVideoPlayback(String url) => FvpVideoPlayback(
  url,
  videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
);

@immutable
class NoteVideoContext {
  const NoteVideoContext({
    required this.listKey,
    required this.noteId,
    required this.listIndex,
  });
  final String listKey;
  final String noteId;
  final int listIndex;
  Object attachmentKey(String fileId) => (listKey, noteId, fileId);

  static NoteVideoContext of(BuildContext context, String noteId) {
    final list = context
        .dependOnInheritedWidgetOfExactType<_VideoListContext>();
    final origin = list?.origin;
    return NoteVideoContext(
      listKey: list?.listKey ?? 'standalone',
      noteId: noteId,
      listIndex: origin?.noteId == noteId
          ? origin!.listIndex
          : AppVideoPosition.indexOf(context),
    );
  }
}

class AppVideoPosition extends InheritedWidget {
  const AppVideoPosition({
    super.key,
    required this.index,
    required super.child,
  });
  final int index;
  static int indexOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppVideoPosition>()?.index ??
      0;
  @override
  bool updateShouldNotify(AppVideoPosition oldWidget) =>
      index != oldWidget.index;
}

class _VideoListContext extends InheritedWidget {
  const _VideoListContext({
    required this.listKey,
    this.origin,
    required super.child,
  });
  final String listKey;
  final NoteVideoContext? origin;
  @override
  bool updateShouldNotify(_VideoListContext oldWidget) =>
      listKey != oldWidget.listKey || origin != oldWidget.origin;
}

/// Shared eligibility for retained tab pages, without affecting their layout.
class AppVideoActivity extends InheritedWidget {
  const AppVideoActivity({
    super.key,
    required this.active,
    required super.child,
  });
  final bool active;
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppVideoActivity>()?.active ??
      true;
  @override
  bool updateShouldNotify(AppVideoActivity oldWidget) =>
      active != oldWidget.active;
}

/// Creates a stable list identity, or inherits it when opening a related page.
class AppVideoViewport extends ConsumerStatefulWidget {
  const AppVideoViewport({
    super.key,
    required this.child,
    this.origin,
    this.active = true,
    this.observeScroll = true,
  });
  static bool hasOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_VideoListContext>() != null;
  final Widget child;
  final NoteVideoContext? origin;
  final bool active;
  final bool observeScroll;
  @override
  ConsumerState<AppVideoViewport> createState() => _AppVideoViewportState();
}

class _AppVideoViewportState extends ConsumerState<AppVideoViewport> {
  static int _nextListId = 0;
  late final String _listKey = 'video-list-${++_nextListId}';
  @override
  Widget build(BuildContext context) {
    final pool = ref.watch(appVideoPoolProvider);
    final listKey = widget.origin?.listKey ?? _listKey;
    final active =
        widget.active &&
        TickerMode.valuesOf(context).enabled &&
        AppVideoActivity.of(context) &&
        (ModalRoute.isCurrentOf(context) ?? true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && active) pool.setScope(listKey);
    });
    return _VideoListContext(
      listKey: listKey,
      origin: widget.origin,
      child: VideoPoolViewport(
        pool: pool,
        active: active,
        observeScroll: widget.observeScroll,
        child: widget.child,
      ),
    );
  }
}
