import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/debug/scrollview_observer_timeline_poc.dart';

void main() {
  List<ScrollObserverPocItem> initialItems() => List.generate(
    40,
    (index) => ScrollObserverPocItem(
      id: 'note-$index',
      height: 72.0 + (index % 4) * 28.0,
    ),
  );

  testWidgets(
    'keeps one visible item anchored across prepend and height changes above it',
    (tester) async {
      final key = GlobalKey<ScrollviewObserverTimelinePocState>();
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollviewObserverTimelinePoc(
              key: key,
              controller: scrollController,
              initialItems: initialItems(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      scrollController.jumpTo(900);
      await tester.pumpAndSettle();

      final anchorId = key.currentState!.firstVisibleItemId;
      expect(anchorId, isNotNull);
      final anchorFinder = find.byKey(ValueKey('poc-note-$anchorId'));
      expect(anchorFinder, findsOneWidget);
      final initialAnchorY = tester.getTopLeft(anchorFinder).dy;

      await key.currentState!.prepend(const [
        ScrollObserverPocItem(id: 'new-2', height: 90),
        ScrollObserverPocItem(id: 'new-1', height: 145),
        ScrollObserverPocItem(id: 'new-0', height: 210),
      ]);
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(anchorFinder).dy, closeTo(initialAnchorY, 0.01));

      await key.currentState!.resizeItem('new-2', 260);
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(anchorFinder).dy, closeTo(initialAnchorY, 0.01));

      await key.currentState!.resizeItem('new-2', 60);
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(anchorFinder).dy, closeTo(initialAnchorY, 0.01));
    },
  );
}
