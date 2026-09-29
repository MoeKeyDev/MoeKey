import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/notes/timeline_insert_transition.dart';

void main() {
  testWidgets('large prepends stay lazy throughout the entrance animation', (
    tester,
  ) async {
    var inserted = 0;
    final built = <int>{};
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Scaffold(
              body: ListView.builder(
                scrollCacheExtent: const ScrollCacheExtent.pixels(0),
                itemCount: inserted + 20,
                itemBuilder: (context, index) {
                  built.add(index);
                  return TimelineInsertTransition(
                    key: ValueKey(index - inserted),
                    animate: index < inserted,
                    child: SizedBox(height: 100, child: Text('Note $index')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    built.clear();
    update(() => inserted = 1000);
    await tester.pump();
    expect(built.length, lessThan(20));
    expect(
      tester.getSize(find.byType(TimelineInsertTransition).first).height,
      100,
    );
    await tester.pump(const Duration(milliseconds: 160));
    expect(built.length, lessThan(20));
    expect(
      tester.getSize(find.byType(TimelineInsertTransition).first).height,
      100,
    );
    await tester.pumpAndSettle();
    expect(built.length, lessThan(20));
    expect(tester.takeException(), isNull);
  });
}
