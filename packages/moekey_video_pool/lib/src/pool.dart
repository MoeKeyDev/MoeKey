import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import 'playback.dart';

class VideoSession {
  VideoSession(this.id, this.url, this.player);
  final int id;
  final String url;
  final VideoPlayback player;
  bool _completionDelivered = false;
  int _lastUse = 0;
  String _lastState = '';
  Future<void>? _thumbnailTask;
  int _thumbnailAttempts = 0;
  FeedVideo? _owner;
}

class _VideoReference {
  _VideoReference({required this.enable});
  bool enable;
  double visibility = 0;
}

class FeedVideo extends ChangeNotifier {
  FeedVideo._(
    this.pool,
    this.scope,
    this.noteId,
    int listIndex,
    int listSubIndex,
    this.url,
    this.videoKey,
  ) : _listIndex = listIndex,
      _listSubIndex = listSubIndex,
      _speed = pool.globalPlaybackSpeed;
  final VideoPool pool;
  final String scope;
  final String noteId;
  final String url;

  /// Stable attachment identity, independent of ordering.
  final Object? videoKey;
  int _listIndex;
  int _listSubIndex;
  int get listIndex => _listIndex;
  set listIndex(int value) =>
      updatePosition(listIndex: value, listSubIndex: _listSubIndex);
  int get listSubIndex => _listSubIndex;
  set listSubIndex(int value) =>
      updatePosition(listIndex: _listIndex, listSubIndex: value);

  /// Changes ordering without replacing this attachment's playback state.
  void updatePosition({required int listIndex, required int listSubIndex}) =>
      pool._updatePosition(this, listIndex, listSubIndex);
  double _visibility = 0;
  double get visibility => _visibility;
  final Map<Object, _VideoReference> _references = {};
  int get referenceCount => _references.length;
  bool _registered = true;
  bool get registered => _registered;
  bool _enabled = true;
  bool get enable => _enabled;
  set enable(bool value) => pool._setEnabled(this, value);
  Object? _error;
  Object? get error => _error;
  bool _preparing = false;
  bool get preparing => _preparing;
  final ValueNotifier<Duration> _progress = ValueNotifier(Duration.zero);
  ValueListenable<Duration> get progress => _progress;
  double _speed;
  bool _muted = true;

  /// May be shared with another attachment; only render [controller] when ready.
  VideoSession? get session => pool._sessions[url];
  VideoPlayerController? get controller =>
      ready ? session?.player.nativeController : null;
  bool get isCurrent => identical(pool._current, this) && !pool._preview;
  bool get isPlaying =>
      isCurrent &&
      identical(session?._owner, this) &&
      (session?.player.playing ?? false);

  /// Compressed, resized cover usable as Image(image: video.thumbnail!).
  /// Available independently of ownership/readiness; null until capture succeeds.
  ImageProvider<Object>? get thumbnail => pool._thumbnails[url];
  bool get ready =>
      identical(session?._owner, this) &&
      (session?.player.initialized ?? false);
  double get playbackSpeed => _speed;
  double get globalPlaybackSpeed => pool.globalPlaybackSpeed;
  bool get muted => _muted;
  Future<void> play() => pool._command(this, (p) => p.play());
  Future<void> pause() => pool._command(this, (p) => p.pause(), pause: true);
  Future<void> seekTo(Duration value) =>
      pool._command(this, (p) => p.seek(value));
  Future<void> setPlaybackSpeed(double value) {
    _validateSpeed(value);
    return pool._command(this, (p) => p.setSpeed(value));
  }

  Future<void> setGlobalPlaybackSpeed(double value) =>
      pool.setGlobalPlaybackSpeed(value);
  Future<void> setMuted(bool value) =>
      pool._command(this, (p) => p.setMuted(value));
  bool _notificationPending = false;
  bool _disposed = false;
  // Shared references must be released before disposing the notifier itself.
  // _disposeState calls super.dispose when the final reference is removed.
  @override
  // ignore: must_call_super
  void dispose() {
    if (_disposed) return;
    pool.unregister(this);
  }

  void _disposeState() {
    if (_disposed) return;
    _disposed = true;
    _progress.dispose();
    super.dispose();
  }

