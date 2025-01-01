import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/main.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../generated/l10n.dart';
import '../../status/themes.dart';

class SettingsTwoPanelLayout extends HookConsumerWidget {
  const SettingsTwoPanelLayout({
    super.key,
    required this.leftPanel,
    required this.rightPanel,
  });

  final Widget leftPanel;
  final Widget rightPanel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isWide = WindowSize.of(context)!.isWide;
    var themes = ref.watch(themeColorsProvider);
    var currentId = GoRouter.of(context).state?.name;
    return LayoutBuilder(
      builder: (context, constraints) {
        return MkScaffold(
          header: MkAppbar(
            isSmallLeadingCenter: constraints.maxWidth < 500,
            showBack: !isWide && currentId != 'settings',
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  TablerIcons.settings,
                  size: 18,
                  color: themes.fgColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(S.current.settings),
              ],
            ),
          ),
          body: Row(
            children: [
              if (isWide)
                SizedBox(
                  width: 300,
                  child: leftPanel,
                ),
              Expanded(
                child: rightPanel,
              ),
            ],
          ),
        );
      },
    );
  }
}
