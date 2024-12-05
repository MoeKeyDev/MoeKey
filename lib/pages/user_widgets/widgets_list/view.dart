import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';

import '../../../generated/l10n.dart';

class WidgetsListPage extends ConsumerWidget {
  const WidgetsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themeColorsProvider);
    return SizedBox(
      width: 350,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [Text(S.current.userWidgetUnSupport)],
          ),
        ),
      ),
    );
  }
}
