import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/widgets/mk_button.dart';
import 'package:moekey/widgets/mk_info_dialog.dart';

Future<List<Size>> _pumpConfirm(
  WidgetTester tester,
  TargetPlatform platform,
) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        locale: const Locale('zh', 'CN'),
        theme: ThemeData(platform: platform, useMaterial3: true),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(body: MkConfirm(children: [Text('确认内容')])),
      ),
    ),
  );

  return tester
      .widgetList<ElevatedButton>(find.byType(ElevatedButton))
      .map((button) => tester.getSize(find.byWidget(button)))
      .toList();
}

void main() {
  testWidgets(
    'confirm actions have the same visual size on mobile and desktop',
    (tester) async {
      final mobileSizes = await _pumpConfirm(tester, TargetPlatform.android);
      final desktopSizes = await _pumpConfirm(tester, TargetPlatform.macOS);

      expect(desktopSizes, mobileSizes);
    },
  );

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
