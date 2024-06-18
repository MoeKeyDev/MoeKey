import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/explore/hot.dart';
import 'package:moekey/pages/explore/users.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../widgets/keep_alive_wrapper.dart';

class ExplorePage extends HookConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var tabs = const [
      Tab(
        child: Row(
          children: [
            Icon(
              TablerIcons.bolt,
              size: 14,
            ),
            Text("热门", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      Tab(
        child: Row(
          children: [
            Icon(TablerIcons.users, size: 14),
            Text("用户", style: TextStyle(fontSize: 12)),
          ],
        ),
      )
    ];

    var tabController = useTabController(initialLength: tabs.length);

    var currentIndex = useState(0);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return MkScaffold(
          body: TabBarView(
            controller: tabController,
            children: const [
              KeepAliveWrapper(child: ExploreHotPage()),
              KeepAliveWrapper(child: ExploreUsersPage()),
            ],
          ),
          header: MkAppbar(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(TablerIcons.hash, color: themes.fgColor, size: 18),
                  const SizedBox(width: 4),
                  const Text(
                    "发现",
                  )
                ],
              ),
            ),
            isSmallLeadingCenter: constraints.maxWidth < 500,
            bottom: MkTabBar(controller: tabController, tabs: tabs),
            trailing: const SizedBox(
              width: 100,
            ),
          ),
        );
      },
    );
  }
}
