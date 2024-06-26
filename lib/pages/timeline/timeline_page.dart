import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/timeline/timeline_list.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_header.dart';

import '../../widgets/keep_alive_wrapper.dart';
import '../../widgets/mk_scaffold.dart';

final List<Map<String, dynamic>> navItemList = [
  {
    "icon": TablerIcons.home,
    "label": "首页",
    "id": "timeline",
    "page": (ScrollController controller,
            GlobalKey<RefreshIndicatorState> refreshKey) =>
        TimeLineListPage(
          api: "timeline",
          controller: controller,
          refreshKey: refreshKey,
        ),
    "controller": ScrollController(),
    "refresh": GlobalKey<RefreshIndicatorState>()
  },
  {
    "icon": TablerIcons.planet,
    "label": "本地",
    "id": "local",
    "page": (ScrollController controller,
            GlobalKey<RefreshIndicatorState> refreshKey) =>
        TimeLineListPage(
          api: "local-timeline",
          controller: controller,
          refreshKey: refreshKey,
        ),
    "controller": ScrollController(),
    "refresh": GlobalKey<RefreshIndicatorState>()
  },
  {
    "icon": TablerIcons.universe,
    "label": "社交",
    "id": "hybrid",
    "page": (ScrollController controller,
            GlobalKey<RefreshIndicatorState> refreshKey) =>
        TimeLineListPage(
          api: "hybrid-timeline",
          controller: controller,
          refreshKey: refreshKey,
        ),
    "controller": ScrollController(),
    "refresh": GlobalKey<RefreshIndicatorState>()
  },
  {
    "icon": TablerIcons.whirl,
    "label": "全局",
    "id": "global",
    "page": (ScrollController controller,
            GlobalKey<RefreshIndicatorState> refreshKey) =>
        TimeLineListPage(
          api: "global-timeline",
          controller: controller,
          refreshKey: refreshKey,
        ),
    "controller": ScrollController(),
    "refresh": GlobalKey<RefreshIndicatorState>()
  },
];

class TimelinePage extends HookConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pageController = usePageController();
    var tabController = useTabController(initialLength: navItemList.length);
    var currentIndex = useState(0);
    return MkScaffold(
      header: MkAppbar(
        content: Builder(builder: (context) {
          var list = <Widget>[];
          for (var (index, element) in navItemList.indexed) {
            list.add(TabItem(
              icon: element["icon"],
              label: element["label"],
              id: index,
              current: currentIndex.value,
            ));
          }
          return MkTabBar(
            controller: tabController,
            tabs: list,
            tabAlignment: TabAlignment.center,
            onTap: (value) {
              var lastIndex = currentIndex.value;
              currentIndex.value = value;
              ScrollController controller = navItemList[value]["controller"];
              GlobalKey<RefreshIndicatorState> refreshKey =
                  navItemList[value]["refresh"];
              if (controller.hasClients && lastIndex == value) {
                if (controller.offset > 0) {
                  controller.animateTo(0,
                      duration: Duration(
                          milliseconds:
                              (controller.offset).toInt().clamp(100, 1000)),
                      curve: Curves.easeInOut);
                } else {
                  refreshKey.currentState?.show();
                }
              }
              pageController.animateToPage(value,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn);
            },
          );
        }),
      ),
      body: PageView.builder(
        itemBuilder: (context, index) {
          return KeepAliveWrapper(
            child: navItemList[index]["page"](
              navItemList[index]["controller"],
              navItemList[index]["refresh"],
            ),
          );
        },
        controller: pageController,
        itemCount: navItemList.length,
        onPageChanged: (index) {
          currentIndex.value = index;
          tabController.animateTo(index);
        },
      ),
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
