import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/timeline/timeline_list.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';

import '../../status/timeline.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/keep_alive_wrapper.dart';
import '../../widgets/mk_scaffold.dart';
import '../../widgets/notes/note_pagination_list.dart';

final List<Map<String, dynamic>> navItemList = [
  {
    "icon": TablerIcons.home,
    "label": "首页",
    "api": "timeline",
  },
  {
    "icon": TablerIcons.planet,
    "label": "本地",
    "api": "local-timeline",
  },
  {
    "icon": TablerIcons.universe,
    "label": "社交",
    "api": "hybrid-timeline",
  },
  {
    "icon": TablerIcons.whirl,
    "label": "全局",
    "api": "global-timeline",
  },
];

class TimelinePage extends HookConsumerWidget {
  const TimelinePage({super.key, this.mkTabBarListKey});

  final GlobalKey<MkTabBarListState>? mkTabBarListKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex = useState(0);
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = getPaddingForNote(constraints);
        return MkTabBarList(
          key: mkTabBarListKey,
          padding: EdgeInsets.symmetric(horizontal: padding),
          items: [
            for (var (index, element) in navItemList.indexed)
              MkTabBarItem(
                label: TabItem(
                  icon: element["icon"],
                  label: element["label"],
                  id: index,
                  current: currentIndex.value,
                ),
                slivers: [
                  SliverPaginationNoteList(
                    watch: (ref) =>
                        ref.watch(timelineProvider(api: element["api"])),
                    loadMore: (ref) => ref
                        .read(timelineProvider(api: element["api"]).notifier)
                        .load(),
                  )
                ],
                onRefresh: () async {
                  await ref
                      .read(timelineProvider(api: element["api"]).notifier)
                      .cleanCache();
                  return await ref
                      .refresh(timelineProvider(api: element["api"]).future);
                },
              )
          ],
          onIndexUpdate: (index) {
            currentIndex.value = index;
          },
        );
      },
    );
  }
}

class TabItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final int id;
  final int current;

  const TabItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.id,
      required this.current});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Tab(
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color:
                current == id ? themes.fgColor : themes.fgColor.withAlpha(179),
          ),
          const SizedBox(
            width: 4,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Text(
              current == id ? label : "",
              style: TextStyle(
                  fontSize: 12,
                  color:
                      0 == id ? themes.fgColor : themes.fgColor.withAlpha(179)),
            ),
          )
        ],
      ),
    );
  }
}
