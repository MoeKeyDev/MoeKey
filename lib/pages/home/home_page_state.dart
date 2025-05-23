import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:moekey/status/mk_tabbar_refresh_scroll_state.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../router/router.dart';

part 'home_page_state.g.dart';

@Riverpod(keepAlive: true)
class HomePageState extends _$HomePageState {
  @override
  HomeState build() {
    return HomeState();
  }

  changePage(String id) {
    for (var element in state.navItemList) {
      if (element["id"] != null) {
        if (id == element["id"]) {
          var currPath = ref.read(routerProvider).state.name;
          if (element['id'] == currPath) {
            if (element.containsKey("onTop")) {
              element["onTop"](
                  key: ref.read(mkTabBarRefreshScrollStatusProvider(id)));
            }
          } else {
            var router = ref.watch(routerProvider);
            router.goNamed(element["id"]!);
          }
        }
      }
    }
  }
}

class HomeState {
  final List<Map<String, dynamic>> navItemList = [
    {
      "icon": TablerIcons.home,
      "label": S.current.timeline,
      "id": "timeline",
      "onTop": ({Key? key}) => {
            (key as GlobalKey<MkTabBarRefreshScrollState>)
                .currentState
                ?.refresh()
          }
    },
    {
      "icon": TablerIcons.bell,
      "label": S.current.notifications,
      "id": "notifications",
      "onTop": ({Key? key}) => {
            (key as GlobalKey<MkTabBarRefreshScrollState>)
                .currentState
                ?.refresh()
          }
    },
    {
      "icon": TablerIcons.paperclip,
      "label": S.current.clips,
      "id": "clips",
    },
    {
      "icon": TablerIcons.cloud,
      "label": S.current.drive,
      "id": "drives",
    },
    {"line": true},
    {
      "icon": TablerIcons.hash,
      "label": S.current.explore,
      "id": "explore",
    },
    {
      "icon": TablerIcons.speakerphone,
      "label": S.current.announcements,
      "id": "announcements",
    },
    {
      "icon": TablerIcons.search,
      "label": S.current.search,
      "id": "search",
    },
    {"line": true},
    {
      "icon": TablerIcons.grid_dots,
      "label": S.current.more,
      "id": "more",
    },
  ];
}