  void changed() {
    if (!registered) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_notificationPending) return;
      _notificationPending = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationPending = false;
        if (registered) notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }
}

/// One URL cache and one playback owner for all scopes and the preview.
class VideoPool extends ChangeNotifier {
  VideoPool({
    PlaybackFactory? factory,
    this.maxSessions = 3,
    this.thumbnailLoader,
    this.prepareVisibleThumbnails = false,
    this.dwell = const Duration(milliseconds: 200),
    this.scrollIdleDelay = const Duration(milliseconds: 200),
    this.notifyVisibilityChanges = false,
    String initialScope = 'default',
  }) : factory = factory ?? VideoPlayerPlayback.new {
    _activeScope = initialScope;
    if (maxSessions < 1 || dwell.isNegative || scrollIdleDelay.isNegative) {
      throw ArgumentError('Invalid capacity or delays');
    }
  }
  final PlaybackFactory factory;
  final Future<ImageProvider<Object>?> Function(String url)? thumbnailLoader;
  final bool prepareVisibleThumbnails;
  final _thumbnailReads = <String>{};
  Timer? _coverTimer;
  bool _warmingCovers = false;
  final int maxSessions;
  final Duration dwell;
  final Duration scrollIdleDelay;
  final bool notifyVisibilityChanges;
  final List<FeedVideo> _tiles = [];
  List<FeedVideo> get tiles => UnmodifiableListView(_tiles);
  final Map<String, VideoSession> _sessions = {};
  // Small bounded URL cache survives decoder eviction and is shared by copies.
  final _thumbnails = <String, ImageProvider<Object>>{};
  static const _maxThumbnails = 16;
  final Set<String> _pausedNotes = {};
  final Set<String> _finishedNotes = {};
  final Map<String, FeedVideo> _pendingNext = {};
  final List<String> _events = [];
  List<String> get events => UnmodifiableListView(_events);
  FeedVideo? _current;
  String _activeScope = 'default';
  bool _preview = false;
  bool _foreground = true;
  bool _scrolling = false;
  FeedVideo? _scrollStartVideo;
  double? _scrollStartVisibility;
  FeedVideo? get current => _current;
  String get activeScope => _activeScope;
  bool get preview => _preview;
  bool get foreground => _foreground;
  bool get scrolling => _scrolling;
  String? get previewUrl => _previewUrl;
  int? get previewSubIndex => _previewSubIndex;
  double _globalPlaybackSpeed = 1;
  double get globalPlaybackSpeed => _globalPlaybackSpeed;
  String? _previewUrl;
  int? _previewSubIndex;
  Timer? _timer;
  Timer? _scrollIdleTimer;
  Future<void>? _shutdownFuture;
  FeedVideo? _candidate;
  Future<void> _tail = Future.value();
  int _revision = 0;
  int _nextId = 0;
  int _useClock = 0;
  bool _closed = false;
  bool _notificationPending = false;
  int get liveCount => _sessions.length;
  VideoSession? get previewSession => _sessions[_previewUrl];
  String _noteKey(FeedVideo t) => '${t.scope}/${t.noteId}';
  Future<void> get settled => _tail;

  void _log(String value) {
    _events.insert(0, value);
    if (events.length > 35) _events.removeLast();
    _notifyPool();
  }

  void _notifyPool() {
    if (_closed) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_notificationPending) return;
      _notificationPending = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationPending = false;
        if (!_closed) notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  void _notifyTiles() {
    for (final t in List.of(tiles)) {
      t.changed();
    }
    _notifyPool();
  }

  Future<void> _enqueue(Future<void> Function() action) {
    if (_closed) return Future.value();
    final result = _tail.then((_) => action());
    _tail = result.catchError((Object error) {
      _log('ERROR $error');
    });
    return result;
  }

