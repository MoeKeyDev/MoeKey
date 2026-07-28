import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/notifications/notifications_group_list.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';

import '../../generated/l10n.dart';
import '../../status/themes.dart';
import 'notifications_mentions_list.dart';
import 'sent_follow_requests_list.dart';

class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({
    super.key,
    this.mkTabBarListKey,
    this.initialIndex = 0,
  });

  final GlobalKey<MkTabBarRefreshScrollState>? mkTabBarListKey;
  final int initialIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var currentIndex = useState(initialIndex);
    return MkTabBarRefreshScroll(
      key: mkTabBarListKey,
      initIndex: initialIndex,
      onIndexUpdate: (index) {
        currentIndex.value = index;
      },
      items: [
        MkTabBarItem(
          label: Tab(
            child: Row(
              children: [
                const Icon(TablerIcons.point, size: 14),
                Text(S.current.notifyAll, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          child: NotificationsGroupList(),
        ),
        MkTabBarItem(
          label: Tab(
            child: Row(
              children: [
                const Icon(TablerIcons.at, size: 14),
                Text(
                  S.current.notifyMention,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          child: const MentionsList(),
        ),
        MkTabBarItem(
          label: Tab(
            child: Row(
              children: [
                const Icon(TablerIcons.mail, size: 14),
                Text(
                  S.current.notifyMessage,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          child: const MentionsList(specified: true),
        ),
        MkTabBarItem(
          label: Tab(
            child: Row(
              children: [
                const Icon(TablerIcons.user, size: 14),
                Text(
                  S.current.followRequestsSent,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          child: const SentFollowRequestsList(),
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(TablerIcons.bell, size: 18, color: themes.fgColor),
            const SizedBox(width: 8),
            Text(S.current.notification),
          ],
        ),
      ),
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
                context.pop();
              },
              tooltip: S.current.notifyFilter,
              icon: const Icon(TablerIcons.filter, size: 18),
              color: themes.fgColor,
            ),
          ],
        ),
      ),
    );
  }
}
