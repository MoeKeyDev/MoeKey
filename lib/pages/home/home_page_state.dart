import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:moekey/pages/clips/clips_page.dart';
import 'package:moekey/pages/drive/drive_page.dart';
import 'package:moekey/pages/notifications/notifications_page.dart';
import 'package:moekey/pages/test/test.dart';
import 'package:moekey/pages/timeline/timeline_page.dart';
import 'package:moekey/router/main_router_delegate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../widgets/keep_alive_wrapper.dart';

part 'home_page_state.g.dart';

@riverpod
class HomePageState extends _$HomePageState {
  @override
  HomeState build() {
    return HomeState();
  }

  changePage(String id) {
    for (var element in state.navItemList) {
      if (element["id"] != null) {
        if (id == element["id"]) {
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

  changePageByRouterItem(RouterItem item) {
    ref.read(routerDelegateProvider).setNewRoutePath(item);
  }

  Widget getPage(String id) {
    for (var element in state.navItemList) {
      if (element["id"] != null) {
        if (id == element["id"] && element["page"] != null) {
          return element["page"]();
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

@riverpod
MainRouterDelegate routerDelegate(RouterDelegateRef ref) {
  var state = ref.read(homePageStateProvider);
  return MainRouterDelegate(
    initRouter: RouterItem(
      page: () => KeepAliveWrapper(child: state.navItemList[0]["page"]()),
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
      "page": () => const TimelinePage()
    },
    {
      "icon": TablerIcons.bell,
      "label": S.current.notifications,
      "id": "notifications",
      "page": () => const NotificationsPage()
    },
    {
      "icon": TablerIcons.paperclip,
      "label": S.current.clips,
      "id": "clips",
      "page": () => const ClipsPage()
    },
    {
      "icon": TablerIcons.cloud,
      "label": S.current.drive,
      "id": "drive",
      "page": () => const DrivePage()
    },
    {"line": true},
    {
      "icon": TablerIcons.hash,
      "label": S.current.explore,
      "id": "explore",
      "page": () => const TestWidget()
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
    {
      "icon": TablerIcons.settings,
      "label": S.current.settings,
      "id": "settings",
    },
  ];
}
