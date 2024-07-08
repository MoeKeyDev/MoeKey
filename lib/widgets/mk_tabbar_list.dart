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
  Widget child;

  MkTabBarItem({
    required this.label,
    required this.child,
  });
}

class MkTabBarRefreshScroll extends StatefulWidget {
  const MkTabBarRefreshScroll(
      {super.key,
      required this.items,
      this.leading,
      this.trailing,
      this.content,
      this.bottom,
      this.showBack = false,
      this.onIndexUpdate,
      this.initIndex = 0,
      this.padding = EdgeInsets.zero,
      this.tabAlignment = TabAlignment.center});

  final List<MkTabBarItem> items;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final PreferredSizeWidget? bottom;
  final bool showBack;
  final int initIndex;
  final EdgeInsetsGeometry padding;
  final void Function(int)? onIndexUpdate;

  final TabAlignment tabAlignment;

  @override
  State<MkTabBarRefreshScroll> createState() => MkTabBarRefreshScrollState();
}

class MkTabBarRefreshScrollState extends State<MkTabBarRefreshScroll>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<MkRefreshController> refreshControllers;
  late List<ScrollController> scrollControllers;
  int lastIndex = 0;

  @override
  void initState() {
    super.initState();
    lastIndex = widget.initIndex;
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
    refreshControllers = List<MkRefreshController>.from(
        widget.items.map((_) => MkRefreshController()));
    scrollControllers = List.from(widget.items.map((_) => ScrollController()));
  }

  @override
  void didUpdateWidget(MkTabBarRefreshScroll oldWidget) {
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
                  child: DefaultMkRefreshController(
                    controller: refreshControllers[index],
                    child: PrimaryScrollController(
                      controller: scrollControllers[index],
                      child: item.child,
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
                tabAlignment: widget.tabAlignment,
                onTap: (value) {
                  if (lastIndex == value) {
                    refresh();
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

  void refresh() {
    var value = tabController.index;
    var controller = scrollControllers[value];
    var refreshController = refreshControllers[value];
    if (!controller.hasClients) return;

    if (controller.offset > 0) {
      controller.animateTo(
        0,
        duration: Duration(
          milliseconds: (controller.offset).toInt().clamp(100, 300),
        ),
        curve: Curves.easeInOut,
      );
    } else {
      refreshController.refresh();
    }
  }
}
