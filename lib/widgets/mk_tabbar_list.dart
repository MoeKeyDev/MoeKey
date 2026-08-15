import 'package:flutter/material.dart';
import 'keep_alive_wrapper.dart';
import 'mk_header.dart';
import 'mk_refresh_load.dart';
import 'mk_scaffold.dart';

class MkTabBarItem {
  Widget label;
  Widget child;

  MkTabBarItem({required this.label, required this.child});
}

class MkTabControllerScope extends InheritedWidget {
  const MkTabControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final TabController controller;

  static TabController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MkTabControllerScope>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(MkTabControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

class MkTabBarRefreshScroll extends StatefulWidget {
  const MkTabBarRefreshScroll({
    super.key,
    required this.items,
    this.leading,
    this.trailing,
    this.content,
    this.showBack = false,
    this.onIndexUpdate,
    this.onIndexSettled,
    this.initIndex = 0,
    this.offset = 0,
    this.padding = EdgeInsets.zero,
    this.alwaysStackHeader = false,
    this.tabAlignment = TabAlignment.center,
  });

  final List<MkTabBarItem> items;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final bool showBack;
  final int initIndex;
  final double offset;
  final EdgeInsetsGeometry padding;
  final bool alwaysStackHeader;
  final void Function(int)? onIndexUpdate;
  final void Function(int)? onIndexSettled;

  final TabAlignment tabAlignment;

  @override
  State<MkTabBarRefreshScroll> createState() => MkTabBarRefreshScrollState();
}

class MkTabBarRefreshScrollState extends State<MkTabBarRefreshScroll>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<MkRefreshLoadListController> loadControllers;
  int lastIndex = 0;
  late int _lastSettledIndex;

  void _handleTabChange() {
    widget.onIndexUpdate?.call(tabController.index);
    if (!tabController.indexIsChanging) {
      lastIndex = tabController.index;
      _notifySettledIndex();
    }
  }

  void _handleTabAnimation() {
    if (tabController.indexIsChanging || tabController.offset.abs() > 0.0001) {
      return;
    }
    _notifySettledIndex();
  }

  void _notifySettledIndex() {
    if (tabController.offset.abs() > 0.0001) return;
    final index = tabController.index;
    if (_lastSettledIndex == index) return;
    _lastSettledIndex = index;
    widget.onIndexSettled?.call(index);
  }

  @override
  void initState() {
    super.initState();
    lastIndex = widget.initIndex;
    _lastSettledIndex = widget.initIndex;
    tabController = TabController(
      length: widget.items.length,
      vsync: this,
      initialIndex: widget.initIndex,
    );

    tabController.addListener(_handleTabChange);
    tabController.animation?.addListener(_handleTabAnimation);
    loadControllers = List.from(
      widget.items.map((_) => MkRefreshLoadListController()),
    );
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChange);
    tabController.animation?.removeListener(_handleTabAnimation);
    tabController.dispose();
    for (final controller in loadControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(MkTabBarRefreshScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initIndex != widget.initIndex &&
        widget.initIndex >= 0 &&
        widget.initIndex < tabController.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          tabController.animateTo(widget.initIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MkTabControllerScope(
      controller: tabController,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MkScaffold(
            body: TabBarView(
              controller: tabController,
              children: [
                for (var (index, item) in widget.items.indexed)
                  KeepAliveWrapper(
                    child: DefaultMkRefreshLoadListController(
                      controller: loadControllers[index],
                      child: item.child,
                    ),
                  ),
              ],
            ),
            header: MkAppbar(
              leading: widget.leading,
              isSmallLeadingCenter:
                  widget.alwaysStackHeader ||
                  (widget.leading != null ||
                          widget.trailing != null ||
                          widget.content != null ||
                          widget.showBack == true
                      ? constraints.maxWidth < 500
                      : false),
              bottom: MkTabBar(
                controller: tabController,
                tabAlignment: widget.tabAlignment,
                onTap: (value) {
                  if (lastIndex == value) {
                    refresh();
                  }
                  lastIndex = value;
                },
                tabs: widget.items.map((e) => e.label).toList(),
              ),
              trailing: widget.trailing ?? SizedBox(width: widget.offset),
              content: widget.content,
              showBack: widget.showBack,
            ),
          );
        },
      ),
    );
  }

  void refresh() {
    var value = tabController.index;
    var controller = loadControllers[value];
    controller.refresh();
  }
}
