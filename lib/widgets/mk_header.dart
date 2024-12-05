import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../generated/l10n.dart';
import '../status/themes.dart';
import 'blur_widget.dart';

class MkToolBar extends ConsumerWidget implements PreferredSizeWidget {
  const MkToolBar({
    super.key,
    this.height = 50,
    required this.child,
    this.border = 1,
  });

  final double height;
  final Widget child;
  final double border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var padding = MediaQuery.of(context).padding;
    Brightness brightness =
        ThemeData.estimateBrightnessForColor(themes.fgColor);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: SizedBox(
        height: height + padding.top,
        child: BlurWidget(
          color: themes.bgColor.withAlpha(204),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padding.top, 0, 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: border > 0
                          ? BorderSide(
                              color: themes.dividerColor, width: border)
                          : BorderSide.none)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class MkAppbar extends ConsumerWidget implements PreferredSizeWidget {
  MkAppbar({
    super.key,
    this.leading,
    this.trailing,
    this.content,
    this.bottom,
    this.showBack = false,
    this.isSmallLeadingCenter = false,
  }) : preferredSize =
            Size.fromHeight(_preferredSize(bottom, isSmallLeadingCenter));
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final PreferredSizeWidget? bottom;
  final bool isSmallLeadingCenter;
  final bool showBack;

  static double _preferredSize(
      PreferredSizeWidget? bottom, bool isSmallLeadingCenter) {
    var size = 50.0;
    if (bottom != null && isSmallLeadingCenter) {
      size += bottom.preferredSize.height;
    }
    return size;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isSmallLeadingCenter) {
      return MkToolBar(
        height: preferredSize.height,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    if (showBack)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.pop();
                              },
                              tooltip: S.of(context).back,
                              icon: const Icon(TablerIcons.arrow_left),
                              // color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    if (content != null)
                      Align(
                        alignment: Alignment.center,
                        child: content,
                      ),
                    if (leading != null)
                      Align(
                        alignment: Alignment.center,
                        child: leading,
                      ),
                    if (trailing != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: trailing,
                      ),
                  ],
                ),
              ),
            ),
            if (bottom != null && isSmallLeadingCenter) bottom!
          ],
        ),
      );
    }
    return MkToolBar(
      height: preferredSize.height,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    if (showBack) ...[
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        tooltip: S.of(context).back,
                        icon: const Icon(TablerIcons.arrow_left),
                        // color: Colors.transparent,
                      ),
                      const SizedBox(width: 8)
                    ],
                    if (leading != null) leading!,
                    if (content != null) Expanded(child: content!),
                    if (bottom != null) Expanded(child: bottom!),
                    if (trailing != null) trailing!
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  final Size preferredSize;
}

class MkTabBar extends ConsumerWidget implements PreferredSizeWidget {
  const MkTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
    this.tabAlignment = TabAlignment.center,
  });

  final TabController controller;
  final List<Widget> tabs;
  final void Function(int)? onTap;
  final TabAlignment tabAlignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return TabBar(
      controller: controller,
      tabs: tabs,
      isScrollable: true,
      tabAlignment: tabAlignment,
      labelPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      onTap: (value) {
        // print(PrimaryScrollController.of(globalNav).offset);
        if (onTap != null) {
          onTap!(value);
        }
      },
      indicatorColor: themes.accentColor,
      dividerColor: Colors.transparent,
      automaticIndicatorColorAdjustment: false,
      labelColor: themes.fgColor,
      unselectedLabelColor: themes.fgColor.withOpacity(0.8),
    );
  }

  @override
  Size get preferredSize {
    double maxHeight = 46.0;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + 2);
  }
}
