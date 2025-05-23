import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/status/user.dart';
import 'package:moekey/utils/time_to_desired_format.dart';
import 'package:moekey/widgets/blur_widget.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../generated/l10n.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/mk_parallax.dart';
import '../../widgets/notes/note_card.dart';

class UserOverview extends HookConsumerWidget {
  const UserOverview({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = userNotesListProvider(
      userId: userId,
      withChannelNotes: true,
      withFiles: false,
      withRenotes: true,
      withReplies: true,
    );
    var userProvider = userInfoProvider(userId: userId);
    var user = ref.watch(userProvider);
    var userPinNote = user.valueOrNull?.pinnedNotes ?? [];
    var themes = ref.watch(themeColorsProvider);
    var data = ref.watch(dataProvider);
    return MkPaginationNoteList(
      onLoad: () => ref.read(dataProvider.notifier).load(),
      onRefresh: () => ref.refresh(dataProvider.future),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: UserHomeCard(userId: userId),
          ),
        ),
        SliverList.separated(
          itemBuilder: (BuildContext context, int index) {
            BorderRadius borderRadius = const BorderRadius.all(Radius.zero);
            if (index == 0) {
              borderRadius = borderRadius.copyWith(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              );
            }
            if (index + 1 == userPinNote.length) {
              borderRadius = borderRadius.copyWith(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              );
            }

            return RepaintBoundary(
              child: NoteCard(
                  key: ValueKey(userPinNote[index].id),
                  borderRadius: borderRadius,
                  pined: true,
                  data: userPinNote[index]),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: double.infinity,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: themes.dividerColor,
                ),
              ),
            );
          },
          itemCount: userPinNote.length,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
          ),
        ),
      ],
      hasMore: data.valueOrNull?.hasMore ?? true,
      items: data.valueOrNull?.list,
    );
  }
}

class UserHomeCard extends HookConsumerWidget {
  const UserHomeCard({
    super.key,
    required this.userId,
  });

  final String userId;

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
                  _UserBanner(
                      isSmall: isSmall,
                      userData: userData,
                      themes: themes,
                      currentUser: currentUser,
                      user: user,
                      userProvider: userProvider),
                  SizedBox(
                    height: isSmall ? 40 : 0,
                  ),
                  if (isSmall) _UserNames(userData: userData),
                  if (!isSmall) _UserDescription(userData: userData),
                  Container(
                    height: 1,
                    color: themes.dividerColor,
                  ),
                  if (isSmall) ...[
                    _UserDescriptionSmall(userData: userData),
                    Container(
                      height: 1,
                      color: themes.dividerColor,
                    ),
                  ],
                  _UserRegisterTime(themes: themes, userData: userData),
                  if (userData.fields.isNotEmpty) ...[
                    Container(
                      height: 1,
                      color: themes.dividerColor,
                    ),
                    _UserFields(userData: userData),
                  ],
                  Container(
                    height: 1,
                    color: themes.dividerColor,
                  ),
                  _UserFollowsCount(userData: userData),
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

class _UserFollowsCount extends StatelessWidget {
  const _UserFollowsCount({
    required this.userData,
  });

  final UserFullModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text("${userData.notesCount}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              Text(S.current.notes, style: TextStyle(fontSize: 12)),
            ],
          ),
          if (userData.followingVisibility == null ||
              userData.followingVisibility == FollowVisibility.PUBLIC ||
              (userData.followingVisibility == FollowVisibility.FOLLOWERS &&
                  userData.isFollowing))
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
                //   path: "user/following/${userData.id}",
                //   page: () {
                //     return UserFollowPage(
                //       userId: userData.id,
                //       type: "following",
                //     );
                //   },
                // ));
                context.push('/user/${userData.id}/following');
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  children: [
                    Text("${userData.followingCount}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(S.current.following, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          if (userData.followersVisibility == null ||
              userData.followersVisibility == FollowVisibility.PUBLIC ||
              (userData.followersVisibility == FollowVisibility.FOLLOWERS &&
                  userData.isFollowing))
            GestureDetector(
              onTap: () {
                // MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
                //   path: "user/followers/${userData.id}",
                //   page: () {
                //     return UserFollowPage(
                //       userId: userData.id,
                //       type: "followers",
                //     );
                //   },
                // ));
                context.push('/user/${userData.id}/followers');
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  children: [
                    Text("${userData.followersCount}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(S.current.followers, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _UserFields extends StatelessWidget {
  const _UserFields({
    required this.userData,
  });

  final UserFullModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
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
    );
  }
}

class _UserRegisterTime extends StatelessWidget {
  const _UserRegisterTime({
    required this.themes,
    required this.userData,
  });

  final ThemeColorModel themes;
  final UserFullModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(TablerIcons.calendar, color: themes.fgColor, size: 15),
                  Text(
                    S.current.userRegisterBy,
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
    );
  }
}

class _UserDescriptionSmall extends StatelessWidget {
  const _UserDescriptionSmall({
    required this.userData,
  });

  final UserFullModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
              child: MFMText(
                text: userData.description ?? S.current.userDescriptionIsNull,
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
    );
  }
}

class _UserDescription extends StatelessWidget {
  const _UserDescription({
    required this.userData,
  });

