import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/widgets/hover_builder.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';

import '../../status/themes.dart';
import '../../widgets/mk_header.dart';
import '../../widgets/mk_nav_button.dart';

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
  const _UsersTitle({super.key});

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
            TablerIcons.bookmark,
            size: 18,
            color: themes.fgColor,
          ),
          const SizedBox(
            width: 8,
          ),
          const Text("置顶用户"),
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
    var apis = ref.watch(misskeyApisProvider);
    var padding = MediaQuery.paddingOf(context);
    print(padding);
    var pinned = useFuture(apis.user.pinnedUsers());
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = 1200;
        double paddingH =
            ((constraints.maxWidth - maxWidth) / 2).clamp(24, double.infinity);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: padding.copyWith(
                  top: padding.top + 50, left: paddingH, right: paddingH),
              sliver: SliverMainAxisGroup(
                slivers: [
                  const SliverToBoxAdapter(
                    child: _UsersTitle(),
                  ),
                  SliverAlignedGrid.extent(
                      itemBuilder: (context, index) {
                        return UserFullCard(userFullModel: pinned.data![index]);
                      },
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      addRepaintBoundaries: true,
                      itemCount: pinned.data?.length ?? 0,
                      maxCrossAxisExtent:
                          constraints.maxWidth < 580 ? 600 : 350)
                ],
              ),
            )
          ],
        );
      },
    );
  }
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
    return MkCard(
      padding: EdgeInsets.zero,
      shadow: false,
      child: Column(
        children: [
          if (userFullModel.bannerUrl != null)
            Container(
              height: 84,
              color: const Color.fromARGB(26, 0, 0, 0),
              child: Stack(
                children: [
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
                    child: HoverBuilder(
                      builder: (context, isHover) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isHover
                                  ? themes.accentLightenColor
                                  : themes.accentColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Icon(
                              size: 20,
                              TablerIcons.minus,
                              color: themes.fgOnAccentColor,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

class ExploreUsersNetwork extends HookConsumerWidget {
  const ExploreUsersNetwork({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder();
  }
}
