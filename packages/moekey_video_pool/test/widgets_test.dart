import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';

import 'support/fake_playback.dart';

void main() {
  VideoPool makePool() =>
      VideoPool(factory: (_) => FakePlayback())..setForeground(false);
  Widget attachment({bool enable = true, int index = 0, int sub = 0}) =>
      VideoFeedView(
        key: const ValueKey('attachment'),
        noteId: 'note',
        listIndex: index,
        listSubIndex: sub,
        url: 'https://test/video.mp4',
        enable: enable,
        builder: (_, video) =>
            const SizedBox(width: double.infinity, height: 200),
      );
  Widget host(VideoPool pool, Widget child) => MaterialApp(
    home: Scaffold(
      body: VideoPoolViewport(pool: pool, child: child),
    ),
  );

  testWidgets(
    'updates enable and position without replacing attachment state',
    (tester) async {
      final pool = makePool();
      await tester.pumpWidget(host(pool, attachment()));
      await tester.pump();
      final video = pool.tiles.single;
      expect(video.visibility, greaterThan(.6));
      await tester.pumpWidget(
        host(pool, attachment(enable: false, index: 7, sub: 3)),
      );
      await tester.pump();
      expect(pool.tiles.single, same(video));
      expect(video.enable, false);
      expect(video.listIndex, 7);
      expect(video.listSubIndex, 3);
      await tester.pumpWidget(host(pool, attachment()));
      await tester.pump();
      expect(video.enable, true);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(pool.tiles, isEmpty);
      expect(video.registered, false);
      await pool.shutdown();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('replacing viewport pool unregisters the old handle', (
    tester,
  ) async {
    final a = makePool();
    final b = makePool();
    await tester.pumpWidget(host(a, attachment()));
    await tester.pump();
    final old = a.tiles.single;
    await tester.pumpWidget(host(b, attachment()));
    await tester.pump();
    expect(a.tiles, isEmpty);
    expect(old.registered, false);
    expect(b.tiles.single.pool, same(b));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await a.shutdown();
    await b.shutdown();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'viewport forwards scrolling and batches actual visibility sampling',
    (tester) async {
      final pool = makePool();
      await tester.pumpWidget(
        host(
          pool,
          ListView(children: [attachment(), const SizedBox(height: 2000)]),
        ),
      );
      await tester.pump();
      final video = pool.tiles.single;
      expect(video.visibility, 1);
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump();
      expect(pool.scrolling, true);
      expect(video.visibility, 0);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 250));
      expect(pool.scrolling, false);
      expect(pool.liveCount, 0);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await pool.shutdown();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('pool can shut down before the feed widgets unmount', (
    tester,
  ) async {
    final pool = makePool();
    await tester.pumpWidget(host(pool, attachment()));
    await tester.pump();
    await pool.shutdown();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'route coverage transfers visibility without replacing shared state',
    (tester) async {
      final pool = makePool();
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: Scaffold(
            body: VideoPoolViewport(pool: pool, child: attachment()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final video = pool.tiles.single;
      expect(video.visibility, 1);
      expect(video.referenceCount, 1);

      navigator.currentState!.push(
        PageRouteBuilder<void>(
          opaque: false,
          pageBuilder: (_, _, _) => Scaffold(
            body: VideoPoolViewport(pool: pool, child: attachment()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(pool.tiles.single, same(video));
      expect(video.referenceCount, 2);
      expect(video.visibility, 1);
      final contexts = tester.elementList(
        find.byType(VideoFeedView, skipOffstage: false),
      );
      // The individual references report different visibility despite sharing state.
      final builders = contexts
          .map(
            (element) => find.descendant(
              of: find.byWidget(element.widget, skipOffstage: false),
              matching: find.byType(Builder, skipOffstage: false),
            ),
          )
          .toList();
      expect(VideoFeedView.isVisibleOf(tester.element(builders.first)), false);
      expect(VideoFeedView.isVisibleOf(tester.element(builders.last)), true);

      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(pool.tiles.single, same(video));
      expect(video.referenceCount, 1);
      expect(video.visibility, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await pool.shutdown();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('covered route reports zero and restores visibility on return', (
    tester,
  ) async {
    final pool = makePool();
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: Scaffold(
          body: VideoPoolViewport(pool: pool, child: attachment()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final video = pool.tiles.single;
    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Other page')),
      ),
    );
    await tester.pumpAndSettle();
    expect(video.visibility, 0);
    expect(video.registered, true);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(video.visibility, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await pool.shutdown();
  });
}
