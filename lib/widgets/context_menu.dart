import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/loading_weight.dart';

import '../status/themes.dart';
import 'hover_builder.dart';

/// 上下文菜单的触发模式
enum ContextMenuMode {
  /// 单击触发
  onTap,

  /// 右键单击触发
  onSecondaryTap,

  /// 长按触发
  onLongPress,
}

final ContextMenuController _contextMenuController = ContextMenuController();

/// 上下文菜单组件，支持在页面上弹出菜单
class ContextMenuBuilder extends ConsumerStatefulWidget {
  const ContextMenuBuilder({
    super.key,
    required this.child,
    required this.menu,
    this.behavior = HitTestBehavior.translucent,
    this.alignmentChild = false,
    this.mode,
    this.maskColor,
  });

  /// 子元素
  final Widget child;

  /// 上下文菜单
  final ContextMenuCard menu;

  /// 触发模式
  final List<ContextMenuMode>? mode;

  /// 遮罩颜色，默认无遮罩
  final Color? maskColor;

  /// 对齐子元素，当启此选项之后菜单的弹出位置将会出现在 [child] 正下方
  /// 默认为禁用，菜单的弹出位置将默认为鼠标点击的位置
  final bool alignmentChild;

  final HitTestBehavior behavior;

  @override
  ConsumerState<ContextMenuBuilder> createState() => ContextMenuBuilderState();
}

class ContextMenuBuilderState extends ConsumerState<ContextMenuBuilder>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    // 缩放动画
    tween1 = Tween(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    // 淡入淡出
    tween2 = Tween(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  late AnimationController _animationController;
  late Animation<double> tween1;
  late Animation<double> tween2;

  show(Offset offset) {
    if (Platform.isAndroid || Platform.isIOS) {
      showBottomSheet();
      return;
    }
    _show(offset);
  }

  _show(Offset offset) {
    _animationController.reset();
    _animationController.forward();
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (context) {
        return getContextMenuLayoutWidget(offset);
      },
    );
  }

  showBottomSheet() {
    print(context.hashCode);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        print(this.context.hashCode);
        return ContextDraggableBottomSheet(menu: widget.menu);
      },
    );
  }

  LayoutBuilder getContextMenuLayoutWidget(Offset offset) {
    var childSize = (context.findRenderObject() as RenderBox).size;
    var childOffset =
        (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);

    // 当设置子元素对齐的时候，将菜单对齐到子元素的底部居中
    var menuOffset = const Offset(0, 0);
    if (widget.alignmentChild) {
      offset = childOffset;
      menuOffset = Offset(
          -((widget.menu.width - childSize.width) / 2), childSize.height);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget w = ScaleTransition(
            alignment: Alignment(offset.dx / constraints.maxWidth * 2 - 1,
                offset.dy / constraints.minHeight * 2 - 1),
            scale: tween1,
            child: ContextMenuLayoutWidget(
                menu: widget.menu,
                offset: offset + menuOffset,
                controller: this));

        // 不透明遮罩
        if (widget.maskColor != null) {
          w = Container(
            color: widget.maskColor ?? Colors.transparent,
            child: w,
          );
        }
        return GestureDetector(
          onTap: () {
            hidden();
          },
          behavior: HitTestBehavior.translucent,
          child: FadeTransition(
            opacity: tween2,
            child: w,
          ),
        );
      },
    );
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _onTapUp(TapUpDetails details) {
    if (Platform.isAndroid || Platform.isIOS) {
      showBottomSheet();
      return;
    }
    _show(details.globalPosition);
  }

  void _onLongPress() {
    if (Platform.isAndroid || Platform.isIOS) {
      showBottomSheet();
      // 长按震动
      HapticFeedback.heavyImpact();
    }
  }

  hidden() async {
    await _animationController.reverse();
    _contextMenuController.remove();
  }

  @override
  Widget build(BuildContext context) {
    var mode = widget.mode ??
        [ContextMenuMode.onSecondaryTap, ContextMenuMode.onLongPress];
    var isMobile = Platform.isAndroid || Platform.isIOS;
    return GestureDetector(
      behavior: widget.behavior,
      onSecondaryTapUp: mode.contains(ContextMenuMode.onSecondaryTap)
          ? _onSecondaryTapUp
          : null,
      onTapUp: mode.contains(ContextMenuMode.onTap) ? _onTapUp : null,
      onLongPress: mode.contains(ContextMenuMode.onLongPress) && isMobile
          ? _onLongPress
          : null,
      child: widget.child,
    );
  }
}

