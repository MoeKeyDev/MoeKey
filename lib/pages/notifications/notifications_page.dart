import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/notifications/notifications_group_list.dart';
import 'package:moekey/widgets/keep_alive_wrapper.dart';
import 'package:moekey/widgets/mk_header.dart';

import '../../router/main_router_delegate.dart';
import '../../status/themes.dart';
import '../../widgets/mk_scaffold.dart';
import 'notifications_mentions_list.dart';

class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);

    var tabController = useTabController(initialLength: 3);
    var currentIndex = useState(0);
    return LayoutBuilder(builder: (context, constraints) {
      var isPhone = constraints.maxWidth < 500;

      var tabs = const [
        Tab(
          child: Row(
            children: [
              Icon(
                TablerIcons.point,
                size: 14,
              ),
              Text("全部", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: [
              Icon(TablerIcons.at, size: 14),
              Text("提到我的", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: [
              Icon(TablerIcons.mail, size: 14),
              Text("私信", style: TextStyle(fontSize: 12)),
            ],
          ),
        )
      ];

      return MkScaffold(
        header: MkAppbar(
          isSmallLeadingCenter: isPhone,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  TablerIcons.bell,
                  size: 18,
                  color: themes.fgColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text("通知"),
              ],
            ),
          ),
          bottom: MkTabBar(controller: tabController, tabs: tabs),
          trailing: Visibility(
            visible: currentIndex.value == 0,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    MainRouterDelegate.of(context).popRoute();
                  },
                  tooltip: "筛选",
                  icon: const Icon(TablerIcons.filter, size: 18),
                  color: themes.fgColor,
                ),
                IconButton(
                  onPressed: () {
                    MainRouterDelegate.of(context).popRoute();
                  },
                  tooltip: "全部标记为已读",
                  icon: const Icon(TablerIcons.check, size: 18),
                  color: themes.fgColor,
                ),
              ],
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                TabBarView(
                  controller: tabController,
                  children: [
                    KeepAliveWrapper(
                      child: NotificationsGroupList(),
                    ),
                    const KeepAliveWrapper(
                      child: MentionsList(),
                    ),
                    const KeepAliveWrapper(
                      child: MentionsList(specified: true),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
