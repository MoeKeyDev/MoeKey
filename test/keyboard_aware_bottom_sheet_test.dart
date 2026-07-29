import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/keyboard_aware_bottom_sheet.dart';

void main() {
  testWidgets('lays out a sheet above an existing keyboard inset', (
    tester,
  ) async {
    final childKey = GlobalKey();

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(viewInsets: EdgeInsets.only(bottom: 200)),
          child: SizedBox(
            width: 400,
            height: 600,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: KeyboardAwareBottomSheet(
                child: SizedBox(key: childKey, width: 400, height: 600),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(childKey)).height, 400);
    expect(tester.getTopLeft(find.byKey(childKey)).dy, 0);
  });
}