  FeedVideo register({
    required String scope,
    required String noteId,
    required int listIndex,
    required int listSubIndex,
    required String url,
    bool enable = true,
    Object? owner,
    Object? videoKey,
  }) {
    if (_closed) throw StateError('VideoPool has been disposed');
    final token = owner ?? Object();
    // Content validation avoids sharing stale slots during a prepend/reorder.
    final existing = _tiles
        .where(
          (t) =>
              t.scope == scope &&
              (videoKey != null
                  ? t.videoKey == videoKey
                  : t.videoKey == null &&
                        t.listIndex == listIndex &&
                        t.listSubIndex == listSubIndex) &&
              t.noteId == noteId &&
              t.url == url,
        )
        .firstOrNull;
    if (existing != null) {
      existing._references[token] = _VideoReference(enable: enable);
      _applyEnabled(existing, existing._references.values.any((r) => r.enable));
      _log(
        'RETAIN $scope $listIndex:$listSubIndex (${existing.referenceCount})',
      );
      existing.updatePosition(listIndex: listIndex, listSubIndex: listSubIndex);
      existing.changed();
      return existing;
    }
    final t = FeedVideo._(
      this,
      scope,
      noteId,
      listIndex,
      listSubIndex,
      url,
      videoKey,
    );
    t._references[token] = _VideoReference(enable: enable);
    t._enabled = enable;
    _tiles.add(t);
    final key = _noteKey(t);
    if (enable && _finishedNotes.remove(key)) _pendingNext[key] = t;
    _log('REGISTER $scope $listIndex:$listSubIndex');
    _readThumbnail(url);
    return t;
  }

  void _setEnabled(FeedVideo t, bool value) {
    if (!t.registered) return;
    for (final reference in t._references.values) {
      reference.enable = value;
    }
    _applyEnabled(t, value);
    _aggregateVisibility(t);
    schedule();
  }

  /// Updates one mounted view without disabling other references to the video.
  void updateReferenceEnabled(FeedVideo t, Object owner, bool value) {
    final reference = t._references[owner];
    if (!identical(t.pool, this) || !t.registered || reference == null) return;
    reference.enable = value;
    _applyEnabled(t, t._references.values.any((r) => r.enable));
    _aggregateVisibility(t);
    schedule();
  }

  void _applyEnabled(FeedVideo t, bool value) {
    if (!t.registered || t._enabled == value) return;
    t._enabled = value;
    final key = _noteKey(t);
    if (value) {
      if (_finishedNotes.remove(key)) {
        _pendingNext[key] = t;
      }
    } else {
      if (identical(_pendingNext[key], t)) {
        final following =
            tiles
                .where(
                  (n) =>
                      n.enable &&
                      _noteKey(n) == key &&
                      n.listSubIndex > t.listSubIndex,
                )
                .toList()
              ..sort((a, b) => a.listSubIndex.compareTo(b.listSubIndex));
        _pendingNext.remove(key);
        if (following.isNotEmpty) {
          _pendingNext[key] = following.first;
        } else {
          _finishedNotes.add(key);
        }
      }
      if (identical(_candidate, t)) {
        _timer?.cancel();
        _candidate = null;
      }
      if (identical(_current, t)) {
        ++_revision;
        t._preparing = false;
        if (!_preview) _current = null;
        _enqueue(_pauseAll);
      }
    }
    _log('ENABLE ${t.listIndex}:${t.listSubIndex} $value');
    _notifyTiles();
    schedule();
  }

  void unregister(FeedVideo t, {Object? owner}) {
    if (!identical(t.pool, this) || !t.registered) return;
    final token = owner ?? t._references.keys.lastOrNull;
    if (token == null || t._references.remove(token) == null) return;
    if (t._references.isNotEmpty) {
      _applyEnabled(t, t._references.values.any((r) => r.enable));
      _aggregateVisibility(t);
      _log(
        'DROP REFERENCE ${t.listIndex}:${t.listSubIndex} (${t.referenceCount})',
      );
      t.changed();
      schedule();
      return;
    }
    if (t.enable && !(_preview && identical(_current, t))) {
      _setEnabled(t, false);
    }
    t._registered = false;
    _tiles.remove(t);
    _log('UNREGISTER ${t.listIndex}:${t.listSubIndex}');
    if (identical(_current, t) && !_preview) {
      _current = null;
      ++_revision;
      _enqueue(_pauseAll);
    }
    if (identical(_candidate, t)) {
      _timer?.cancel();
      _candidate = null;
    }
    final key = _noteKey(t);
    if (!tiles.any((n) => _noteKey(n) == key)) {
      _pausedNotes.remove(key);
      _finishedNotes.remove(key);
      _pendingNext.remove(key);
    }
    t._disposeState();
    schedule();
  }

