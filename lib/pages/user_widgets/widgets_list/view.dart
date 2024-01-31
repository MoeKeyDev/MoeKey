import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/state/themes.dart';

class WidgetsListPage extends ConsumerWidget {
  WidgetsListPage({Key? key}) : super(key: key);

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
        child: const SingleChildScrollView(
          child: Column(
            children: [Text("小部件列表(未完成)")],
          ),
        ),
      ),
    );
  }
}
