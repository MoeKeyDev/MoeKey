import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/clips/clips_collection.dart';
import 'package:moekey/pages/clips/clips_my.dart';
import 'package:moekey/widgets/clips/clips_create_dialog.dart';
import 'package:moekey/widgets/mk_modal.dart';

import '../../router/main_router_delegate.dart';
import '../../state/themes.dart';
import '../../widgets/keep_alive_wrapper.dart';
import '../../widgets/mk_header.dart';
import '../../widgets/mk_scaffold.dart';

class ClipsPage extends HookConsumerWidget {
  const ClipsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);

    var tabs = const [
      Tab(
        child: Row(
          children: [
            Icon(
              TablerIcons.paperclip,
              size: 14,
            ),
            Text("我的便签", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      Tab(
        child: Row(
          children: [
            Icon(TablerIcons.heart, size: 14),
            Text("收藏", style: TextStyle(fontSize: 12)),
          ],
        ),
      )
    ];

    var tabController = useTabController(initialLength: tabs.length);

    var currentIndex = useState(0);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
    });
    return LayoutBuilder(builder: (context, constraints) {
      var isPhone = constraints.maxWidth < 500;
      return MkScaffold(
        header: MkAppbar(
          isSmallLeadingCenter: isPhone,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  TablerIcons.paperclip,
                  size: 18,
                  color: themes.fgColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text("便签"),
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
                    showModel(
                      context: context,
                      builder: (context) {
                        return const ClipCreateDialog();
                      },
                    );
                  },
                  tooltip: "添加",
                  icon: const Icon(TablerIcons.plus, size: 18),
                  color: themes.fgColor,
                )
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
                  children: const [
                    KeepAliveWrapper(
                      child: ClipsMy(),
                    ),
                    KeepAliveWrapper(
                      child: ClipsCollection(),
                    )
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