  void setScope(String value) {
    if (_closed || value == _activeScope) return;
    _activeScope = value;
    _current = null;
    ++_revision;
    _timer?.cancel();
    _enqueue(_pauseAll);
    _log('SCOPE $value');
    schedule();
  }

  void setForeground(bool value) {
    if (_closed || value == _foreground) return;
    _foreground = value;
    ++_revision;
    _timer?.cancel();
    if (!value) {
      _enqueue(_pauseAll);
    } else if (_preview) {
      /* A user resumes the preview explicitly. */
    } else {
      schedule();
    }
    _log('FOREGROUND $value');
  }

  void updateVisibility(FeedVideo t, double fraction, {Object? owner}) {
    if (!identical(t.pool, this) || !t.registered || !fraction.isFinite) return;
    final reference = t._references[owner ?? t._references.keys.lastOrNull];
    if (reference == null) return;
    reference.visibility = fraction.clamp(0.0, 1.0);
    _aggregateVisibility(t);
  }

  void _aggregateVisibility(FeedVideo t) {
    final value = t._references.values
        .where((r) => r.enable)
        .fold(0.0, (highest, r) => math.max(highest, r.visibility));
    if (t.visibility == value) return;
    t._visibility = value;
    if (notifyVisibilityChanges) t.changed();
  }

  /// Signal each scroll movement; idle detection is owned by the pool.
  void onScroll() {
    if (_closed) return;
    _scrollIdleTimer?.cancel();
    setScrolling(true);
    _scrollIdleTimer = Timer(scrollIdleDelay, () => setScrolling(false));
  }

  void setScrolling(bool value) {
    if (_closed || _scrolling == value) return;
    _scrolling = value;
    if (value) {
      _scrollStartVideo = _current;
      _scrollStartVisibility = _current?.visibility;
      ++_revision;
      _timer?.cancel();
      _candidate = null;
      final t = _current;
      if (t != null && t.preparing && !t.isPlaying) {
        _current = null;
        t._preparing = false;
      }
    }
    _log(value ? 'SCROLL · defer autoplay/preload' : 'IDLE · reconcile');
    final reconsiderCurrent =
        !value &&
        identical(_current, _scrollStartVideo) &&
        _current != null &&
        _current!.visibility != _scrollStartVisibility;
    schedule(reconsiderCurrent: reconsiderCurrent);
    if (!value) {
      _scrollStartVideo = null;
      _scrollStartVisibility = null;
    }
  }

  void _updatePosition(FeedVideo t, int index, int subIndex) {
    if (!t.registered ||
        (t._listIndex == index && t._listSubIndex == subIndex)) {
      return;
    }
    t._listIndex = index;
    t._listSubIndex = subIndex;
    if (identical(_candidate, t)) {
      _timer?.cancel();
      _candidate = null;
    }
    t.changed();
    schedule();
  }

  void schedule({bool reconsiderCurrent = false}) {
    if (_closed || !_foreground || _preview) return;
    _scheduleCovers();
    final old = _current;
    final keepOld =
        old != null &&
        old.registered &&
        old.enable &&
        old.scope == _activeScope &&
        old.visibility > 0 &&
        !(old.ready && old.session!.player.completed) &&
        !_finishedNotes.contains(_noteKey(old));
    if (keepOld && !reconsiderCurrent) return;
    if (old != null && !keepOld) {
      _current = null;
      ++_revision;
      _enqueue(_pauseAll);
      _notifyTiles();
    }
    if (_scrolling) {
      _timer?.cancel();
      _candidate = null;
      return;
    }
    final candidates =
        tiles
            .where(
              (t) =>
                  t.enable &&
                  t.scope == _activeScope &&
                  t.visibility > 0 &&
                  !_pausedNotes.contains(_noteKey(t)) &&
                  !_finishedNotes.contains(_noteKey(t)) &&
                  (!_pendingNext.containsKey(_noteKey(t)) ||
                      identical(t, _pendingNext[_noteKey(t)])),
            )
            .toList()
          ..sort((a, b) {
            final v = b.visibility.compareTo(a.visibility);
            if (v != 0) return v;
            final n = a.listIndex.compareTo(b.listIndex);
            return n != 0 ? n : a.listSubIndex.compareTo(b.listSubIndex);
          });
    final next = candidates.firstOrNull;
    if (keepOld && identical(next, old)) {
      _timer?.cancel();
      _candidate = null;
      return;
    }
    if (next == null) {
      _timer?.cancel();
      _candidate = null;
      return;
    }
    if (identical(next, _candidate) && (_timer?.isActive ?? false)) return;
    _timer?.cancel();
    _candidate = next;
    _timer = Timer(dwell, () {
      _candidate = null;
      if (next.registered &&
          next.enable &&
          next.visibility > 0 &&
          _foreground &&
          !_scrolling &&
          !_preview &&
          next.scope == _activeScope) {
        _select(next, autoplay: true);
      }
    });
  }

