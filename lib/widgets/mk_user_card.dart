import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/router/main_router_delegate.dart';

import '../apis/models/user_full.dart';
import '../pages/users/user_page.dart';
import '../status/themes.dart';
import '../status/user.dart';
import 'hover_builder.dart';
import 'loading_weight.dart';
import 'mfm_text/mfm_text.dart';
import 'mk_card.dart';
import 'mk_image.dart';

class MkUserCard extends HookConsumerWidget {
  const MkUserCard({
    super.key,
    required this.user,
  });

  final UserFullModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var textStyle = DefaultTextStyle.of(context).style;
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
              path: "user/${user.id}",
              page: () {
                return UserPage(userId: user.id);
              },
            ));
          },
          child: SizedBox(
            height: 300,
            child: MkCard(
              padding: EdgeInsets.zero,
              shadow: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 84,
                    color: const Color.fromARGB(26, 0, 0, 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (user.bannerUrl != null)
                          Positioned.fill(
                            child: MkImage(
                              width: double.infinity,
                              height: 84,
                              user.bannerUrl!,
                              blurHash: user.avatarBlurhash,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (user.isFollowed)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(180, 0, 0, 0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: const Text(
                                "正在关注你",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: UserFullCardFollowBtn(
                              userData: user, themes: themes),
                        ),
                        Positioned(
                          top: 62,
                          left: 16,
                          child: Container(
                            width: 58,
                            height: 58,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: themes.panelColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50))),
                            child: MkImage(
                              shape: BoxShape.circle,
                              user.avatarUrl ?? "",
                              blurHash: user.avatarBlurhash,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 88, top: 10, right: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle(
                          style:
                              textStyle.copyWith(fontWeight: FontWeight.bold),
                          child: MFMText(
                            text: user.name ?? user.username,
                            after: [
                              const TextSpan(text: "\n"),
                              TextSpan(
                                  text: "@${user.username ?? ""}",
                                  style: textStyle.copyWith(
                                    fontSize: 11,
                                  )),
                              TextSpan(
                                text: user.host != null ? "@${user.host}" : "",
                                style: textStyle.copyWith(
                                    color: themes.fgColor.withAlpha(128),
                                    fontSize: 11),
                              ),
                            ],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            emojis: user.emojis,
                            bigEmojiCode: false,
                            feature: const [MFMFeature.emojiCode],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: themes.dividerColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: DefaultTextStyle(
                          style: textStyle.copyWith(fontSize: 11),
                          child: SizedBox(
                            width: double.infinity,
                            child: MFMText(
                              text: user.description ?? "此用户尚无自我介绍",
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              emojis: user.emojis,
                              bigEmojiCode: false,
                              feature: const [MFMFeature.emojiCode],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
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
                            const Text("帖子", style: TextStyle(fontSize: 11)),
                            Text("${user.notesCount}",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themes.accentColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("关注中", style: TextStyle(fontSize: 11)),
                            Text("${user.followingCount}",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themes.accentColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("关注者", style: TextStyle(fontSize: 11)),
                            Text("${user.followersCount}",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: themes.accentColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserFullCardFollowBtn extends HookConsumerWidget {
  const UserFullCardFollowBtn({
    super.key,
    required this.userData,
    required this.themes,
  });

  final UserFullModel? userData;
  final ThemeColorModel themes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProvider = userInfoProvider(userModel: this.userData);
    var userData = ref.watch(userProvider).valueOrNull;
    if (userData == null) return const SizedBox();
    return HoverBuilder(
      builder: (context, isHover) {
        return GestureDetector(
          onTap: () {
            var notifier = ref.read(userProvider.notifier);
            if (userData.hasPendingFollowRequestFromYou) {
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
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
              color: (userData.isFollowing) ||
                      (userData.hasPendingFollowRequestFromYou)
                  ? themes.buttonGradateAColor
                  : Colors.white,
              border: Border.all(color: themes.buttonGradateAColor, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: [
              if (userData.hasPendingFollowRequestFromYou)
                Row(
                  children: [
                    if (userData.isLocked)
                      const Icon(
                        TablerIcons.hourglass_empty,
                        color: Colors.white,
                        size: 15,
                      )
                    else
                      LoadingCircularProgress(
                        size: 15,
                        color: Colors.white,
                        strokeWidth: 3,
                        backgroundColor: Colors.white.withOpacity(0.5),
                      )
                  ],
                )
              else
                Row(
                  children: [
                    Icon(
                      userData.isFollowing
                          ? TablerIcons.minus
                          : TablerIcons.plus,
                      color: userData.isFollowing
                          ? Colors.white
                          : themes.buttonGradateAColor,
                      size: 15,
                    )
                  ],
                )
            ][0],
          ),
        );
      },
    );
  }
}

class SliverPaginationUserList extends HookConsumerWidget {
  const SliverPaginationUserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView();
  }
}
