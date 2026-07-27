// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/widgets/mk_date_picker.dart';

void main() {
  testWidgets('date picker opens with the selected date', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: MkDatePicker(
              value: DateTime(2026, 7, 27),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            ),
          ),
        ),
      ),
    );

    expect(find.text('2026-07-27'), findsOneWidget);

    final pickerGesture = find
        .descendant(
          of: find.byType(MkDatePicker),
          matching: find.byType(GestureDetector),
        )
        .first;
    await tester.tap(pickerGesture);
    await tester.pumpAndSettle();

    expect(find.byType(DatePicker), findsOneWidget);
  });
}