  Future<VideoSession> _ensure(String url, {bool capture = true}) async {
    final existing = _sessions[url];
    if (existing != null) {
      existing._lastUse = ++_useClock;
      return existing;
    }
    if (_sessions.length >= maxSessions) {
      final entries =
          _sessions.values
              .where((s) => s.url != _current?.url && s.url != _previewUrl)
              .toList()
            ..sort((a, b) => a._lastUse.compareTo(b._lastUse));
      if (entries.isEmpty) throw StateError('No free session slot');
      final victim = entries.first;
      await victim.player.release();
      _sessions.remove(victim.url);
      _log('RELEASE S${victim.id}');
    }
    final s = VideoSession(++_nextId, url, factory(url));
    s._lastUse = ++_useClock;
    _sessions[url] = s;
    _log('CREATE S${s.id} ($liveCount/$maxSessions)');
    s.player.addListener(() => _playerChanged(s));
    try {
      await s.player.initialize();
      _log('READY S${s.id} (initialized, NOT first-frame)');
      if (capture) unawaited(_captureThumbnail(s));
      return s;
    } catch (_) {
      await s.player.release();
      _sessions.remove(url);
      rethrow;
    }
  }

  void _publishThumbnail(String url, ImageProvider<Object> image) {
    if (_closed) return;
    _thumbnails[url] = image;
    _log('COVER READY');
    while (_thumbnails.length > _maxThumbnails) {
      final evicted = _thumbnails.remove(_thumbnails.keys.first)!;
      unawaited(evicted.evict());
    }
    for (final tile in List.of(tiles)) {
      if (tile.url == url) tile.changed();
    }
  }

  void _readThumbnail(String url) {
    if (thumbnailLoader == null ||
        _thumbnails.containsKey(url) ||
        !_thumbnailReads.add(url)) {
      return;
    }
    unawaited(() async {
      try {
        final image = await thumbnailLoader!(url);
        if (image != null && !_closed) _publishThumbnail(url, image);
      } catch (_) {
        // Missing/unavailable disk cache must not block playback.
      } finally {
        _thumbnailReads.remove(url);
      }
    }());
  }

  Future<void> _captureThumbnail(VideoSession s) {
    final pending = s._thumbnailTask;
    if (pending != null) return pending;
    if (_closed ||
        !s.player.initialized ||
        s._thumbnailAttempts >= 2 ||
        _thumbnails.containsKey(s.url) ||
        !identical(_sessions[s.url], s)) {
      return Future.value();
    }
    ++s._thumbnailAttempts;
    return s._thumbnailTask = _performCapture(s);
  }

  Future<void> _performCapture(VideoSession s) async {
    try {
      final image = await s.player.captureThumbnail().timeout(
        const Duration(seconds: 3),
      );
      if (image != null && !_closed && identical(_sessions[s.url], s)) {
        _publishThumbnail(s.url, image);
      }
    } catch (_) {
      // Cover capture is optional and must not fail playback.
    } finally {
      s._thumbnailTask = null;
    }
  }

  bool _coverEligible(FeedVideo t) =>
      !_closed &&
      _foreground &&
      !_scrolling &&
      !_preview &&
      t.registered &&
      t.enable &&
      t.scope == _activeScope &&
      t.visibility > 0;

