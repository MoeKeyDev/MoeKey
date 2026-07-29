import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/note_create_dialog/mobile_composer_bottom_area.dart';

void main() {
  testWidgets('panel keeps the keyboard height while the keyboard closes', (
    tester,
  ) async {
    final metrics = MobileComposerKeyboardMetrics();

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 300,
        mode: MobileComposerPanel.attachments,
        metrics: metrics,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 300);

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 0,
        mode: MobileComposerPanel.attachments,
        metrics: metrics,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 300);
    expect(find.text('panel'), findsOneWidget);
  });

  testWidgets('hidden panel follows keyboard and safe area heights', (
    tester,
  ) async {
    final metrics = MobileComposerKeyboardMetrics();

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 260,
        mode: MobileComposerPanel.hidden,
        metrics: metrics,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 260);

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 0,
        mode: MobileComposerPanel.hidden,
        metrics: metrics,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 34);
  });

  testWidgets('tracks the latest keyboard height instead of the maximum', (
    tester,
  ) async {
    final metrics = MobileComposerKeyboardMetrics();

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 420,
        mode: MobileComposerPanel.hidden,
        metrics: metrics,
      ),
    );
    await tester.pump(const Duration(milliseconds: 81));
    expect(metrics.lastVisibleHeight, 420);

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 220,
        mode: MobileComposerPanel.hidden,
        metrics: metrics,
      ),
    );
    await tester.pump(const Duration(milliseconds: 81));
    expect(metrics.lastVisibleHeight, 220);
  });

  testWidgets('clears the panel after the replacement keyboard settles', (
    tester,
  ) async {
    final metrics = MobileComposerKeyboardMetrics();
    var didSettle = false;

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 0,
        mode: MobileComposerPanel.emoji,
        metrics: metrics,
        switchingToKeyboard: true,
        onKeyboardSettled: () => didSettle = true,
      ),
    );
    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 300,
        mode: MobileComposerPanel.emoji,
        metrics: metrics,
        switchingToKeyboard: true,
        onKeyboardSettled: () => didSettle = true,
      ),
    );
    await tester.pump(const Duration(milliseconds: 81));

    expect(didSettle, isTrue);
  });

  testWidgets('animates an app panel without an active keyboard', (
    tester,
  ) async {
    final metrics = MobileComposerKeyboardMetrics();

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 0,
        mode: MobileComposerPanel.hidden,
        metrics: metrics,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 34);

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 0,
        mode: MobileComposerPanel.emoji,
        metrics: metrics,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 34);

    await tester.pump(const Duration(milliseconds: 110));
    final transitioningHeight = tester
        .getSize(find.byType(MobileComposerBottomArea))
        .height;
    expect(transitioningHeight, greaterThan(34));
    expect(transitioningHeight, lessThan(300));

    await tester.pump(const Duration(milliseconds: 110));
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 300);
  });

  testWidgets('does not add a tween while replacing the keyboard', (
    tester,
  ) async {
    final metrics = MobileComposerKeyboardMetrics();

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 300,
        mode: MobileComposerPanel.hidden,
        metrics: metrics,
      ),
    );
    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 300,
        mode: MobileComposerPanel.emoji,
        metrics: metrics,
      ),
    );

    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 300);
  });

  testWidgets('follows keyboard progress from maximum to minimum height', (
    tester,
  ) async {
    final metrics = MobileComposerKeyboardMetrics();

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 0,
        mode: MobileComposerPanel.emoji,
        panelHeight: 600,
        metrics: metrics,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 600);

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 0,
        mode: MobileComposerPanel.emoji,
        panelHeight: 220,
        metrics: metrics,
        switchingToKeyboard: true,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 600);

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 110,
        mode: MobileComposerPanel.emoji,
        panelHeight: 220,
        metrics: metrics,
        switchingToKeyboard: true,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 410);

    await tester.pumpWidget(
      _buildArea(
        keyboardInset: 220,
        mode: MobileComposerPanel.emoji,
        panelHeight: 220,
        metrics: metrics,
        switchingToKeyboard: true,
      ),
    );
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 220);
  });

  testWidgets(
    'does not constrain panel flex content during its opening tween',
    (tester) async {
      final metrics = MobileComposerKeyboardMetrics();

      await tester.pumpWidget(
        _buildArea(
          keyboardInset: 0,
          mode: MobileComposerPanel.hidden,
          metrics: metrics,
        ),
      );
      await tester.pumpWidget(
        _buildArea(
          keyboardInset: 0,
          mode: MobileComposerPanel.attachments,
          metrics: metrics,
          child: Column(
            children: const [
              SizedBox(height: 120),
              Spacer(),
              SizedBox(height: 52),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 30));

      expect(tester.takeException(), isNull);
    },
  );
}

Widget _buildArea({
  required double keyboardInset,
  required MobileComposerPanel mode,
  required MobileComposerKeyboardMetrics metrics,
  double panelHeight = 300,
  bool switchingToKeyboard = false,
  VoidCallback? onKeyboardSettled,
  Widget child = const Text('panel'),
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(
        viewInsets: EdgeInsets.only(bottom: keyboardInset),
        viewPadding: const EdgeInsets.only(bottom: 34),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: MobileComposerBottomArea(
          mode: mode,
          panelHeight: panelHeight,
          metrics: metrics,
          switchingToKeyboard: switchingToKeyboard,
          onKeyboardSettled: onKeyboardSettled ?? () {},
          onResize: (_) {},
          onResizeEnd: (_) {},
          child: child,
        ),
      ),
    ),
  );
}
