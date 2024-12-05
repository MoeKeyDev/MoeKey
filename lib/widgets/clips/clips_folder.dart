import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_overflow_show.dart';
import 'package:moekey/generated/l10n.dart';
import '../../apis/models/clips.dart';
import '../../status/themes.dart';
import '../../utils/time_ago_since_date.dart';
import '../notes/note_card.dart';

class ClipsFolder extends HookConsumerWidget {
  final ClipsModel data;

  const ClipsFolder({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textStyle = Theme.of(context).textTheme.bodyMedium;

    return DefaultTextStyle(
        style: textStyle!,
        child: MkCard(
          shadow: false,
          child: ClipsCardComponent(
            data: data,
          ),
        ));
  }
}

class ClipsCardComponent extends HookConsumerWidget {
  final ClipsModel data;

  ClipsCardComponent({super.key, required this.data});

  final ConstraintId avatar = ConstraintId('avatar');
  final ConstraintId content = ConstraintId('content');
  final double limit = 1000;
  final double height = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fontsize = DefaultTextStyle.of(context).style.fontSize!;
    var themes = ref.watch(themeColorsProvider);

    return LayoutBuilder(builder: (context, constraints) {
      var isSmall = constraints.maxWidth < 400;
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // MainRouterDelegate.of(context).setNewRoutePath(
            //   RouterItem(
            //     path: "/clips/${data.id}",
            //     page: () => ClipsNotes(data.id),
            //   ),
            // );
            context.push("/clips/${data.id}");
          },
          child: Container(
            color: Colors.transparent,
            child: ConstraintLayout(
              children: [
                GestureDetector(
                  onTap: () {
                    // MainRouterDelegate.of(context).setNewRoutePath(
                    //   RouterItem(
                    //     path: "/user/${data.userId}",
                    //     page: () => UserPage(
                    //       userId: data.userId,
                    //     ),
                    //   ),
                    // );
                    context.push("/user/${data.userId}");
                  },
                  child: MkImage(
                    data.user.avatarUrl ?? "",
                    shape: BoxShape.circle,
                  ),
                ).applyConstraint(
                  top: parent.top,
                  left: parent.left,
                  size: isSmall ? 7 * (fontsize - 8) : 8 * (fontsize - 8),
                  id: avatar,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left:
                          isSmall ? 8.5 * (fontsize - 8) : 10 * (fontsize - 8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: UserNameRichText(
                            data: data.user,
                            navigator: false,
                          )),
                          if (data.lastClippedAt != null)
                            Text(
                                "${DateFormat('yyyy-MM-dd HH:mm:ss').format(data.lastClippedAt!)}(${timeAgoSinceDate(data.createdAt)})",
                                style: TextStyle(fontSize: fontsize * 0.9)),
                          const SizedBox(
                            width: 6,
                          ),
                          if (!data.isPublic)
                            Icon(
                              TablerIcons.lock,
                              size: fontsize,
                              color: themes.fgColor,
                            ),
                        ],
                      ),
                      Row(
                        // 两端对齐
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (data.favoritedCount != 0)
                            Row(
                              children: [
                                Text(data.favoritedCount.toString()),
                                Icon(
                                  TablerIcons.heart,
                                  size: fontsize,
                                  color: themes.fgColor,
                                )
                              ],
                            ),
                        ],
                      ),
                      MkOverflowShow(
                          content: MFMText(text: data.description ?? ""),
                          action: (isShow, p1) {
                            return Text(S.current.viewMore);
                          },
                          limit: limit,
                          height: height)
                    ],
                  ),
                ).applyConstraint(
                  top: parent.top,
                  width: matchParent,
                  height: wrapContent,
                  id: content,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
