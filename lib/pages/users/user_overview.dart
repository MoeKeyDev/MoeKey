import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/networks/user.dart';
import 'package:moekey/state/themes.dart';
import 'package:moekey/utils/time_to_desired_format.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = 0;
        if (constraints.maxWidth > 860) {
          padding = (constraints.maxWidth - 800) / 2;
        } else if (constraints.maxWidth > 500) {
          padding = 30;
        } else if (constraints.maxWidth > 400) {
          padding = 8;
        } else {
          padding = 0;
        }
        var dataProvider = userNotesListProvider(userId);
        var data = ref.watch(dataProvider);
        var themes = ref.watch(themeColorsProvider);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: MediaQuery.paddingOf(context)
                  .copyWith(left: padding, right: padding),
              sliver: SliverMainAxisGroup(
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
                  const SliverPadding(padding: EdgeInsets.only(top: 10)),
                  SliverList.separated(
                    addAutomaticKeepAlives: true,
                    itemBuilder: (BuildContext context, int index) {
                      BorderRadius borderRadius;
                      if (index == 0) {
                        borderRadius = const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12));
                      } else {
                        borderRadius = const BorderRadius.all(Radius.zero);
                      }
                      return NoteCard(
                          key: ValueKey(data.valueOrNull!.list[index].id),
                          borderRadius: borderRadius,
                          data: data.valueOrNull!.list[index]);
                      // return KeepAliveWrapper(
                      //     child: TimelineCardComponent(
                      //   data: data.valueOrNull![index],
                      //   borderRadius: borderRadius,
                      // ));
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
                    itemCount: data.valueOrNull?.list.length ?? 0,
                  ),
                  SliverLayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.remainingPaintExtent > 0 &&
                          (data.valueOrNull?.hasMore ?? false)) {
                        ref.read(dataProvider.notifier).load();
                      }
                      if (!(data.valueOrNull?.hasMore ?? true)) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text("暂无更多"),
                            ),
                          ),
                        );
                      }
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: LoadingCircularProgress(),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        );
      },
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
    var user = ref.watch(userInfoProvider(userId: userId));
    var userData = user.valueOrNull;
    var themes = ref.watch(themeColorsProvider);
    if (userData != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          var isSmall = constraints.maxWidth < 500;
          return SelectionArea(
              child: ClipRRect(
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
                            child: Parallax(
                              offset: offset,
                              child: MkImage(
                                fit: BoxFit.cover,
                                userData.bannerUrl ?? "",
                                blurHash: userData.bannerBlurhash,
                                width: double.infinity,
                              ),
                            ),
                          ),
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
                                  DefaultTextStyle(
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                            fontSize: 15, color: Colors.white),
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
                                  )
                                ],
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
                          )
                        ],
                      ),
                    )
                  else if (userData.description != null)
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
                                    text: userData.description!,
                                    bigEmojiCode: false,
                                    emojis: userData.emojis,
                                    currentServerHost: userData.host,
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
                    if (userData.description != null)
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
                                  text: userData.description!,
                                  bigEmojiCode: false,
                                  emojis: userData.emojis,
                                  textAlign: TextAlign.center,
                                  currentServerHost: userData.host,
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
          ));
        },
      );
    }
    return const SizedBox();
  }
}