  void _scheduleCovers() {
    if (!prepareVisibleThumbnails ||
        _warmingCovers ||
        _scrolling ||
        _closed ||
        !_foreground ||
        _preview) {
      return;
    }
    _coverTimer?.cancel();
    // Autoplay selection gets priority. Only warm settled, visible tiles.
    _coverTimer = Timer(dwell + const Duration(milliseconds: 250), () {
      final pending =
          tiles
              .where(
                (t) => _coverEligible(t) && !_thumbnails.containsKey(t.url),
              )
              .toList()
            ..sort((a, b) => b.visibility.compareTo(a.visibility));
      _warmingCovers = true;
      unawaited(() async {
        try {
          for (final tile in pending) {
            if (!_coverEligible(tile)) continue;
            try {
              await _enqueue(() async {
                if (!_coverEligible(tile) ||
                    _thumbnails.containsKey(tile.url)) {
                  return;
                }
                await _readPendingCover(tile.url);
                if (!_coverEligible(tile) ||
                    _thumbnails.containsKey(tile.url)) {
                  return;
                }
                final session = await _ensure(tile.url, capture: false);
                // Initialize/preload paused; never bind ownership or play here.
                if (_coverEligible(tile)) {
                  await _captureThumbnail(session);
                  if (!_thumbnails.containsKey(tile.url)) {
                    await Future<void>.delayed(
                      const Duration(milliseconds: 200),
                    );
                    if (_coverEligible(tile)) await _captureThumbnail(session);
                  }
                }
              });
            } catch (_) {
              // A failed cover must not prevent other visible tiles warming.
            }
          }
        } finally {
          _warmingCovers = false;
        }
      }());
    });
  }

  Future<void> _readPendingCover(String url) async {
    if (thumbnailLoader == null) return;
    try {
      final image = await thumbnailLoader!(url);
      if (image != null && !_closed) _publishThumbnail(url, image);
    } catch (_) {}
  }

  void _playerChanged(VideoSession s) {
    if (_closed) return;
    if (s.player.playing) unawaited(_captureThumbnail(s));
    final state =
        '${s.player.initialized}/${s.player.playing}/${s.player.completed}/${s.player.speed}/${s.player.muted}/${s.player.error}';
    final stateChanged = s._lastState != state;
    s._lastState = state;
    final t = s._owner;
    if (t != null && t.registered) {
      t._progress.value = s.player.position;
      t._speed = s.player.speed;
      if (!_preview) t._muted = s.player.muted;
      if (stateChanged) {
        t._error = s.player.error;
        t.changed();
      }
      // Progress has its own notifier; don't rebuild tiles or the debug panel.
    }
    if (!s.player.completed) {
      s._completionDelivered = false;
      return;
    }
    if (s._completionDelivered) return;
    s._completionDelivered = true;
    _log('COMPLETE S${s.id}');
    if (_preview || t == null || !identical(_current, t)) return;
    if (_pausedNotes.contains(_noteKey(t))) return;
    final following =
        tiles
            .where(
              (n) =>
                  n.enable &&
                  n.scope == t.scope &&
                  n.noteId == t.noteId &&
                  n.listSubIndex > t.listSubIndex,
            )
            .toList()
          ..sort((a, b) => a.listSubIndex.compareTo(b.listSubIndex));
    final next = following.firstOrNull;
    if (next == null) {
      _finishedNotes.add(_noteKey(t));
      _log('NOTE FINISHED ${t.noteId}');
      _notifyTiles();
    } else {
      _pendingNext[_noteKey(t)] = next;
      if (next.visibility > 0 &&
          _foreground &&
          !_scrolling &&
          t.scope == _activeScope) {
        _select(next, autoplay: true, restart: true);
      } else {
        _current = null;
        ++_revision;
        _enqueue(_pauseAll);
        _notifyTiles();
      }
    }
  }

  Future<void> _pauseAll() async {
    for (final s in _sessions.values) {
      if (s.player.playing) {
        await s.player.pause();
        _log('PAUSE S${s.id}');
      }
    }
    _notifyTiles();
  }

