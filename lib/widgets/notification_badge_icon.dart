import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';
import '../status/unread_notification_count.dart';

class NotificationBadgeIcon extends ConsumerWidget {
  const NotificationBadgeIcon({super.key, this.color, this.size = 24});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadNotificationCountProvider).value ?? 0;
    final icon = Icon(TablerIcons.bell, size: size, color: color);
    if (count <= 0) {
      return icon;
    }

    final themes = ref.watch(themeColorsProvider);
    return badges.Badge(
      key: const ValueKey('notification-unread-badge'),
      position: badges.BadgePosition.topEnd(top: -10, end: -13),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.square,
        borderRadius: BorderRadius.circular(99),
        badgeColor: themes.accentColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      ),
      badgeAnimation: const badges.BadgeAnimation.fade(
        animationDuration: Duration(milliseconds: 150),
      ),
      badgeContent: Text(
        formatUnreadNotificationCount(count),
        style: TextStyle(
          color: themes.fgOnAccentColor,
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: icon,
    );
  }
}

class NotificationCountIndicator extends ConsumerWidget {
  const NotificationCountIndicator({super.key, this.margin = EdgeInsets.zero});

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadNotificationCountProvider).value ?? 0;
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    final themes = ref.watch(themeColorsProvider);
    return Padding(
      padding: margin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: themes.accentColor,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Text(
            formatUnreadNotificationCount(count),
            style: TextStyle(
              color: themes.fgOnAccentColor,
              fontSize: 10,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
