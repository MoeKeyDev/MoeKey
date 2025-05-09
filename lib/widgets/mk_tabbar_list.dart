import 'package:flutter/material.dart';
import 'keep_alive_wrapper.dart';
import 'mk_header.dart';
import 'mk_refresh_load.dart';
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
      this.showBack = false,
      this.onIndexUpdate,
      this.initIndex = 0,
      this.offset = 0,
      this.padding = EdgeInsets.zero,
      this.tabAlignment = TabAlignment.center});

  final List<MkTabBarItem> items;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final bool showBack;
  final int initIndex;
  final double offset;
  final EdgeInsetsGeometry padding;
  final void Function(int)? onIndexUpdate;

  final TabAlignment tabAlignment;

  @override
  State<MkTabBarRefreshScroll> createState() => MkTabBarRefreshScrollState();
}

class MkTabBarRefreshScrollState extends State<MkTabBarRefreshScroll>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<MkRefreshLoadListController> loadControllers;
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
    loadControllers =
        List.from(widget.items.map((_) => MkRefreshLoadListController()));
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
                  child: DefaultMkRefreshLoadListController(
                    controller: loadControllers[index],
                    child: item.child,
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
            trailing: widget.trailing ??
                SizedBox(
                  width: widget.offset,
                ),
            content: widget.content,
            showBack: widget.showBack,
          ),
        );
      },
    );
  }

  void refresh() {
    var value = tabController.index;
    var controller = loadControllers[value];
    controller.refresh();
  }
}
