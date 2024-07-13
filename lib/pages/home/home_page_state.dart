import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:moekey/pages/announcements/announcements.dart';
import 'package:moekey/pages/clips/clips_page.dart';
import 'package:moekey/pages/drive/drive_page.dart';
import 'package:moekey/pages/explore/explore.dart';
import 'package:moekey/pages/notifications/notifications_page.dart';
import 'package:moekey/pages/test/test.dart';
import 'package:moekey/pages/timeline/timeline_page.dart';
import 'package:moekey/router/main_router_delegate.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../widgets/keep_alive_wrapper.dart';

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
          var currPath =
              ref.read(routerDelegateProvider).currentConfiguration?.path;
          if (id == currPath) {
            if (element.containsKey("key") && element.containsKey("onTop")) {
              element["onTop"](key: element["key"]);
            }
          } else {
            ref.read(routerDelegateProvider).setNewRoutePath(RouterItem(
                  path: element["id"],
                  page: () => getPage(id),
                  launchMode: LaunchMode.single,
                  animated: false,
                ));
          }
        }
      }
    }
  }

  changePageByRouterItem(RouterItem item) {
    ref.read(routerDelegateProvider).setNewRoutePath(item);
  }

  Widget getPage(String id) {
    for (var element in state.navItemList) {
      if (element["id"] != null) {
        if (id == element["id"] && element["page"] != null) {
          return element["page"](key: element["key"]);
        }
      }
    }
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          MainRouterDelegate.of(context).popRoute();
        },
        child: const Text("404"),
      );
    });
  }
}

@Riverpod(keepAlive: true)
MainRouterDelegate routerDelegate(RouterDelegateRef ref) {
  var state = ref.read(homePageStateProvider);
  return MainRouterDelegate(
    initRouter: RouterItem(
      page: () => KeepAliveWrapper(
          child:
              state.navItemList[0]["page"](key: state.navItemList[0]["key"])),
      path: 'timeline',
      launchMode: LaunchMode.single,
      animated: false,
    ),
  );
}

class HomeState {
  final List<Map<String, dynamic>> navItemList = [
    {
      "icon": TablerIcons.home,
      "label": S.current.timeline,
      "id": "timeline",
      "page": ({Key? key}) => TimelinePage(
            mkTabBarListKey: key as GlobalKey<MkTabBarRefreshScrollState>,
          ),
      "key": GlobalKey<MkTabBarRefreshScrollState>(),
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
      "page": ({Key? key}) => NotificationsPage(
            mkTabBarListKey: key as GlobalKey<MkTabBarRefreshScrollState>,
          ),
      "key": GlobalKey<MkTabBarRefreshScrollState>(),
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
      "page": ({Key? key}) => const ClipsPage()
    },
    {
      "icon": TablerIcons.cloud,
      "label": S.current.drive,
      "id": "drive",
      "page": ({Key? key}) => const DrivePage()
    },
    {"line": true},
    {
      "icon": TablerIcons.hash,
      "label": S.current.explore,
      "id": "explore",
      "page": ({Key? key}) => const ExplorePage()
    },
    {
      "icon": TablerIcons.speakerphone,
      "label": S.current.announcements,
      "id": "announcements",
      "page": ({Key? key}) => const AnnouncementsPage()
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
    {
      "icon": TablerIcons.settings,
      "label": S.current.settings,
      "id": "settings",
    },
  ];
}