class ContextDraggableBottomSheet extends HookConsumerWidget {
  const ContextDraggableBottomSheet({super.key, required this.menu});

  final ContextMenuCard menu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var data = useMemoized(() {
      if (menu.menuListBuilder != null) {
        return Future.value(menu.menuListBuilder!());
      }

      if (menu.widgetBuilder != null) {
        return Future.value(menu.widgetBuilder!(
            onHidden: () {
              Navigator.of(context).pop();
            },
            large: true));
      }
    });
    var snapshot = useFuture(data);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      behavior: HitTestBehavior.opaque,
      child: DraggableScrollableSheet(
        initialChildSize: menu.initialChildSize,
        //set this as you want
        maxChildSize: menu.maxChildSize,
        //set this as you want
        minChildSize: menu.minChildSize,
        //set this as you want
        expand: true,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            decoration: BoxDecoration(
              color: themes.panelColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            height: 1000,
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 4,
                      decoration: BoxDecoration(
                          color: themes.dividerColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(
                    child: LoadingCircularProgress(size: 18, strokeWidth: 4),
                  ),
                if (snapshot.connectionState == ConnectionState.done)
                  if (menu.menuListBuilder != null)
                    for (var item in snapshot.data! as List<ContextMenuItem>)
                      _ContextMenuItem(
                        contextMenuItem: item,
                        large: true,
                        onHidden: () {
                          Navigator.of(context).pop();
                        },
                        onTap: () async {
                          if (item.child != null) {
                            Future.delayed(const Duration(milliseconds: 100))
                                .then((value) {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                builder: (context) {
                                  return ContextDraggableBottomSheet(
                                    menu: item.child!,
                                  );
                                },
                              );
                            });
                          }
                        },
                      )
                  else if (menu.widgetBuilder != null)
                    (snapshot.data! as Widget)
              ],
            ),
          );
        },
      ),
    );
  }
}

class ContextMenuLayoutWidget extends StatefulWidget {
  const ContextMenuLayoutWidget({
    super.key,
    required this.menu,
    required this.offset,
    required this.controller,
  });

  final ContextMenuCard menu;
  final Offset offset;
  final ContextMenuBuilderState controller;

  @override
  State<ContextMenuLayoutWidget> createState() =>
      _ContextMenuLayoutWidgetState();
}

class _ContextMenuLayoutWidgetState extends State<ContextMenuLayoutWidget> {
  List<double> offsetList = [];

  List<ContextMenuCard> menuList = [];

  Map<int, int> indexList = {};

  Map<ContextMenuCard, Future<List<ContextMenuItem>>> menuListCacheMap = {};
  Map<ContextMenuCard, Future<Widget>> widgetCacheMap = {};

  getWidgetFromItem(ContextMenuCard list, {int index = 0}) {
    assert(list.menuListBuilder != null);
    if (indexList[index] == null) {
      indexList[index] = -1;
    }
    if (menuListCacheMap[list] == null) {
      if (list.menuListBuilder != null) {
        menuListCacheMap[list] = Future.value(list.menuListBuilder!());
      }
    }

    return FutureBuilder(
      future: menuListCacheMap[list],
      builder: (context, AsyncSnapshot<List<ContextMenuItem>> snapshot) {
        var isDone = snapshot.connectionState == ConnectionState.done;
        return _ContextMenu(
          width: list.width,
          children: [
            if (isDone)
              for (var (index1, item) in snapshot.data?.indexed ?? [].indexed)
                Builder(
                  builder: (context) {
                    return _ContextMenuItem(
                        contextMenuItem: item,
                        isActive:
                            item.child != null && indexList[index] == index1,
                        onHover: () {
                          if (indexList[index] == index1) return;
                          indexList[index] = index1;
                          // 清理旧的index
                          for (var t in indexList.keys) {
                            if (t > index) {
                              indexList[t] = -1;
                            }
                          }
                          RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                          RenderBox parentRenderBox =
                              context.findRenderObject()!.parent as RenderBox;

                          // logger.d(renderBox.globalToLocal(widget.offset).dy);
                          offsetList.removeRange(index + 1, offsetList.length);
                          menuList.removeRange(index + 1, menuList.length);
                          if (item.child != null) {
                            offsetList.add(
                                parentRenderBox.globalToLocal(Offset.zero).dy -
                                    renderBox.globalToLocal(Offset.zero).dy);
                            menuList.add(item.child!);
                          }
                          setState(() {});
                        },
                        onHidden: () {
                          widget.controller.hidden();
                        });
                  },
                )
            else
              const Center(
                child: LoadingCircularProgress(size: 18, strokeWidth: 4),
              )
          ],
        );
      },
    );
  }

