import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import '../../widgets/mk_parallax.dart';
import '../../widgets/mk_refresh_load.dart';
import '../../widgets/mk_user_avatar.dart';
import '../../widgets/notes/note_card.dart';
import 'user_files.dart';

class UserOverview extends HookConsumerWidget {
  const UserOverview({super.key, required this.userId, this.onShowMoreFiles});

  final String userId;
  final VoidCallback? onShowMoreFiles;

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
    var userPinNote = user.value?.pinnedNotes ?? [];
    var themes = ref.watch(themeColorsProvider);
    var data = ref.watch(dataProvider);
    final timeline = MkPaginationNoteList(
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
                data: userPinNote[index],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: double.infinity,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: themes.dividerColor),
              ),
            );
          },
          itemCount: userPinNote.length,
        ),
        SliverToBoxAdapter(
          child: Padding(padding: const EdgeInsets.only(bottom: 8.0)),
        ),
      ],
      hasMore: data.value?.hasMore ?? true,
      items: data.value?.list,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1024) {
          return timeline;
        }
        const sidebarWidth = 320.0;
        const columnGap = 16.0;
        const maxContentWidth = 1100.0;
        final contentWidth = constraints.maxWidth
            .clamp(0, maxContentWidth)
            .toDouble();
        final sidePadding = (constraints.maxWidth - contentWidth) / 2;

        return MkRefreshLoadList(
          onLoad: () => ref.read(dataProvider.notifier).load(),
          onRefresh: () => ref.refresh(dataProvider.future),
          hasMore: data.value?.hasMore ?? true,
          empty: false,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              sliver: SliverCrossAxisGroup(
                slivers: [
                  SliverCrossAxisExpanded(
                    flex: 1,
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: UserHomeCard(userId: userId),
                          ),
                        ),
                        if (userPinNote.isNotEmpty)
                          SliverList.separated(
                            itemBuilder: (BuildContext context, int index) {
                              BorderRadius borderRadius =
                                  const BorderRadius.all(Radius.zero);
                              if (index == 0) {
                                borderRadius = borderRadius.copyWith(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                );
                              }
                              if (index + 1 == userPinNote.length) {
                                borderRadius = borderRadius.copyWith(
                                  bottomLeft: const Radius.circular(12),
                                  bottomRight: const Radius.circular(12),
                                );
                              }
                              return RepaintBoundary(
                                child: NoteCard(
                                  key: ValueKey(userPinNote[index].id),
                                  borderRadius: borderRadius,
                                  pined: true,
                                  data: userPinNote[index],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
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
                        if (userPinNote.isNotEmpty)
                          const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverList.separated(
                          itemBuilder: (BuildContext context, int index) {
                            BorderRadius borderRadius = const BorderRadius.all(
                              Radius.zero,
                            );
                            final items = data.value?.list ?? const [];
                            if (index == 0) {
                              borderRadius = borderRadius.copyWith(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                              );
                            }
                            if (index + 1 == items.length) {
                              borderRadius = borderRadius.copyWith(
                                bottomLeft: const Radius.circular(12),
                                bottomRight: const Radius.circular(12),
                              );
                            }
                            return RepaintBoundary(
                              child: NoteCard(
                                key: ValueKey(items[index].id),
                                borderRadius: borderRadius,
                                data: items[index],
                              ),
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
                          itemCount: data.value?.list.length ?? 0,
                        ),
                      ],
                    ),
                  ),
                  SliverConstrainedCrossAxis(
                    maxExtent: columnGap,
                    sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
                  ),
                  SliverConstrainedCrossAxis(
                    maxExtent: sidebarWidth,
                    sliver: SliverToBoxAdapter(
                      child: _UserMediaGrid(
                        userId: userId,
                        onShowMore: onShowMoreFiles,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UserMediaGrid extends ConsumerWidget {
  const _UserMediaGrid({required this.userId, this.onShowMore});

  final String userId;
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(userRecentMediaFilesProvider(userId));
    final themes = ref.watch(themeColorsProvider);
    final media = files.value ?? const <UserMediaFile>[];
    if (files.hasError || (!files.isLoading && media.isEmpty)) {
      return const SizedBox.shrink();
    }

    return MkCard(
      key: const ValueKey('user-media-grid'),
      shadow: false,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                const Icon(TablerIcons.photo, size: 17),
                const SizedBox(width: 8),
                Text(
                  S.current.files,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 1,
            child: ColoredBox(color: themes.dividerColor),
          ),
          const SizedBox(height: 4),
          if (files.isLoading)
            const SizedBox(
              height: 180,
              child: Center(child: LoadingCircularProgress(size: 24)),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                key: const ValueKey('user-media-grid-items'),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: media.length,
                itemBuilder: (context, index) {
                  return UserMediaTile(media: media[index]);
                },
              ),
            ),
          if (!files.isLoading && onShowMore != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  key: const ValueKey('user-media-grid-show-more'),
                  onPressed: onShowMore,
                  icon: const Icon(TablerIcons.arrow_right, size: 17),
                  iconAlignment: IconAlignment.end,
                  label: Text(S.current.viewMore),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class UserHomeCard extends HookConsumerWidget {
  const UserHomeCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProvider = userInfoProvider(userId: userId);
    var user = ref.watch(userProvider);
    var currentUser = ref.watch(currentLoginUserProvider);
    var userData = user.value;
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
                    userProvider: userProvider,
                  ),
                  SizedBox(height: isSmall ? 40 : 0),
                  if (isSmall) _UserNames(userData: userData),
                  if (!isSmall) _UserDescription(userData: userData),
                  Container(height: 1, color: themes.dividerColor),
                  if (isSmall) ...[
                    _UserDescriptionSmall(userData: userData),
                    Container(height: 1, color: themes.dividerColor),
                  ],
                  _UserRegisterTime(themes: themes, userData: userData),
                  if (userData.fields.isNotEmpty) ...[
                    Container(height: 1, color: themes.dividerColor),
                    _UserFields(userData: userData),
                  ],
                  Container(height: 1, color: themes.dividerColor),
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
  const _UserFollowsCount({required this.userData});

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
              Text(
                "${userData.notesCount}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(S.current.notes, style: TextStyle(fontSize: 12)),
            ],
          ),
          if (userData.followingVisibility == null ||
              userData.followingVisibility == FollowVisibility.public ||
              (userData.followingVisibility == FollowVisibility.followers &&
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
                    Text(
                      "${userData.followingCount}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(S.current.following, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          if (userData.followersVisibility == null ||
              userData.followersVisibility == FollowVisibility.public ||
              (userData.followersVisibility == FollowVisibility.followers &&
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
                    Text(
                      "${userData.followersCount}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(S.current.followers, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UserFields extends StatelessWidget {
  const _UserFields({required this.userData});

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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: MFMText(
                        text: item["value"],
                        bigEmojiCode: false,
                        currentServerHost: userData.host,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UserRegisterTime extends StatelessWidget {
  const _UserRegisterTime({required this.themes, required this.userData});

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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(timeToDesiredFormat(userData.createdAt)),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDescriptionSmall extends StatelessWidget {
  const _UserDescriptionSmall({required this.userData});

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
  const _UserDescription({required this.userData});

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
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(fontSize: 13),
                  child: MFMText(
                    text:
                        userData.description ?? S.current.userDescriptionIsNull,
                    bigEmojiCode: false,
                    emojis: userData.emojis,
                    currentServerHost: userData.host,
                    isSelection: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UserNames extends StatelessWidget {
  const _UserNames({required this.userData});

  final UserFullModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Builder(
              builder: (context) {
                return DefaultTextStyle(
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(fontWeight: FontWeight.bold),
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
              },
            ),
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
                        Clipboard.setData(
                          ClipboardData(
                            text: "@${userData.username}@${userData.host}",
                          ),
                        );
                        return false;
                      },
                    ),
                  ];
                },
              ),
              mode: const [
                ContextMenuMode.onSecondaryTap,
                ContextMenuMode.onSecondaryTap,
              ],
              child: DefaultTextStyle(
                style: DefaultTextStyle.of(
                  context,
                ).style.copyWith(fontSize: 13),
                child: Opacity(
                  opacity: 0.7,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "@${userData.username}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 65, 81, 94),
                ),
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
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
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
                  border: Border.all(color: themes.panelColor, width: 8),
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  color: themes.panelColor,
                  boxShadow: [
                    if (!isSmall)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                  ],
                ),
                height: isSmall ? 120 : 160,
                width: isSmall ? 120 : 160,
                child: Center(
                  child: MkUserAvatar(
                    size: isSmall ? 104 : 144,
                    avatarUrl: userData.avatarUrl,
                    avatarBlurhash: userData.avatarBlurhash,
                    onlineStatus: userData.onlineStatus,
                    statusIndicatorSize: isSmall ? 20 : 22,
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
                        fontSize: 24,
                      ),
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
                                Clipboard.setData(
                                  ClipboardData(
                                    text:
                                        "@${userData.username}@${userData.host}",
                                  ),
                                );
                                return false;
                              },
                            ),
                          ];
                        },
                      ),
                      mode: const [
                        ContextMenuMode.onSecondaryTap,
                        ContextMenuMode.onSecondaryTap,
                      ],
                      child: DefaultTextStyle(
                        style: DefaultTextStyle.of(
                          context,
                        ).style.copyWith(fontSize: 15, color: Colors.white),
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
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  S.current.isFollowingYouNow,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
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
                                    Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            "@${userData.username}@${userData.host}",
                                      ),
                                    );
                                    return false;
                                  },
                                ),
                                ContextMenuItem(
                                  label: S.current.copyRSS,
                                  icon: TablerIcons.rss,
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            "${userData.host}/@${userData.username}.atom",
                                      ),
                                    );
                                    return false;
                                  },
                                ),
                                ContextMenuItem(
                                  label: S.current.openInNewTab,
                                  icon: TablerIcons.external_link,
                                  onTap: () {
                                    var url =
                                        userData.url ??
                                        "https://${userData.host}/@${userData.username}";
                                    launchUrlString(url);
                                    return false;
                                  },
                                ),
                                ContextMenuItem(
                                  label: S.current.copyUserHomeLink,
                                  icon: TablerIcons.home,
                                  onTap: () {
                                    var url =
                                        userData.url ??
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
                            ContextMenuMode.onSecondaryTap,
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),
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
                          themes: themes,
                        ),
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
    final isSubmitting = useState(false);

    Future<void> toggleFollow() async {
      if (isSubmitting.value) {
        return;
      }
      isSubmitting.value = true;
      try {
        final notifier = ref.read(userProvider.notifier);
        if (userData.hasPendingFollowRequestFromYou) {
          await notifier.followingCancel();
        } else if (userData.isFollowing) {
          await notifier.followingDelete();
        } else {
          await notifier.followingCreate();
        }
      } catch (error, stackTrace) {
        debugPrint('Failed to update following state: $error');
        debugPrintStack(stackTrace: stackTrace);
      } finally {
        if (context.mounted) {
          isSubmitting.value = false;
        }
      }
    }

    return MouseRegion(
      cursor: isSubmitting.value
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isSubmitting.value ? null : toggleFollow,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            color:
                isSubmitting.value ||
                    userData.isFollowing ||
                    userData.hasPendingFollowRequestFromYou
                ? themes.buttonGradateAColor
                : Colors.white,
            border: Border.all(color: themes.buttonGradateAColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: [
            if (isSubmitting.value)
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    S.current.processing,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  LoadingCircularProgress(
                    size: 12,
                    color: Colors.white,
                    strokeWidth: 2,
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
                  ),
                ],
              )
            else if (userData.hasPendingFollowRequestFromYou)
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
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
                    ),
                ],
              )
            else
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    userData.isFollowing
                        ? S.current.unfollow
                        : userData.isLocked
                        ? S.current.requestFollow
                        : S.current.follow,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: userData.isFollowing
                          ? Colors.white
                          : themes.buttonGradateAColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    userData.isFollowing ? TablerIcons.minus : TablerIcons.plus,
                    color: userData.isFollowing
                        ? Colors.white
                        : themes.buttonGradateAColor,
                    size: 15,
                  ),
                ],
              ),
          ][0],
        ),
      ),
    );
  }
}
