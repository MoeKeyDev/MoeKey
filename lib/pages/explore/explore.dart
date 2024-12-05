import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/explore/hot.dart';
import 'package:moekey/pages/explore/users.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';

import '../../generated/l10n.dart';

class ExplorePage extends HookConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var tabs = [
      Tab(
        child: Row(
          children: [
            const Icon(
              TablerIcons.bolt,
              size: 14,
            ),
            Text(S.current.exploreHot, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      Tab(
        child: Row(
          children: [
            const Icon(TablerIcons.users, size: 14),
            Text(S.current.exploreUsers, style: const TextStyle(fontSize: 12)),
          ],
        ),
      )
    ];

    var tabController = useTabController(initialLength: tabs.length);

    var currentIndex = useState(0);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
    });
    return MkTabBarRefreshScroll(
      items: [
        MkTabBarItem(
          label: Tab(
            child: Row(
              children: [
                const Icon(
                  TablerIcons.bolt,
                  size: 14,
                ),
                Text(S.current.exploreHot,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          child: const ExploreHotPage(),
        ),
        MkTabBarItem(
          label: Tab(
            child: Row(
              children: [
                const Icon(TablerIcons.users, size: 14),
                Text(S.current.exploreUsers,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          child: const ExploreUsersPage(),
        )
      ],
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(TablerIcons.hash, color: themes.fgColor, size: 18),
            const SizedBox(width: 4),
            Text(
              S.current.explore,
            )
          ],
        ),
      ),
      trailing: const SizedBox(
        width: 100,
      ),
    );
  }
}
