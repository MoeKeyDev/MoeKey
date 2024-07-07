import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/status/user.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/utils/time_to_desired_format.dart';
import 'package:moekey/widgets/blur_widget.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/loading_weight.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/mk_parallax.dart';

class UserOverview extends HookConsumerWidget {
  const UserOverview({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = userNotesListProvider(userId: userId);

    var data = ref.watch(dataProvider);
    return MkPaginationNoteList(
      onLoad: () => ref.read(dataProvider.notifier).load(),
      onRefresh: () => ref.refresh(dataProvider.future),
      slivers: [
        SliverLayoutBuilder(builder: (context, constraints) {
          var offset = constraints.remainingPaintExtent -
              constraints.viewportMainAxisExtent +
              constraints.scrollOffset +
              constraints.precedingScrollExtent;
          offset = (offset / 140).clamp(0, 1.0);
          return SliverToBoxAdapter(
            child: UserHomeCard(userId: userId, offset: offset),
          );
        }),
      ],
      hasMore: data.valueOrNull?.hasMore ?? true,
      items: data.valueOrNull?.list ?? [],
    );
  }
}

class UserHomeCard extends HookConsumerWidget {
  const UserHomeCard({
    super.key,
    required this.userId,
    this.offset = 0,
  });

  final String userId;
  final double offset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProvider = userInfoProvider(userId: userId);
    var user = ref.watch(userProvider);
    var currentUser = ref.watch(currentLoginUserProvider);
    var userData = user.valueOrNull;
    var themes = ref.watch(themeColorsProvider);
    if (userData != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          var isSmall = constraints.maxWidth < 500;
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: MkCard(
              padding: EdgeInsets.zero,
              shadow: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isSmall ? 140 : 240,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (userData.bannerUrl == null)
                          const Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 65, 81, 94)),
                            ),
                          )
                        else
                          Positioned.fill(
                            child: RepaintBoundary(
                              child: Parallax(
                                url: userData.bannerUrl ?? "",
                                blurHash: userData.bannerBlurhash ?? "",
                              ),
                            ),
                          ),
                        // 阴影遮罩
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.4),
                                ],
                                end: Alignment.bottomCenter,
                                begin: Alignment.topCenter,
                                stops: const [0, 0.25, 0.65, 1],
                              ),
                            ),
                          ),
                        ),
                        // 头像
                        Align(
                          alignment: isSmall
                              ? Alignment.bottomCenter
                              : const Alignment(-1, 1),
                          child: Transform.translate(
                            offset: Offset(isSmall ? 0 : 16, isSmall ? 50 : 60),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: themes.panelColor, width: 8),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(200),
                                ),
                                color: themes.panelColor,
                                boxShadow: [
                                  if (!isSmall)
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                ],
                              ),
                              height: isSmall ? 120 : 160,
                              width: isSmall ? 120 : 160,
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                        child: MkImage(
                                      userData.avatarUrl ?? "",
                                      blurHash: userData.bannerBlurhash,
                                      fit: BoxFit.cover,
                                      width: isSmall ? 100 : 140,
                                      height: isSmall ? 100 : 140,
                                      shape: BoxShape.circle,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 大屏的用户名
                        if (!isSmall)
                          Positioned(
                            bottom: 0,
                            left: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DefaultTextStyle(
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 24),
                                    child: MFMText(
                                      text: userData.name ?? userData.username,
                                      feature: const [MFMFeature.emojiCode],
                                      bigEmojiCode: false,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      emojis: userData.emojis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ContextMenuBuilder(
                                    menu: ContextMenuCard(
                                      menuListBuilder: () {
                                        return [
                                          ContextMenuItem(
                                            label: "复制用户名",
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text:
                                                      "@${userData.username}@${userData.host}"));
                                              return false;
                                            },
                                          ),
                                        ];
                                      },
                                    ),
                                    mode: const [
                                      ContextMenuMode.onSecondaryTap,
                                      ContextMenuMode.onSecondaryTap
                                    ],
                                    child: DefaultTextStyle(
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(
                                              fontSize: 15,
                                              color: Colors.white),
                                      child: Opacity(
                                        opacity: 0.7,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "@${userData.username}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (userData.host != null)
                                              Text("@${userData.host}"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (userData.isFollowed)
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(175, 0, 0, 0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Text(
                                "正在关注你",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: BlurWidget(
                              color: const Color.fromARGB(40, 0, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Row(
                                  children: [
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: ContextMenuBuilder(
                                        menu: ContextMenuCard(
                                          menuListBuilder: () {
                                            return [
                                              ContextMenuItem(
                                                label: "复制用户名",
                                                icon: TablerIcons.at,
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text:
                                                          "@${userData.username}@${userData.host}"));
                                                  return false;
                                                },
                                              ),
                                              ContextMenuItem(
                                                label: "复制RSS",
                                                icon: TablerIcons.rss,
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text:
                                                          "${userData.host}/@${userData.username}.atom"));
                                                  return false;
                                                },
                                              ),
                                              ContextMenuItem(
                                                label: "转到浏览器显示",
                                                icon: TablerIcons.external_link,
                                                onTap: () {
                                                  launchUrlString(
                                                      "https://${userData.host}/@${userData.username}");
                                                  return false;
                                                },
                                              ),
                                              ContextMenuItem(
                                                label: "复制用户主页地址",
                                                icon: TablerIcons.home,
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text:
                                                          "https://${userData.host}/@${userData.username}"));
                                                  return false;
                                                },
                                              ),
                                              // ContextMenuItem(
                                              //   label: "发送",
                                              //   icon: TablerIcons.mail,
                                              // ),
                                            ];
                                          },
                                        ),
                                        mode: const [
                                          ContextMenuMode.onTap,
                                          ContextMenuMode.onSecondaryTap,
                                          ContextMenuMode.onSecondaryTap
                                        ],
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 6),
                                          child: const Icon(
                                            TablerIcons.dots,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (currentUser?.id != user.value?.id)
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            var notifier =
                                                ref.read(userProvider.notifier);
                                            if (userData
                                                .hasPendingFollowRequestFromYou) {
                                              notifier.followingCancel();
                                              return;
                                            }
                                            if (userData.isFollowing) {
                                              notifier.followingDelete();
                                              return;
                                            }
                                            notifier.followingCreate();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                                color: userData.isFollowing ||
                                                        userData
                                                            .hasPendingFollowRequestFromYou
                                                    ? themes.buttonGradateAColor
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: themes
                                                        .buttonGradateAColor,
                                                    width: 1)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 8),
                                            child: [
                                              if (userData
                                                  .hasPendingFollowRequestFromYou)
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      userData.isLocked
                                                          ? "关注请求批准中"
                                                          : "正在处理",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    if (userData.isLocked)
                                                      const Icon(
                                                        TablerIcons
                                                            .hourglass_empty,
                                                        color: Colors.white,
                                                        size: 15,
                                                      )
                                                    else
                                                      LoadingCircularProgress(
                                                        size: 12,
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                        backgroundColor: Colors
                                                            .white
                                                            .withOpacity(0.5),
                                                      )
                                                  ],
                                                )
                                              else
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      userData.isFollowing
                                                          ? "取消关注"
                                                          : "关注",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: userData
                                                                  .isFollowing
                                                              ? Colors.white
                                                              : themes
                                                                  .buttonGradateAColor),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Icon(
                                                      userData.isFollowing
                                                          ? TablerIcons.minus
                                                          : TablerIcons.plus,
                                                      color: userData
                                                              .isFollowing
                                                          ? Colors.white
                                                          : themes
                                                              .buttonGradateAColor,
                                                      size: 15,
                                                    )
                                                  ],
                                                )
                                            ][0],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: isSmall ? 40 : 0,
                  ),
                  if (isSmall)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Builder(builder: (context) {
                              return DefaultTextStyle(
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontWeight: FontWeight.bold),
                                child: MFMText(
                                  text: userData.name ?? userData.username,
                                  feature: const [MFMFeature.emojiCode],
                                  bigEmojiCode: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  emojis: userData.emojis,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ContextMenuBuilder(
                              menu: ContextMenuCard(
                                menuListBuilder: () {
                                  return [
                                    ContextMenuItem(
                                        label: "复制用户名",
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text:
                                                  "@${userData.username}@${userData.host}"));
                                          return false;
                                        }),
                                  ];
                                },
                              ),
                              mode: const [
                                ContextMenuMode.onSecondaryTap,
                                ContextMenuMode.onSecondaryTap
                              ],
                              child: DefaultTextStyle(
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontSize: 13),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "@${userData.username}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (userData.host != null)
                                        Text("@${userData.host}"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!isSmall)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(190, 10, 24, 10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ConstrainedBox(
                            constraints: constraints.copyWith(minHeight: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontSize: 13),
                                  child: MFMText(
                                    text: userData.description ?? "此用户尚无自我介绍",
                                    bigEmojiCode: false,
                                    emojis: userData.emojis,
                                    currentServerHost: userData.host,
                                    isSelection: true,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  Container(
                    height: 1,
                    color: themes.dividerColor,
                  ),
                  if (isSmall) ...[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: DefaultTextStyle(
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontSize: 13),
                              child: MFMText(
                                text: userData.description ?? "此用户尚无自我介绍",
                                bigEmojiCode: false,
                                emojis: userData.emojis,
                                textAlign: TextAlign.center,
                                currentServerHost: userData.host,
                                isSelection: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: themes.dividerColor,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: DefaultTextStyle(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 13),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(TablerIcons.calendar,
                                    color: themes.fgColor, size: 15),
                                const Text(
                                  "注册于",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              timeToDesiredFormat(userData.createdAt),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (userData.fields.isNotEmpty) ...[
                    Container(
                      height: 1,
                      color: themes.dividerColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: DefaultTextStyle(
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontSize: 13),
                        child: Column(
                          children: [
                            for (var item in userData.fields)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item["name"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: MFMText(
                                        text: item["value"],
                                        bigEmojiCode: false,
                                        currentServerHost: userData.host,
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                  Container(
                    height: 1,
                    color: themes.dividerColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("${userData.notesCount}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const Text("帖子", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("${userData.followingCount}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const Text("关注中", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("${userData.followersCount}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const Text("关注者", style: TextStyle(fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return const SizedBox();
  }
}