  final UserFullModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(190, 10, 24, 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: constraints.copyWith(minHeight: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style:
                      DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
                  child: MFMText(
                    text:
                        userData.description ?? S.current.userDescriptionIsNull,
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
    );
  }
}

class _UserNames extends StatelessWidget {
  const _UserNames({
    required this.userData,
  });

  final UserFullModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        label: S.current.copyUsername,
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: "@${userData.username}@${userData.host}"));
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
                style:
                    DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
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
                      if (userData.host != null) Text("@${userData.host}"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBanner extends StatelessWidget {
  const _UserBanner({
    required this.isSmall,
    required this.userData,
    required this.themes,
    required this.currentUser,
    required this.user,
    required this.userProvider,
  });

  final bool isSmall;
  final UserFullModel userData;
  final ThemeColorModel themes;
  final LoginUser? currentUser;
  final AsyncValue<UserFullModel?> user;
  final UserInfoProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isSmall ? 140 : 240,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (userData.bannerUrl == null)
            const Positioned.fill(
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 65, 81, 94)),
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
            alignment:
                isSmall ? Alignment.bottomCenter : const Alignment(-1, 1),
            child: Transform.translate(
              offset: Offset(isSmall ? 0 : 16, isSmall ? 50 : 60),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: themes.panelColor, width: 8),
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
                      style: DefaultTextStyle.of(context).style.copyWith(
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
                              label: S.current.copyUsername,
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
                            .copyWith(fontSize: 15, color: Colors.white),
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
                child: Text(
                  S.current.isFollowingYouNow,
                  style: const TextStyle(
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
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: BlurWidget(
                color: const Color.fromARGB(40, 0, 0, 0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ContextMenuBuilder(
                          menu: ContextMenuCard(
                            menuListBuilder: () {
                              return [
                                ContextMenuItem(
                                  label: S.current.copyUsername,
                                  icon: TablerIcons.at,
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "@${userData.username}@${userData.host}"));
                                    return false;
                                  },
                                ),
                                ContextMenuItem(
                                  label: S.current.copyRSS,
                                  icon: TablerIcons.rss,
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "${userData.host}/@${userData.username}.atom"));
                                    return false;
                                  },
                                ),
                                ContextMenuItem(
                                  label: S.current.openInNewTab,
                                  icon: TablerIcons.external_link,
                                  onTap: () {
                                    var url = userData.url ??
                                        "https://${userData.host}/@${userData.username}";
                                    launchUrlString(url);
                                    return false;
                                  },
                                ),
                                ContextMenuItem(
                                  label: S.current.copyUserHomeLink,
                                  icon: TablerIcons.home,
                                  onTap: () {
                                    var url = userData.url ??
                                        "https://${userData.host}/@${userData.username}";
                                    Clipboard.setData(ClipboardData(text: url));
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
                        _UserFollowButton(
                            userProvider: userProvider,
                            userData: userData,
                            themes: themes),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _UserFollowButton extends HookConsumerWidget {
  const _UserFollowButton({
    required this.userProvider,
    required this.userData,
    required this.themes,
  });

  final UserInfoProvider userProvider;
  final UserFullModel userData;
  final ThemeColorModel themes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
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
              color: userData.isFollowing ||
                      userData.hasPendingFollowRequestFromYou
                  ? themes.buttonGradateAColor
                  : Colors.white,
              border: Border.all(color: themes.buttonGradateAColor, width: 1)),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: [
            if (userData.hasPendingFollowRequestFromYou)
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    userData.isLocked
                        ? S.current.pendingFollowRequest
                        : S.current.processing,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (userData.isLocked)
                    const Icon(
                      TablerIcons.hourglass_empty,
                      color: Colors.white,
                      size: 15,
                    )
                  else
                    LoadingCircularProgress(
                      size: 12,
                      color: Colors.white,
                      strokeWidth: 2,
                      backgroundColor: Colors.white.withOpacity(0.5),
                    )
                ],
              )
            else
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    userData.isFollowing
                        ? S.current.unfollow
                        : S.current.follow,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: userData.isFollowing
                            ? Colors.white
                            : themes.buttonGradateAColor),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    userData.isFollowing ? TablerIcons.minus : TablerIcons.plus,
                    color: userData.isFollowing
                        ? Colors.white
                        : themes.buttonGradateAColor,
                    size: 15,
                  )
                ],
              )
          ][0],
        ),
      ),
    );
  }
}
