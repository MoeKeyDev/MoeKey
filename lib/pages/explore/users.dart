import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/user.dart';
import 'package:moekey/widgets/hover_builder.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../status/themes.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mfm_text/mfm_text.dart';
import '../../widgets/mk_header.dart';
import '../../widgets/mk_nav_button.dart';

part 'users.g.dart';

class ExploreUsersPage extends HookConsumerWidget {
  const ExploreUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var themes = ref.watch(themeColorsProvider);
    var select = useState(0);
    const navs = ["本地", "远程"];
    return Stack(
      children: [
        if (select.value == 0) const ExploreUsersLocal(),
        if (select.value == 1) const ExploreUsersNetwork(),
        Positioned(
          top: mediaPadding.top - 8,
          left: 0,
          right: 0,
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.zero),
            child: MkToolBar(
              height: 50,
              border: 0,
              // color: themes.bgColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MkNavButtonBar(
                  index: select.value,
                  onSelect: (index) => select.value = index,
                  navs: navs,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _UsersTitle extends HookConsumerWidget {
  const _UsersTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            icon,
            // TablerIcons.bookmark,
            size: 18,
            color: themes.fgColor,
          ),
          const SizedBox(
            width: 8,
          ),
          //const Text("置顶用户"),
          Text(title),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: SizedBox(
              height: 1,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(color: themes.dividerColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ExploreUsersLocal extends HookConsumerWidget {
  const ExploreUsersLocal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var padding = MediaQuery.paddingOf(context);
    var pinned = ref.watch(pinnedUsersProvider).valueOrNull;
    var hot = ref
        .watch(exploreUsersProvider(
          origins: "local",
          sorts: "+follower",
          states: "alive",
        ))
        .valueOrNull;
    var updated = ref
        .watch(exploreUsersProvider(
          origins: "local",
          sorts: "+updatedAt",
        ))
        .valueOrNull;
    var login = ref
        .watch(exploreUsersProvider(
          origins: "local",
          sorts: "+createdAt",
          states: "alive",
        ))
        .valueOrNull;
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = 1200;
        double paddingH =
            ((constraints.maxWidth - maxWidth) / 2).clamp(24, double.infinity);
        return CustomScrollView(
          cacheExtent: 2000,
          slivers: [
            SliverPadding(
              padding: padding.copyWith(
                  top: padding.top + 40, left: paddingH, right: paddingH),
              sliver: SliverMainAxisGroup(
                slivers: [
                  const SliverToBoxAdapter(
                    child: _UsersTitle(
                      icon: TablerIcons.bookmark,
                      title: "置顶用户",
                    ),
                  ),
                  if (pinned == null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(32),
                          color: Theme.of(context).primaryColor.withAlpha(200),
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: pinned![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: pinned?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350),
                  const SliverToBoxAdapter(
                    child: _UsersTitle(
                      icon: TablerIcons.chart_line,
                      title: "热门用户",
                    ),
                  ),
                  if (hot == null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(32),
                          color: Theme.of(context).primaryColor.withAlpha(200),
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: hot![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: hot?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350),
                  const SliverToBoxAdapter(
                    child: _UsersTitle(
                      icon: TablerIcons.message,
                      title: "最近投稿的用户",
                    ),
                  ),
                  if (updated == null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(32),
                          color: Theme.of(context).primaryColor.withAlpha(200),
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: updated![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: updated?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350),
                  const SliverToBoxAdapter(
                    child: _UsersTitle(
                      icon: TablerIcons.plus,
                      title: "最近登录的用户",
                    ),
                  ),
                  if (login == null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(32),
                          color: Theme.of(context).primaryColor.withAlpha(200),
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: login![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: login?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

@riverpod
Future<List<UserFullModel>> pinnedUsers(PinnedUsersRef ref) async {
  var apis = ref.watch(misskeyApisProvider);
  return apis.user.pinnedUsers();
}

@riverpod
Future<List<UserFullModel>> exploreUsers(
  ExploreUsersRef ref, {
  String? origins,
  String? sorts,
  String? states,
}) async {
  var apis = ref.watch(misskeyApisProvider);
  return apis.user.users(origin: origins, sort: sorts, state: states);
}

class UserFullCard extends HookConsumerWidget {
  const UserFullCard({
    super.key,
    required this.userFullModel,
  });

  final UserFullModel userFullModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var textStyle = DefaultTextStyle.of(context).style;
    return MkCard(
      padding: EdgeInsets.zero,
      shadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 84,
            color: const Color.fromARGB(26, 0, 0, 0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (userFullModel.bannerUrl != null)
                  Positioned.fill(
                    child: MkImage(
                      width: double.infinity,
                      height: 84,
                      userFullModel.bannerUrl!,
                      blurHash: userFullModel.avatarBlurhash,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (userFullModel.isFollowed)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(180, 0, 0, 0),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: const Text(
                        "正在关注你",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: UserFullCardFollowBtn(
                      userData: userFullModel, themes: themes),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: MkImage(
                      shape: BoxShape.circle,
                      userFullModel.avatarUrl ?? "",
                      blurHash: userFullModel.avatarBlurhash,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 88, top: 10, right: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: textStyle.copyWith(fontWeight: FontWeight.bold),
                  child: MFMText(
                    text: userFullModel.name ?? userFullModel.username,
                    after: [
                      const TextSpan(text: "\n"),
                      TextSpan(
                          text: "@${userFullModel.username ?? ""}",
                          style: textStyle.copyWith(
                            fontSize: 11,
                          )),
                      TextSpan(
                        text: userFullModel.host != null
                            ? "@${userFullModel.host}"
                            : "",
                        style: textStyle.copyWith(
                            color: themes.fgColor.withAlpha(128), fontSize: 11),
                      ),
                    ],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    emojis: userFullModel.emojis,
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
          Padding(
            padding: EdgeInsets.all(16),
            child: DefaultTextStyle(
              style: textStyle.copyWith(fontSize: 11),
              child: MFMText(
                text: userFullModel.description ?? "此用户尚无自我介绍",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                emojis: userFullModel.emojis,
                bigEmojiCode: false,
                feature: const [MFMFeature.emojiCode],
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
                    Text("${userFullModel.notesCount}",
                        style: TextStyle(
                            fontSize: 13,
                            color: themes.accentColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text("关注中", style: TextStyle(fontSize: 11)),
                    Text("${userFullModel.followingCount}",
                        style: TextStyle(
                            fontSize: 13,
                            color: themes.accentColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text("关注者", style: TextStyle(fontSize: 11)),
                    Text("${userFullModel.followersCount}",
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

class ExploreUsersNetwork extends HookConsumerWidget {
  const ExploreUsersNetwork({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var padding = MediaQuery.paddingOf(context);
    var hot = ref
        .watch(exploreUsersProvider(
          origins: "remote",
          sorts: "+follower",
          states: "alive",
        ))
        .valueOrNull;
    var updated = ref
        .watch(exploreUsersProvider(
          origins: "remote",
          sorts: "+updatedAt",
        ))
        .valueOrNull;
    var login = ref
        .watch(exploreUsersProvider(
          origins: "remote",
          sorts: "+createdAt",
          states: "alive",
        ))
        .valueOrNull;
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = 1200;
        double paddingH =
            ((constraints.maxWidth - maxWidth) / 2).clamp(24, double.infinity);
        return CustomScrollView(
          cacheExtent: 2000,
          slivers: [
            SliverPadding(
              padding: padding.copyWith(
                  top: padding.top + 40, left: paddingH, right: paddingH),
              sliver: SliverMainAxisGroup(
                slivers: [
                  const SliverToBoxAdapter(
                    child: _UsersTitle(
                      icon: TablerIcons.chart_line,
                      title: "热门用户",
                    ),
                  ),
                  if (hot == null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(32),
                          color: Theme.of(context).primaryColor.withAlpha(200),
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: hot![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: hot?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350),
                  const SliverToBoxAdapter(
                    child: _UsersTitle(
                      icon: TablerIcons.message,
                      title: "最近投稿的用户",
                    ),
                  ),
                  if (updated == null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(32),
                          color: Theme.of(context).primaryColor.withAlpha(200),
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: updated![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: updated?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350),
                  const SliverToBoxAdapter(
                    child: _UsersTitle(
                      icon: TablerIcons.plus,
                      title: "最近发现的用户",
                    ),
                  ),
                  if (login == null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(32),
                          color: Theme.of(context).primaryColor.withAlpha(200),
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: login![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: login?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
