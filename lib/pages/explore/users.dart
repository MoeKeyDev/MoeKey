import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../status/themes.dart';
import '../../widgets/mk_header.dart';
import '../../widgets/mk_nav_button.dart';
import '../../widgets/mk_user_card.dart';

part 'users.g.dart';

final navs = ["本地", "远程"];

class ExploreUsersPage extends HookConsumerWidget {
  const ExploreUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var select = useState(0);

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

    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = 1200;
        double paddingH =
            ((constraints.maxWidth - maxWidth) / 2).clamp(24, double.infinity);
        double maxCrossAxisExtent = constraints.maxWidth < 580 ? 600 : 350;
        return CustomScrollView(
          primary: true,
          cacheExtent: 2000,
          slivers: [
            SliverPadding(
              padding: padding.copyWith(
                  top: padding.top + 40, left: paddingH, right: paddingH),
              sliver: SliverMainAxisGroup(
                slivers: [
                  _UserPinGrid(maxCrossAxisExtent: maxCrossAxisExtent),
                  _UserExplore(
                    maxCrossAxisExtent: maxCrossAxisExtent,
                    title: '热门用户',
                    icon: TablerIcons.chart_line,
                    origins: "local",
                    sorts: "+follower",
                    states: "alive",
                  ),
                  _UserExplore(
                    maxCrossAxisExtent: maxCrossAxisExtent,
                    title: '最近投稿的用户',
                    icon: TablerIcons.message,
                    origins: "local",
                    sorts: "+updatedAt",
                  ),
                  _UserExplore(
                    maxCrossAxisExtent: maxCrossAxisExtent,
                    title: '最近登录的用户',
                    icon: TablerIcons.plus,
                    origins: "local",
                    sorts: "+createdAt",
                    states: "alive",
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class _UserExplore extends HookConsumerWidget {
  const _UserExplore({
    super.key,
    required this.maxCrossAxisExtent,
    this.origins,
    this.sorts,
    this.states,
    required this.title,
    required this.icon,
  });

  final double maxCrossAxisExtent;
  final String? origins;
  final String? sorts;
  final String? states;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var hot = ref
        .watch(exploreUsersProvider(
          origins: origins,
          sorts: sorts,
          states: states,
        ))
        .valueOrNull;
    return SliverMainAxisGroup(slivers: [
      SliverToBoxAdapter(
        child: _UsersTitle(
          icon: icon,
          title: title,
        ),
      ),
      if (hot == null)
        SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              backgroundColor: Theme.of(context).primaryColor.withAlpha(32),
              color: Theme.of(context).primaryColor.withAlpha(200),
              strokeWidth: 6,
            ),
          ),
        ),
      SliverGrid.builder(
        itemBuilder: (context, index) {
          return MkUserCard(user: hot![index]);
        },

        itemCount: hot?.length ?? 0,
        // maxCrossAxisExtent: maxCrossAxisExtent,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 300),
      ),
    ]);
  }
}

class _UserPinGrid extends HookConsumerWidget {
  final double maxCrossAxisExtent;

  const _UserPinGrid({super.key, required this.maxCrossAxisExtent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pinned = ref.watch(pinnedUsersProvider).valueOrNull;
    return SliverMainAxisGroup(slivers: [
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
              backgroundColor: Theme.of(context).primaryColor.withAlpha(32),
              color: Theme.of(context).primaryColor.withAlpha(200),
              strokeWidth: 6,
            ),
          ),
        ),
      SliverGrid.builder(
        itemBuilder: (context, index) {
          return MkUserCard(user: pinned![index]);
        },

        itemCount: pinned?.length ?? 0,
        // maxCrossAxisExtent: maxCrossAxisExtent,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 300),
      )
    ]);
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

class ExploreUsersNetwork extends HookConsumerWidget {
  const ExploreUsersNetwork({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var padding = MediaQuery.paddingOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = 1200;
        double paddingH =
            ((constraints.maxWidth - maxWidth) / 2).clamp(24, double.infinity);
        double maxCrossAxisExtent = constraints.maxWidth < 580 ? 600 : 350;
        return CustomScrollView(
          primary: true,
          cacheExtent: 2000,
          slivers: [
            SliverPadding(
              padding: padding.copyWith(
                  top: padding.top + 40, left: paddingH, right: paddingH),
              sliver: SliverMainAxisGroup(
                slivers: [
                  _UserExplore(
                    maxCrossAxisExtent: maxCrossAxisExtent,
                    title: '热门用户',
                    icon: TablerIcons.chart_line,
                    origins: "remote",
                    sorts: "+follower",
                    states: "alive",
                  ),
                  _UserExplore(
                    maxCrossAxisExtent: maxCrossAxisExtent,
                    title: '最近投稿的用户',
                    icon: TablerIcons.message,
                    origins: "remote",
                    sorts: "+updatedAt",
                  ),
                  _UserExplore(
                    maxCrossAxisExtent: maxCrossAxisExtent,
                    title: '最近登录的用户',
                    icon: TablerIcons.plus,
                    origins: "remote",
                    sorts: "+createdAt",
                    states: "alive",
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
