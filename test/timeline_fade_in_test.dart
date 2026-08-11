import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/notes/timeline_fade_in.dart';

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
}
