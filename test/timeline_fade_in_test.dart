import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/notes/timeline_fade_in.dart';
import 'package:moekey/widgets/notes/timeline_insert_transition.dart';

void main() {
  testWidgets('TimelineFadeIn changes paint but keeps its final height', (
    tester,
  ) async {
    const childKey = ValueKey('fade-child');

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: TimelineFadeIn(
            duration: Duration(milliseconds: 200),
            child: SizedBox(key: childKey, width: 100, height: 180),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(childKey)).height, 180);
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0);

    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.getSize(find.byKey(childKey)).height, 180);
    expect(
      tester.widget<Opacity>(find.byType(Opacity)).opacity,
      closeTo(0.5, 0.01),
    );

    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.getSize(find.byKey(childKey)).height, 180);
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });

  testWidgets('TimelineInsertTransition expands visible inserted content', (
    tester,
  ) async {
    const transitionKey = ValueKey('insert-transition');
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          height: 300,
          child: ListView(
            children: const [
              TimelineInsertTransition(
                key: transitionKey,
                animate: true,
                child: SizedBox(width: 100, height: 100),
              ),
            ],
          ),
        ),
      ),
    );

    final transition = find.byKey(transitionKey, skipOffstage: false);
    final fade = find.byType(FadeTransition, skipOffstage: false);
    expect(tester.getSize(transition).height, 0);
    expect(tester.widget<FadeTransition>(fade).opacity.value, 0);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 160));
    // easeOutCubic covers most of the distance in the first half, then eases
    // gently into the final height.
    expect(tester.getSize(transition).height, inExclusiveRange(70, 100));
    expect(
      tester.widget<FadeTransition>(fade).opacity.value,
      inExclusiveRange(0, 1),
    );

    await tester.pump(const Duration(milliseconds: 160));
    expect(tester.getSize(transition).height, 100);
    expect(tester.widget<FadeTransition>(fade).opacity.value, 1);
  });
}
