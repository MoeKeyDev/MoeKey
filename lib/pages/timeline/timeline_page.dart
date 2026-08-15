import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/timeline/timeline_list.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';

import '../../generated/l10n.dart';
import '../../utils/get_padding_note.dart';

final List<Map<String, dynamic>> navItemList = [
  {
    "icon": TablerIcons.home,
    "label": S.current.timelineHome,
    "api": "timeline",
  },
  {
    "icon": TablerIcons.planet,
    "label": S.current.timelineLocal,
    "api": "local-timeline",
  },
  {
    "icon": TablerIcons.universe,
    "label": S.current.timelineHybrid,
    "api": "hybrid-timeline",
  },
  {
    "icon": TablerIcons.whirl,
    "label": S.current.timelineGlobal,
    "api": "global-timeline",
  },
];

class TimelinePage extends HookConsumerWidget {
  const TimelinePage({super.key, this.mkTabBarListKey});

  final GlobalKey<MkTabBarRefreshScrollState>? mkTabBarListKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex = useState(0);
    final pageVisible = TickerMode.valuesOf(context).enabled;
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = getPaddingForNote(constraints);
        return MkTabBarRefreshScroll(
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
                child: TimeLineListPage(
                  api: element['api'],
                  active: pageVisible && currentIndex.value == index,
                ),
              ),
          ],
          onIndexSettled: (index) {
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

  const TabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.id,
    required this.current,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    final controller = MkTabControllerScope.maybeOf(context);

    Widget buildTab(double selectionProgress) {
      final progress = selectionProgress.clamp(0.0, 1.0);
      final inactiveColor = themes.fgColor.withAlpha(179);
      final color = Color.lerp(inactiveColor, themes.fgColor, progress)!;
      return Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            ClipRect(
              child: Align(
                key: ValueKey('timeline-tab-label-$id'),
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Opacity(
                    opacity: progress,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(fontSize: 12, color: color),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final animation = controller?.animation;
    if (animation == null) {
      return buildTab(current == id ? 1 : 0);
    }
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final progress = 1 - (animation.value - id).abs();
        return buildTab(progress);
      },
    );
  }
}
