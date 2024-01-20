import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey/pages/timeline/timeline_list.dart';
import 'package:misskey/state/themes.dart';
import 'package:misskey/widgets/mk_header.dart';

import '../../widgets/keep_alive_wrapper.dart';
import '../../widgets/mk_scaffold.dart';

final List<Map<String, dynamic>> navItemList = [
  {
    "icon": TablerIcons.home,
    "label": "首页",
    "id": "timeline",
    "page": () => const TimeLineListPage(api: "timeline")
  },
  {
    "icon": TablerIcons.planet,
    "label": "本地",
    "id": "local",
    "page": () => const TimeLineListPage(api: "local-timeline")
  },
  {
    "icon": TablerIcons.universe,
    "label": "社交",
    "id": "hybrid",
    "page": () => const TimeLineListPage(api: "hybrid-timeline")
  },
  {
    "icon": TablerIcons.whirl,
    "label": "全局",
    "id": "global",
    "page": () => const TimeLineListPage(api: "global-timeline")
  },
];

class TimelinePage extends HookConsumerWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pageController = usePageController();
    var tabController = useTabController(initialLength: navItemList.length);
    var themes = ref.watch(themeColorsProvider);
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
              currentIndex.value = value;
              pageController.animateToPage(value,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn);
            },
          );
        }),
      ),
      body: PageView.builder(
        itemBuilder: (context, index) {
          return KeepAliveWrapper(child: navItemList[index]["page"]());
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
