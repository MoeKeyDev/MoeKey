import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/widgets/mk_modal.dart';
import 'package:moekey/widgets/user_select_dialog/user_select_dialog.dart';
import 'package:moekey/widgets/user_select_dialog/user_select_dialog_state.dart';

class _Harness extends StatefulWidget {
  const _Harness({super.key});

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  List<UserFullModel>? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        key: const ValueKey('open-user-select'),
        onPressed: () async {
          result = await showModel<List<UserFullModel>>(
            context: context,
            builder: (_) => const UserSelectDialog(),
          );
          if (mounted) setState(() {});
        },
        child: const Text('open'),
      ),
    );
  }
}

void main() {
  testWidgets('user selector returns a typed list', (tester) async {
    final key = GlobalKey<_HarnessState>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSelectDialogStateProvider.overrideWithBuild(
            (_, _) async => <UserFullModel>[],
          ),
        ],
        child: MaterialApp(
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: _Harness(key: key),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-user-select')));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(TablerIcons.check));
    await tester.pumpAndSettle();

    expect(key.currentState!.result, isA<List<UserFullModel>>());
    expect(key.currentState!.result, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
