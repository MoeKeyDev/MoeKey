import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/time_ago_since_date.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/notes/note_card.dart';

import '../../apis/models/notification.dart';
import '../mk_card.dart';

class NotificationsUserCard extends HookConsumerWidget {
  const NotificationsUserCard(
      {super.key,
      required this.data,
      required this.borderRadius,
      required this.content,
      this.avatarBadge,
      this.name,
      this.avatar,
      this.onTap});

  final NotificationModel data;
  final BorderRadius borderRadius;
  final Widget content;
  final Widget? avatarBadge;
  final Widget? name;
  final Widget? avatar;
  final void Function(BuildContext context)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeColorsProvider);
    var fontsize = DefaultTextStyle.of(context).style.fontSize!;
    return LayoutBuilder(builder: (context, constraints) {
      var isSmall = constraints.maxWidth < 400;
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!(context);
          }
        },
        child: MkCard(
          shadow: false,
          borderRadius: borderRadius,
          child: Row(
            children: [
              SizedBox(
                width: isSmall ? 7 * (fontsize - 8) : 8 * (fontsize - 8),
                height: isSmall ? 7 * (fontsize - 8) : 8 * (fontsize - 8),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    avatar != null
                        ? avatar!
                        : GestureDetector(
                            child: MkImage(
                              data.user?.avatarUrl ?? "",
                              blurHash: data.user?.avatarBlurhash,
                              shape: BoxShape.circle,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            onTap: () {
                              context.push('/user/${data.user?.id}');
                            },
                          ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: avatarBadge ?? const SizedBox(),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: isSmall ? 1.5 * (fontsize - 8) : 2 * (fontsize - 8),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: name != null
                              ? name!
                              : data.user != null
                                  ? UserNameRichText(data: data.user!)
                                  : const SizedBox()),
                      Opacity(
                        opacity: 0.8,
                        child: Text(timeAgoSinceDate(data.createdAt)),
                      )
                    ],
                  ),
                  content
                ],
              ))
            ],
          ),
        ),
      );
    });
  }
}