  Future<void> _bind(
    VideoSession s,
    FeedVideo t, {
    bool restart = false,
  }) async {
    if (!identical(s._owner, t) || restart || s.player.completed) {
      final position = restart || (identical(s._owner, t) && s.player.completed)
          ? Duration.zero
          : t.progress.value;
      s._owner = null;
      await s.player.seek(position);
      await s.player.setSpeed(t._speed);
      await s.player.setMuted(t._muted);
      s._completionDelivered = false;
      s._owner = t;
      t._progress.value = position;
    }
  }

  FeedVideo? _next(FeedVideo t) {
    final ordered =
        tiles
            .where(
              (n) =>
                  n.enable &&
                  n.scope == t.scope &&
                  (n.listIndex > t.listIndex ||
                      (n.noteId == t.noteId &&
                          n.listSubIndex > t.listSubIndex)),
            )
            .toList()
          ..sort((a, b) {
            final n = a.listIndex.compareTo(b.listIndex);
            return n != 0 ? n : a.listSubIndex.compareTo(b.listSubIndex);
          });
    return ordered.firstOrNull;
  }

  Future<void> _select(
    FeedVideo t, {
    required bool autoplay,
    bool restart = false,
    Future<void> Function(VideoPlayback)? action,
  }) {
    final revision = ++_revision;
    _timer?.cancel();
    _current = t;
    t._preparing = true;
    t._error = null;
    _notifyTiles();
    return _enqueue(() async {
      if (!_valid(t, revision)) {
        t._preparing = false;
        t.changed();
        return;
      }
      await _pauseAll();
      try {
        final s = await _ensure(t.url);
        if (!_valid(t, revision)) return;
        await _bind(s, t, restart: restart);
        if (action != null) await action(s.player);
        if (!_valid(t, revision)) {
          await s.player.pause();
          return;
        }
        if (autoplay) await s.player.play();
        if (action != null) {
          if (s.player.playing) {
            _pausedNotes.remove(_noteKey(t));
          } else {
            _pausedNotes.add(_noteKey(t));
          }
        }
        _log(
          '${s.player.playing ? 'PLAY' : 'SELECT'} '
          '${t.listIndex}:${t.listSubIndex} S${s.id}',
        );
        if (!_scrolling && action == null) {
          final next = _next(t);
          if (next != null && next.url != t.url && _valid(t, revision)) {
            try {
              await _ensure(next.url);
              _log('PRELOAD ${next.listIndex}:${next.listSubIndex}');
            } catch (e) {
              _log('PRELOAD ERROR $e');
            }
          }
        }
      } catch (e) {
        if (_valid(t, revision)) {
          t._error = e;
          _pausedNotes.add(_noteKey(t));
          _log('ERROR ${t.listIndex}:${t.listSubIndex} $e');
        }
      } finally {
        t._preparing = false;
        _notifyTiles();
      }
    });
  }

  bool _valid(FeedVideo t, int revision) =>
      !_closed &&
      _foreground &&
      !_preview &&
      t.registered &&
      t.enable &&
      t.scope == _activeScope &&
      revision == _revision;

  Future<void> _command(
    FeedVideo t,
    Future<void> Function(VideoPlayback) action, {
    bool pause = false,
  }) {
    if (!t.registered || !t.enable || _preview || !_foreground) {
      return Future.value();
    }
    final wasPlaying = t.isPlaying;
    _finishedNotes.remove(_noteKey(t));
    _pendingNext.remove(_noteKey(t));
    if (pause) {
      _pausedNotes.add(_noteKey(t));
    } else {
      _pausedNotes.remove(_noteKey(t));
    }
    return _select(t, autoplay: !pause && wasPlaying, action: action);
  }

  /// Applies to existing tiles and sets the default for future registrations.
  /// Explicit per-video speed changes made afterwards remain independent.
  Future<void> setGlobalPlaybackSpeed(double value) {
    _validateSpeed(value);
    return _enqueue(() async {
      _globalPlaybackSpeed = value;
      for (final t in tiles) {
        t._speed = value;
      }
      for (final s in _sessions.values) {
        await s.player.setSpeed(value);
      }
      _log('GLOBAL SPEED $value×');
      _notifyTiles();
    });
  }

