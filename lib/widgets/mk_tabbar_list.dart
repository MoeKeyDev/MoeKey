import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';
import 'keep_alive_wrapper.dart';
import 'loading_weight.dart';
import 'mk_header.dart';
import 'mk_refresh_indicator.dart';
import 'mk_scaffold.dart';

class MkTabBarItem {
  Widget label;
  List<Widget> slivers;
  final Future<void> Function() onRefresh;

  MkTabBarItem(
      {required this.label, required this.slivers, required this.onRefresh});
}

class MkTabBarList extends StatefulWidget {
  const MkTabBarList(
      {super.key,
      required this.items,
      this.leading,
      this.trailing,
      this.content,
      this.bottom,
      this.showBack = false,
      this.onIndexUpdate,
      this.initIndex = 0,
      this.padding = EdgeInsets.zero});

  final List<MkTabBarItem> items;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final PreferredSizeWidget? bottom;
  final bool showBack;
  final int initIndex;
  final EdgeInsetsGeometry padding;
  final void Function(int)? onIndexUpdate;

  @override
  State<MkTabBarList> createState() => MkTabBarListState();
}

class MkTabBarListState extends State<MkTabBarList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<GlobalKey<RefreshIndicatorState>> refreshKeys;
  late List<ScrollController> scrollControllers;
  int lastIndex = 0;

  @override
  void initState() {
    lastIndex = widget.initIndex;
    super.initState();
    tabController = TabController(
        length: widget.items.length,
        vsync: this,
        initialIndex: widget.initIndex);

    tabController.addListener(() {
      if (widget.onIndexUpdate != null) {
        widget.onIndexUpdate!(tabController.index);
      }
      if (!tabController.indexIsChanging) {
        lastIndex = tabController.index;
      }
    });
    refreshKeys =
        List.from(widget.items.map((_) => GlobalKey<RefreshIndicatorState>()));
    scrollControllers = List.from(widget.items.map((_) => ScrollController()));
  }

  @override
  void didUpdateWidget(MkTabBarList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MkScaffold(
          body: TabBarView(
            controller: tabController,
            children: [
              for (var (index, item) in widget.items.indexed)
                KeepAliveWrapper(
                  child: MkRefreshIndicator(
                    refreshKey: refreshKeys[index],
                    onRefresh: item.onRefresh,
                    child: Builder(
                      builder: (context) {
                        var mediaPadding = MediaQuery.paddingOf(context);
                        return CustomScrollView(
                          controller: scrollControllers[index],
                          cacheExtent: (Platform.isAndroid || Platform.isIOS)
                              ? 1000
                              : 4000,
                          // controller: scrollController,
                          slivers: [
                            SliverPadding(
                              padding: mediaPadding.add(widget.padding),
                              sliver: SliverMainAxisGroup(
                                slivers: item.slivers,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          header: MkAppbar(
            leading: widget.leading,
            isSmallLeadingCenter: widget.leading != null ||
                    widget.trailing != null ||
                    widget.content != null ||
                    widget.showBack == true
                ? constraints.maxWidth < 500
                : false,
            bottom: MkTabBar(
                controller: tabController,
                tabAlignment: TabAlignment.center,
                onTap: (value) {
                  var controller = scrollControllers[value];
                  var refreshKey = refreshKeys[value];
                  if (!controller.hasClients) return;

                  if (lastIndex == value) {
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
                  lastIndex = value;
                },
                tabs: widget.items.map((e) => e.label).toList()),
            trailing: widget.trailing,
            content: widget.content,
            showBack: widget.showBack,
          ),
        );
      },
    );
  }
}
