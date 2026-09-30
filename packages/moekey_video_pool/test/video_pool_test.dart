import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/painting.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';

import 'support/fake_playback.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late VideoPool pool;
  late List<FakePlayback> players;
  FeedVideo tile(
    int index, {
    int sub = 0,
    String? url,
    String? note,
    String scope = 'A',
  }) => pool.register(
    scope: scope,
    noteId: note ?? 'note-$index',
    listIndex: index,
    listSubIndex: sub,
    url: url ?? 'https://test/$index/$sub',
  );
  Future<void> flush() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    await pool.settled;
  }

  setUp(() {
    players = [];
    pool = VideoPool(
      initialScope: 'A',
      dwell: Duration.zero,
      factory: (_) {
        final p = FakePlayback(
          onPlay: () {
            expect(
              players.where((p) => p.playing).length,
              lessThanOrEqualTo(1),
            );
          },
        );
        players.add(p);
        return p;
      },
    );
  });
  tearDown(() => pool.shutdown());

  test('registration reads cover without initializing any player', () async {
    await pool.shutdown();
    final image = MemoryImage(Uint8List.fromList([1, 2, 3]));
    pool = VideoPool(
      initialScope: 'A',
      thumbnailLoader: (_) async => image,
      factory: (_) {
        throw StateError('must not create player for disk cover');
      },
    );
    final a = tile(0);
    await flush();
    expect(a.thumbnail, same(image));
    expect(pool.liveCount, 0);
  });

  test(
    'settled visible covers prepare paused, excluding hidden and offscreen tiles',
    () async {
      await pool.shutdown();
      final image = MemoryImage(Uint8List.fromList([1, 2, 3]));
      pool = VideoPool(
        initialScope: 'A',
        dwell: Duration.zero,
        prepareVisibleThumbnails: true,
        maxSessions: 2,
        factory: (_) {
          final p = _ThumbnailPlayback(Future.value(image));
          players.add(p);
          return p;
        },
      );
      final a = tile(0);
      final b = tile(1);
      final hidden = tile(2)..enable = false;
      final offscreen = tile(3);
      pool.updateVisibility(a, 1);
      pool.updateVisibility(b, .8);
      pool.updateVisibility(hidden, 1);
      pool.setScrolling(true);
      pool.schedule();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(players, isEmpty);
      pool.setScrolling(false);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await pool.settled;
      expect(a.thumbnail, same(image));
      expect(b.thumbnail, same(image));
      expect(b.isPlaying, isFalse);
      expect(hidden.session, isNull);
      expect(offscreen.session, isNull);
      expect(players.where((p) => p.playing).length, lessThanOrEqualTo(1));
      expect(pool.liveCount, lessThanOrEqualTo(2));
    },
  );

  test(
    'stable attachment key shares state across ordering changes and releases references',
    () async {
      final key = ('list', 'note', 'file');
      final source = Object();
      final detail = Object();
      final a = pool.register(
        scope: 'A',
        noteId: 'note',
        listIndex: 4,
        listSubIndex: 2,
        url: 'https://test/video',
        videoKey: key,
        owner: source,
      );
      pool.updateVisibility(a, 1, owner: source);
      await a.play();
      await a.seekTo(const Duration(seconds: 3));
      await a.setPlaybackSpeed(1.5);
      final session = a.session;
      final b = pool.register(
        scope: 'A',
        noteId: 'note',
        listIndex: 5,
        listSubIndex: 3,
        url: 'https://test/video',
        videoKey: key,
        owner: detail,
      );
      expect(b, same(a));
      expect(a.listIndex, 5);
      expect(a.listSubIndex, 3);
      expect(a.referenceCount, 2);
      expect(a.progress.value, const Duration(seconds: 3));
      expect(a.playbackSpeed, 1.5);
      pool.updateVisibility(b, 1, owner: detail);
      pool.unregister(a, owner: source);
      expect(b.referenceCount, 1);
      expect(b.registered, true);
      expect(b.isPlaying, true);
      expect(b.session, same(session));
      pool.unregister(b, owner: detail);
      await flush();
      expect(pool.tiles, isEmpty);
      expect(b.registered, false);
      expect(players.where((p) => p.playing), isEmpty);
    },
  );

  test(
    'different attachment keys at the same position never share logical state',
    () {
      final a = pool.register(
        scope: 'A',
        noteId: 'note',
        listIndex: 0,
        listSubIndex: 0,
        url: 'https://test/video',
        videoKey: ('list', 'note', 'file-a'),
      );
      final b = pool.register(
        scope: 'A',
        noteId: 'note',
        listIndex: 0,
        listSubIndex: 0,
        url: 'https://test/video',
        videoKey: ('list', 'note', 'file-b'),
      );
      expect(b, isNot(same(a)));
      expect(pool.tiles.length, 2);
    },
  );

  test('scroll events debounce idle detection inside the pool', () {
    fakeAsync((clock) {
      final local = VideoPool(
        dwell: Duration.zero,
        factory: (_) => FakePlayback(),
      );
      final a = local.register(
        scope: 'default',
        noteId: 'note',
        listIndex: 0,
        listSubIndex: 0,
        url: 'https://test/video',
      );
      local.updateVisibility(a, 1);
      local.onScroll();
      clock.elapse(const Duration(milliseconds: 150));
      local.onScroll();
      clock.elapse(const Duration(milliseconds: 150));
      clock.flushMicrotasks();
      expect(local.scrolling, true);
      expect(local.liveCount, 0);
      clock.elapse(const Duration(milliseconds: 50));
      clock.flushMicrotasks();
      expect(local.scrolling, false);
      expect(a.isPlaying, true);
      unawaited(local.shutdown());
      clock.flushMicrotasks();
      a.dispose();
    });
  });

  test('pending sequence follows the attachment when indices change', () async {
    final a = tile(0);
    final b = tile(0, sub: 1);
    final c = tile(0, sub: 2);
    pool.updateVisibility(a, 1);
    pool.updateVisibility(c, 1);
    pool.schedule();
    await flush();
    (a.session!.player as FakePlayback).finish();
    await flush();
    b.updatePosition(listIndex: 5, listSubIndex: 4);
    pool.updateVisibility(b, 1);
    pool.schedule();
    await flush();
    expect(pool.current, same(b));
    expect(b.listIndex, 5);
    expect(b.listSubIndex, 4);
  });

  test('unregistering pending attachment skips to the next one', () async {
    final a = tile(0);
    final b = tile(0, sub: 1);
    final c = tile(0, sub: 2);
    pool.updateVisibility(a, 1);
    pool.updateVisibility(c, 1);
    pool.schedule();
    await flush();
    (a.session!.player as FakePlayback).finish();
    await flush();
    b.dispose();
    await flush();
    expect(pool.current, c);
    expect(b.registered, false);
  });

  test(
    'new attachment after completed note can participate in scheduling',
    () async {
      final a = tile(0);
      pool.updateVisibility(a, 1);
      pool.schedule();
      await flush();
      (a.session!.player as FakePlayback).finish();
      await flush();
      final b = tile(0, sub: 1);
      pool.updateVisibility(b, 1);
      pool.schedule();
      await flush();
      expect(pool.current, b);
    },
  );

  test(
    'exact visibility updates include sub-percent changes and zero',
    () async {
      final a = tile(0);
      pool.updateVisibility(a, .005);
      pool.schedule();
      await flush();
      expect(a.isPlaying, true);
      pool.updateVisibility(a, .004);
      expect(a.visibility, .004);
      pool.updateVisibility(a, 0);
      pool.schedule();
      await flush();
      expect(a.isPlaying, false);
    },
  );

  test('visibility changes do not notify presentation by default', () {
    final a = tile(0);
    var changes = 0;
    a.addListener(() => changes++);
    pool.updateVisibility(a, .1);
    pool.updateVisibility(a, .2);
    expect(changes, 0);
    expect(a.visibility, .2);
  });

  test('shutdown is idempotent and rejects new registrations', () async {
    await tile(0).play();
    pool.onScroll();
    final first = pool.shutdown();
    expect(pool.shutdown(), same(first));
    await first;
    expect(pool.liveCount, 0);
    expect(players.every((p) => p.released), true);
    expect(() => tile(1), throwsStateError);
    pool.dispose();
  });

  test('configuration validates capacity and delays', () {
    expect(() => VideoPool(maxSessions: 0), throwsArgumentError);
    expect(
      () => VideoPool(dwell: const Duration(milliseconds: -1)),
      throwsArgumentError,
    );
    expect(
      () => VideoPool(scrollIdleDelay: const Duration(milliseconds: -1)),
      throwsArgumentError,
    );
  });

  test(
    'disabled tiles skip autoplay, controls and sequential playback',
    () async {
      final a = tile(0);
      final hidden = tile(0, sub: 1);
      final c = tile(0, sub: 2);
      hidden.enable = false;
      for (final t in [a, hidden, c]) {
        pool.updateVisibility(t, 1);
      }
      pool.schedule();
      await flush();
      expect(pool.current, a);
      await hidden.play();
      expect(pool.current, a);
      (a.session!.player as FakePlayback).finish();
      await flush();
      expect(pool.current, c);
      c.enable = false;
      await flush();
      expect(c.isPlaying, false);
      expect(pool.tiles, contains(c));
    },
  );

  test('disabling pending attachment advances to next enabled video', () async {
    final a = tile(0);
    final b = tile(0, sub: 1);
    final c = tile(0, sub: 2);
    pool.updateVisibility(a, 1);
    pool.updateVisibility(c, 1);
    pool.schedule();
    await flush();
    (a.session!.player as FakePlayback).finish();
    await flush();
    b.enable = false;
    await flush();
    expect(pool.current, c);
  });

  test(
    'enabling after note completion preserves registration and resumes eligibility',
    () async {
      final a = tile(0);
      final b = tile(0, sub: 1);
      b.enable = false;
      pool.updateVisibility(a, 1);
      pool.updateVisibility(b, 1);
      pool.schedule();
      await flush();
      (a.session!.player as FakePlayback).finish();
      await flush();
      pool.updateVisibility(a, 0);
      b.enable = true;
      await flush();
      expect(pool.current, b);
      expect(pool.tiles.length, 2);
    },
  );

  test(
    'scroll end switches to the most visible video without a minimum',
    () async {
      final a = tile(0);
      final b = tile(1);
      pool.updateVisibility(a, .9);
      pool.updateVisibility(b, .3);
      pool.schedule();
      await flush();
      expect(pool.current, a);
      pool.setScrolling(true);
      pool.updateVisibility(a, .3);
      pool.updateVisibility(b, .6);
      pool.schedule();
      await flush();
      expect(pool.current, a);
      pool.setScrolling(false);
      await flush();
      expect(pool.current, b);
      pool.setScrolling(true);
      pool.updateVisibility(a, .4);
      pool.updateVisibility(b, .2);
      pool.setScrolling(false);
      await flush();
      expect(pool.current, a);
    },
  );

  test(
    'unchanged current visibility avoids replanning even if another grows',
    () async {
      final a = tile(0);
      final b = tile(1);
      pool.updateVisibility(a, .7);
      pool.updateVisibility(b, .2);
      pool.schedule();
      await flush();
      final session = a.session;
      pool.setScrolling(true);
      pool.updateVisibility(b, .9);
      pool.setScrolling(false);
      await flush();
      expect(pool.current, a);
      expect(a.session, same(session));
      expect(a.isPlaying, true);
      expect(b.isPlaying, false);
    },
  );

  test(
    'changed visibility keeps current session when it remains the largest',
    () async {
      final a = tile(0);
      final b = tile(1);
      pool.updateVisibility(a, .9);
      pool.updateVisibility(b, .3);
      pool.schedule();
      await flush();
      final session = a.session;
      await a.seekTo(const Duration(seconds: 2));
      await a.play();
      pool.setScrolling(true);
      pool.updateVisibility(a, .8);
      pool.setScrolling(false);
      await flush();
      expect(pool.current, a);
      expect(a.session, same(session));
      expect(a.progress.value, const Duration(seconds: 2));
    },
  );

  test('equal visibility selects in index and sub-index order', () async {
    final b = tile(2, sub: 3);
    final a = tile(1, sub: 2);
    final c = tile(1, sub: 0);
    for (final t in [b, a, c]) {
      pool.updateVisibility(t, .2);
    }
    pool.schedule();
    await flush();
    expect(pool.current, c);
  });

  test(
    'same note completes in sub-index order, skips images, stops one round',
    () async {
      final items = [
        tile(0),
        tile(0, sub: 2),
        tile(0, sub: 3),
        tile(0, sub: 5),
      ];
      for (final t in items) {
        pool.updateVisibility(t, 1);
      }
      pool.schedule();
      await flush();
      for (final t in items) {
        expect(pool.current, t);
        (t.session!.player as FakePlayback).finish();
        await flush();
      }
      pool.schedule();
      await flush();
      expect(players.where((p) => p.playing), isEmpty);
      expect(pool.events.any((e) => e.startsWith('NOTE FINISHED')), isTrue);
    },
  );

  test(
    'completion of repeated URL restarts the same session for next grid slot',
    () async {
      final a = tile(0, url: 'same');
      final b = tile(0, sub: 1, url: 'same');
      pool.updateVisibility(a, 1);
      pool.updateVisibility(b, 1);
      await a.play();
      final session = a.session;
      (session!.player as FakePlayback).finish();
      await flush();
      expect(pool.current, b);
      expect(b.session, same(session));
      expect(b.session!.player.position, Duration.zero);
      expect(b.isPlaying, isTrue);
    },
  );

  test(
    'manual pause survives offscreen and reentry, play explicitly resumes',
    () async {
      final a = tile(0);
      pool.updateVisibility(a, 1);
      await a.play();
      await a.pause();
      pool.updateVisibility(a, 0);
      pool.schedule();
      await flush();
      pool.updateVisibility(a, 1);
      pool.schedule();
      await flush();
      expect(a.isPlaying, isFalse);
      await a.play();
      expect(a.isPlaying, isTrue);
    },
  );

  test(
    'noncurrent seek and speed select the target without starting it',
    () async {
      final a = tile(0);
      final b = tile(1);
      await a.play();
      await b.seekTo(const Duration(seconds: 4));
      expect(pool.current, b);
      expect(a.session!.player.playing, isFalse);
      expect(b.isPlaying, isFalse);
      expect(b.session!.player.position.inSeconds, 4);
      await b.setPlaybackSpeed(1.5);
      expect(b.playbackSpeed, 1.5);
      await b.play();
      await b.setPlaybackSpeed(2);
      expect(b.isPlaying, isTrue);
    },
  );

  test('thumbnail is shared by URL and survives decoder eviction', () async {
    await pool.shutdown();
    final image = MemoryImage(Uint8List.fromList([1, 2, 3]));
    pool = VideoPool(
      maxSessions: 1,
      initialScope: 'A',
      factory: (_) => _ThumbnailPlayback(Future.value(image)),
    );
    final first = tile(0);
    final duplicate = tile(1, url: first.url);
    await first.play();
    await flush();
    expect(first.thumbnail, same(image));
    expect(duplicate.thumbnail, same(image));
    await tile(2).play();
    expect(first.session, isNull);
    expect(first.thumbnail, same(image));
  });

  test(
    'late thumbnail after shutdown cannot publish or notify disposed tiles',
    () async {
      await pool.shutdown();
      final gate = Completer<ImageProvider<Object>?>();
      pool = VideoPool(
        initialScope: 'A',
        factory: (_) => _ThumbnailPlayback(gate.future),
      );
      final first = tile(0);
      await first.play();
      await pool.shutdown();
      gate.complete(MemoryImage(Uint8List.fromList([1])));
      await Future<void>.delayed(Duration.zero);
      expect(first.thumbnail, isNull);
    },
  );

  test('prepares next without playing and reuses it when selected', () async {
    final first = tile(0);
    final next = tile(1);
    pool.updateVisibility(first, 1);
    pool.schedule();
    await flush();
    expect(first.isPlaying, isTrue);
    expect(players.length, 2);
    expect(players.last.initialized, isTrue);
    expect(players.last.playing, isFalse);
    final prepared = players.last;
    await next.play();
    expect(players.length, 2);
    expect(next.session!.player, same(prepared));
    expect(prepared.playing, isTrue);
    expect(players.first.playing, isFalse);
  });

  test('four-session pool remains bounded with one player active', () async {
    await pool.shutdown();
    pool = VideoPool(
      maxSessions: 4,
      initialScope: 'A',
      factory: (_) {
        final p = FakePlayback();
        players.add(p);
        return p;
      },
    );
    final items = [for (var i = 0; i < 7; i++) tile(i)];
    for (final item in items) {
      await item.play();
      expect(pool.liveCount, lessThanOrEqualTo(4));
      expect(players.where((p) => !p.released && p.playing).length, 1);
    }
    expect(players.where((p) => !p.released).length, 4);
  });

  test(
    'capacity waits for disposal before creating the fourth session',
    () async {
      final items = [for (var i = 0; i < 5; i++) tile(i)];
      for (final t in items.take(3)) {
        await t.play();
      }
      final gate = Completer<void>();
      players.first.disposal = gate;
      final request = items[3].play();
      await Future<void>.delayed(Duration.zero);
      expect(pool.liveCount, 3);
      expect(players.length, 3);
      gate.complete();
      await request;
      expect(pool.liveCount, 3);
      expect(players.first.released, isTrue);
      await items[4].play();
      expect(pool.liveCount, 3);
    },
  );

  test('unregister during initialization prevents late autoplay', () async {
    final gate = Completer<void>();
    await pool.shutdown();
    pool = VideoPool(
      initialScope: 'A',
      factory: (_) {
        final p = FakePlayback()..initialization = gate;
        players.add(p);
        return p;
      },
    );
    final a = tile(0);
    final request = a.play();
    await Future<void>.delayed(Duration.zero);
    pool.unregister(a);
    gate.complete();
    await request;
    await pool.settled;
    expect(players.single.playing, isFalse);
    expect(pool.current, isNull);
  });

  test(
    'preview reuses session, progress and speed and keeps manual paging',
    () async {
      final a = tile(0);
      final b = tile(0, sub: 1);
      pool.updateVisibility(a, 1);
      pool.updateVisibility(b, 1);
      await a.play();
      await a.seekTo(const Duration(seconds: 4));
      await a.setPlaybackSpeed(1.5);
      final session = a.session;
      await pool.openPreview(a);
      expect(pool.previewSession, same(session));
      expect(a.isCurrent, isFalse);
      expect(session!.player.position.inSeconds, 4);
      expect(session.player.speed, 1.5);
      (session.player as FakePlayback).finish();
      await flush();
      expect(pool.previewUrl, a.url);
      await pool.previewSelect(b.url);
      await pool.closePreview();
      expect(pool.current, b);
      expect(b.isPlaying, isTrue);
    },
  );

  test(
    'source can unmount while preview continues and closes safely',
    () async {
      final a = tile(0);
      await a.play();
      await pool.openPreview(a);
      final session = pool.previewSession;
      pool.unregister(a);
      expect(pool.previewSession, same(session));
      await pool.closePreview();
      expect(pool.current, isNull);
      expect(session!.player.playing, isFalse);
    },
  );

  test(
    'background, scope switch and fast scroll prevent automatic playback',
    () async {
      final a = tile(0);
      pool.updateVisibility(a, 1);
      pool.setScrolling(true);
      pool.schedule();
      await flush();
      expect(players, isEmpty);
      pool.setScrolling(false);
      await a.play();
      pool.setForeground(false);
      await pool.settled;
      expect(a.isPlaying, isFalse);
      pool.setForeground(true);
      pool.setScope('B');
      await flush();
      expect(a.session!.player.playing, isFalse);
    },
  );

  test('oversized tile visibility uses the viewport as the denominator', () {
    expect(visibleFraction(400, 800, 400), 1);
    expect(visibleFraction(0, 0, 400), 0);
  });

  test(
    'scrolling defers all auto creation, but explicit controls still work',
    () async {
      final a = tile(0);
      final b = tile(1);
      pool.updateVisibility(a, 1);
      pool.updateVisibility(b, 1);
      pool.setScrolling(true);
      for (var i = 0; i < 10; i++) {
        pool.updateVisibility(a, i.isEven ? .7 : .9);
        pool.schedule();
        await flush();
      }
      expect(players, isEmpty);
      await b.play();
      expect(b.isPlaying, isTrue);
      pool.updateVisibility(b, 0);
      pool.schedule();
      await flush();
      expect(b.session!.player.playing, isFalse);
      expect(players.length, 1);
      pool.setScrolling(false);
      await flush();
      expect(pool.current, a);
      expect(a.isPlaying, isTrue);
    },
  );

  test('completion while scrolling waits before advancing the grid', () async {
    final a = tile(0);
    final b = tile(0, sub: 1);
    pool.updateVisibility(a, 1);
    pool.updateVisibility(b, 1);
    await a.play();
    pool.setScrolling(true);
    (a.session!.player as FakePlayback).finish();
    await flush();
    expect(b.session, isNull);
    pool.setScrolling(false);
    await flush();
    expect(pool.current, b);
    expect(b.isPlaying, isTrue);
  });

  test(
    'scroll starts during auto initialization invalidates late playback',
    () async {
      final gate = Completer<void>();
      await pool.shutdown();
      pool = VideoPool(
        initialScope: 'A',
        dwell: Duration.zero,
        factory: (_) {
          final p = FakePlayback()..initialization = gate;
          players.add(p);
          return p;
        },
      );
      final a = tile(0);
      pool.updateVisibility(a, 1);
      pool.schedule();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(players.length, 1);
      pool.setScrolling(true);
      gate.complete();
      await flush();
      expect(players.single.playing, isFalse);
      expect(pool.current, isNull);
      pool.setScrolling(false);
      await flush();
      expect(pool.current, a);
      expect(players.single.playing, isTrue);
    },
  );

  test(
    'global speed applies to all videos and future registrations without switching target',
    () async {
      final a = tile(0);
      final b = tile(1);
      await a.play();
      await a.setPlaybackSpeed(1.5);
      await b.play();
      await a.setGlobalPlaybackSpeed(2);
      expect(pool.current, b);
      expect(b.isPlaying, isTrue);
      expect(a.playbackSpeed, 2);
      expect(b.playbackSpeed, 2);
      expect(players.every((p) => p.speed == 2), isTrue);
      final c = tile(2);
      expect(c.playbackSpeed, 2);
      await c.play();
      expect(c.session!.player.speed, 2);
      await c.setPlaybackSpeed(.75);
      expect(c.isPlaying, isTrue);
      expect(c.playbackSpeed, .75);
      expect(a.playbackSpeed, 2);
      expect(pool.globalPlaybackSpeed, 2);
      await pool.setGlobalPlaybackSpeed(1.25);
      expect(c.playbackSpeed, 1.25);
    },
  );

  test('invalid speed is rejected before acquiring or switching a session', () {
    final a = tile(0);
    expect(() => a.setPlaybackSpeed(0), throwsArgumentError);
    expect(() => pool.setGlobalPlaybackSpeed(double.nan), throwsArgumentError);
    expect(pool.current, isNull);
    expect(players, isEmpty);
  });

  test('duplicate URL tiles retain independent progress and speed', () async {
    final a = tile(0, url: 'same');
    final b = tile(1, url: 'same');
    await a.play();
    await a.seekTo(const Duration(seconds: 5));
    await a.setPlaybackSpeed(1.5);
    expect(a.progress.value.inSeconds, 5);
    expect(b.progress.value, Duration.zero);
    expect(b.playbackSpeed, 1);
    final shared = a.session;
    await b.play();
    expect(b.session, same(shared));
    expect(b.session!.player.position, Duration.zero);
    expect(a.progress.value.inSeconds, 5);
    await b.seekTo(const Duration(seconds: 2));
    await b.setPlaybackSpeed(2);
    expect(a.progress.value.inSeconds, 5);
    expect(a.playbackSpeed, 1.5);
    await a.play();
    expect(a.session!.player.position.inSeconds, 5);
    expect(a.session!.player.speed, 1.5);
    expect(b.progress.value.inSeconds, 2);
  });

  test(
    'preview return preserves the attachment index for duplicate URLs',
    () async {
      final a = tile(0, url: 'same');
      final b = tile(0, sub: 3, url: 'same');
      pool.updateVisibility(a, 1);
      pool.updateVisibility(b, 1);
      await b.play();
      await pool.openPreview(b);
      await pool.closePreview();
      expect(pool.current, b);
      await pool.openPreview(b);
      await pool.previewSelect('same', listSubIndex: 0);
      await pool.closePreview();
      expect(pool.current, a);
    },
  );
}

class _ThumbnailPlayback extends FakePlayback {
  _ThumbnailPlayback(this.result);
  final Future<ImageProvider<Object>?> result;
  @override
  Future<ImageProvider<Object>?> captureThumbnail() => result;
}
