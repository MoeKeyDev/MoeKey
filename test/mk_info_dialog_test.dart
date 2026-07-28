import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_button.dart';

void main() {
  testWidgets('MK button size remains content driven', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: MkPrimaryButton(
                onPressed: () {},
                child: const Text(
                  'A deliberately long button label that must remain visible',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(ElevatedButton)).width, greaterThan(120));
  });
}