  Future<void> openPreview(FeedVideo t) async {
    if (!t.registered || !t.enable) {
      return;
    }
    _preview = true;
    _previewUrl = t.url;
    _previewSubIndex = t.listSubIndex;
    _current = t;
    ++_revision;
    _timer?.cancel();
    _notifyTiles();
    await _enqueue(() async {
      final old = _sessions[t.url];
      final playing = identical(old?._owner, t) ? old!.player.playing : true;
      await _pauseAll();
      final s = await _ensure(t.url);
      if (!t.registered || !t.enable) return;
      await _bind(s, t);
      await s.player.setMuted(false);
      if (playing && _foreground) await s.player.play();
      _log('PREVIEW S${s.id}');
    });
  }

  Future<void> previewSelect(String? url, {int? listSubIndex}) {
    _previewUrl = url;
    _previewSubIndex = listSubIndex;
    return _enqueue(() async {
      await _pauseAll();
      if (url != null) {
        final origin = _current;
        final attachment = tiles
            .where(
              (t) =>
                  origin != null &&
                  t.scope == origin.scope &&
                  t.noteId == origin.noteId &&
                  t.url == url &&
                  (listSubIndex == null || t.listSubIndex == listSubIndex),
            )
            .firstOrNull;
        if (attachment != null && !attachment.enable) return;
        final s = await _ensure(url);
        final target = tiles
            .where(
              (t) =>
                  t.enable &&
                  origin != null &&
                  t.scope == origin.scope &&
                  t.noteId == origin.noteId &&
                  t.url == url &&
                  (listSubIndex == null || t.listSubIndex == listSubIndex),
            )
            .firstOrNull;
        if (target != null) await _bind(s, target);
        await s.player.setMuted(false);
        if (_foreground) await s.player.play();
        _log('PREVIEW SELECT S${s.id}');
      }
    });
  }

  Future<void> previewCommand(Future<void> Function(VideoPlayback) action) =>
      _enqueue(() async {
        final s = previewSession;
        if (s != null && _foreground) await action(s.player);
        _log('PREVIEW CONTROL');
      });
  Future<void> closePreview() => _enqueue(() async {
    final s = previewSession;
    final origin = _current;
    final matches = tiles
        .where(
          (t) =>
              t.enable &&
              origin != null &&
              t.scope == origin.scope &&
              t.noteId == origin.noteId &&
              t.url == _previewUrl,
        )
        .toList();
    final target =
        matches.where((t) => t.listSubIndex == _previewSubIndex).firstOrNull ??
        matches.firstOrNull;
    if (s != null) await s.player.setMuted(true);
    _preview = false;
    _previewUrl = null;
    _previewSubIndex = null;
    _current = target;
    if (target == null ||
        target.visibility <= 0 ||
        target.scope != _activeScope ||
        !_foreground) {
      _current = null;
      await _pauseAll();
    } else if (s != null && !s.player.playing) {
      _pausedNotes.add(_noteKey(target));
    }
    _log('RETURN ${s == null ? "image" : "S${s.id}"}');
    _notifyTiles();
    schedule();
  });

  /// Idempotent: await this to ensure all native instances are released.
  Future<void> shutdown() {
    if (_shutdownFuture == null) dispose();
    return _shutdownFuture!;
  }

  @override
  void dispose() {
    if (_closed) return;
    _closed = true;
    ++_revision;
    _timer?.cancel();
    _scrollIdleTimer?.cancel();
    _coverTimer?.cancel();
    _shutdownFuture = _releaseResources();
    super.dispose();
  }

  Future<void> _releaseResources() async {
    await _tail;
    for (final s in _sessions.values) {
      await s.player.release();
    }
    _sessions.clear();
    for (final image in _thumbnails.values) {
      await image.evict();
    }
    _thumbnails.clear();
    for (final tile in _tiles) {
      tile._registered = false;
      tile._references.clear();
      tile._disposeState();
    }
    _tiles.clear();
  }
}

double visibleFraction(
  double intersection,
  double tileArea,
  double viewportArea,
) {
  final denominator = math.min(tileArea, viewportArea);
  return denominator <= 0 ? 0 : (intersection / denominator).clamp(0.0, 1.0);
}

void _validateSpeed(double value) {
  if (!value.isFinite || value <= 0) {
    throw ArgumentError.value(value, 'speed', 'must be finite and positive');
  }
}