  getWidgetFromWidgetItem(ContextMenuCard list, {int index = 0}) {
    assert(list.widgetBuilder != null);
    if (indexList[index] == null) {
      indexList[index] = -1;
    }
    if (widgetCacheMap[list] == null) {
      if (list.widgetBuilder != null) {
        widgetCacheMap[list] = Future.value(list.widgetBuilder!(
            onHidden: () {
              widget.controller.hidden();
            },
            large: false));
      }
    }

    return FutureBuilder(
      future: widgetCacheMap[list],
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        var isDone = snapshot.connectionState == ConnectionState.done;
        return _ContextMenu(
          width: list.width,
          children: [
            if (isDone)
              snapshot.data!
            else
              const LoadingCircularProgress(size: 18, strokeWidth: 4)
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    offsetList.add(0);
    menuList.add(widget.menu);
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: ContextMenuLayout(children: [
        for (var (index, item) in offsetList.indexed)
          ContextMenuLayoutOffset(id: index, offset: item),
      ], offset: widget.offset),
      children: [
        for (var (index, item) in menuList.indexed)
          LayoutId(
            id: index,
            child: item.menuListBuilder != null
                ? getWidgetFromItem(item, index: index)
                : getWidgetFromWidgetItem(item, index: index),
          ),
      ],
    );
  }
}

class ContextMenuLayoutOffset {
  ContextMenuLayoutOffset({
    required this.id,
    required this.offset,
  });

  final int id;
  final double offset;
}

class ContextMenuLayout extends MultiChildLayoutDelegate {
  ContextMenuLayout({required this.children, required this.offset});

  final List<ContextMenuLayoutOffset> children;
  final Offset offset;

  @override
  void performLayout(Size size) {
    var lastOffset = offset;
    if (lastOffset.dy < 0) {
      lastOffset = Offset(lastOffset.dx, 0);
    }
    if (lastOffset.dx < 0) {
      lastOffset = Offset(0, lastOffset.dy);
    }
    var lastSize = Size.zero;
    for (var (index, item) in children.indexed) {
      var id = item.id;
      var childSize = layoutChild(id, BoxConstraints.loose(size));
      double dx = lastOffset.dx + lastSize.width;
      double dy = item.offset + lastOffset.dy;
      if (dy + childSize.height > size.height) {
        if (index == 0) {
          dy = lastOffset.dy - childSize.height;
        } else {
          dy = size.height - childSize.height;
        }
      }
      if (dx + childSize.width > size.width) {
        if (index == 0) {
          dx = size.width - childSize.width;
        } else {
          dx = lastOffset.dx - childSize.width;
        }
      }
      positionChild(id, Offset(dx, dy));
      lastOffset = Offset(dx, dy);
      lastSize = childSize;
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class ContextMenuCard {
  final double width;
  final double maxChildSize;
  final double minChildSize;
  final double initialChildSize;
  final FutureOr<List<ContextMenuItem>> Function()? menuListBuilder;
  final FutureOr<Widget> Function(
      {required void Function() onHidden, required bool large})? widgetBuilder;

  ContextMenuCard({
    this.width = 200,
    this.menuListBuilder,
    this.widgetBuilder,
    this.maxChildSize = 0.5,
    this.minChildSize = 0.4,
    this.initialChildSize = 0.4,
  });
}

class ContextMenuItem {
  ContextMenuItem({
    this.label,
    this.icon,
    this.child,
    this.widget,
    this.danger = false,
    this.divider = false,
    this.onTap,
    this.title,
    this.isActive = false,
  });

  String? label;
  IconData? icon;
  ContextMenuCard? child;
  bool danger;
  bool divider;
  String? title;
  bool isActive;
  Widget Function(BuildContext context, bool large, bool isHover)? widget;
  FutureOr<bool> Function()? onTap;
}

class _ContextMenuItem extends ConsumerWidget {
  const _ContextMenuItem(
      {required this.contextMenuItem,
      this.onHover,
      this.isActive = false,
      this.large = false,
      this.onTap,
      this.onHidden});

  final ContextMenuItem contextMenuItem;
  final void Function()? onHover;
  final void Function()? onTap;
  final bool isActive;
  final bool large;
  final void Function()? onHidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var hoverColor = contextMenuItem.danger ? Colors.white : themes.accentColor;
    var color = contextMenuItem.danger ? Colors.red : themes.fgColor;
    var bgColor = contextMenuItem.danger ? Colors.red : themes.accentedBgColor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: HoverBuilder(
        onHover: (isHover) {
          if (isHover && onHover != null) {
            onHover!();
          }
        },
        builder: (context, isHover) {
          isHover = isHover || isActive || contextMenuItem.isActive;

          Widget box;
          if (contextMenuItem.widget != null) {
            box = contextMenuItem.widget!(context, large, isHover);
          } else {
            assert(contextMenuItem.label != null);
            box = Padding(
              padding:
                  large ? const EdgeInsets.all(16) : const EdgeInsets.all(6),
              child: Row(
                children: [
                  if (contextMenuItem.icon != null) ...[
                    Icon(contextMenuItem.icon,
                        size: large ? 18 : 16,
                        color: isHover ? hoverColor : color),
                    const SizedBox(width: 8)
                  ],
                  Text(
                    contextMenuItem.label!,
                  ),
                  if (contextMenuItem.child != null) ...[
                    const Spacer(),
                    Icon(TablerIcons.chevron_right,
                        size: large ? 18 : 16,
                        color: isHover ? hoverColor : color)
                  ],
                ],
              ),
            );
          }
          box = DecoratedBox(
              decoration: BoxDecoration(
                color: isHover ? bgColor : null,
                borderRadius: large
                    ? const BorderRadius.all(Radius.circular(12))
                    : const BorderRadius.all(Radius.circular(6)),
              ),
              child: GestureDetector(
                onTap: () async {
                  if (contextMenuItem.child != null) {
                    return;
                  }

                  if (contextMenuItem.onTap != null) {
                    var res = await contextMenuItem.onTap!();
                    if (res) return;
                  }
                  if (onTap != null) {
                    onTap!();
                  }
                  if (onHidden != null) {
                    onHidden!();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: DefaultTextStyle(
                  style: DefaultTextStyle.of(context).style.copyWith(
                      color: isHover ? hoverColor : color,
                      fontSize: large ? 15 : 14),
                  child: box,
                ),
              ));
          if (contextMenuItem.divider || contextMenuItem.title != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (contextMenuItem.title != null) ...[
                  Padding(
                    padding: large
                        ? const EdgeInsets.only(left: 16, top: 12, bottom: 12)
                        : const EdgeInsets.only(left: 6, top: 4, bottom: 4),
                    child: Opacity(
                      opacity: 0.7,
                      child: Text(
                        contextMenuItem.title!,
                        style: TextStyle(fontSize: large ? 14 : 11),
                      ),
                    ),
                  ),
                ],
                box,
                if (contextMenuItem.divider) ...[
                  const SizedBox(height: 8),
                  Divider(height: 1, color: themes.dividerColor),
                  const SizedBox(height: 8),
                ]
              ],
            );
          }
          return box;
        },
      ),
    );
  }
}

class _ContextMenu extends HookConsumerWidget {
  const _ContextMenu({
    required this.children,
    this.width = 200,
  });

  final List<Widget> children;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: themes.panelColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: themes.shadowColor,
                offset: const Offset(2, 2),
                blurRadius: 32)
          ]),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
