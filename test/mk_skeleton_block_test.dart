import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_skeleton_block.dart';

void main() {
  testWidgets('uses the requested size and fractional width', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 200,
            child: MkSkeletonBlock(
              color: Colors.grey,
              height: 12,
              widthFactor: 0.5,
              animated: false,
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(DecoratedBox)), const Size(100, 12));
  });

  testWidgets('supports circular placeholder blocks', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MkSkeletonBlock(
          color: Colors.grey,
          width: 40,
          height: 40,
          shape: BoxShape.circle,
          animated: false,
        ),
      ),
    );

    final decoration =
        tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration
            as BoxDecoration;
    expect(decoration.shape, BoxShape.circle);
    expect(decoration.borderRadius, isNull);
  });

  testWidgets('defaults to the Misskey theme foreground placeholder color', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MkSkeletonBlock(width: 40, height: 10, animated: false),
        ),
      ),
    );

    final decoration =
        tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration
            as BoxDecoration;
    expect(decoration.color, ThemeColorModel().fgColor.withValues(alpha: 0.1));
  });

  testWidgets('shows a wave animation by default', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: MkSkeletonBlock(width: 100, height: 12)),
      ),
    );

    final wave = find.descendant(
      of: find.byType(MkSkeletonBlock),
      matching: find.byType(CustomPaint),
    );
    expect(wave, findsOneWidget);
    final firstProgress =
        ((tester.widget<CustomPaint>(wave).painter as dynamic).animation.value
            as double);
    await tester.pump(const Duration(milliseconds: 700));
    expect(wave, findsOneWidget);
    final secondProgress =
        ((tester.widget<CustomPaint>(wave).painter as dynamic).animation.value
            as double);
    expect(secondProgress, isNot(firstProgress));
  });

  testWidgets('respects the system reduced-motion preference', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: MkSkeletonBlock(width: 100, height: 12),
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(MkSkeletonBlock),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
  });
}
