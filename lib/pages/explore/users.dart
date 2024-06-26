import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                        return MkUserCard(user: pinned![index]);
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
                        return MkUserCard(user: hot![index]);
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
                        return MkUserCard(user: updated![index]);
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
                        return MkUserCard(user: login![index]);
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
                        return MkUserCard(user: hot![index]);
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
                        return MkUserCard(user: updated![index]);
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
                        return MkUserCard(user: login![index]);
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
