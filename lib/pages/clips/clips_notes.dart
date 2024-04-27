import 'dart:ui';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/networks/clips/clips.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../router/main_router_delegate.dart';
import '../../state/themes.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/notes/note_card.dart';

class ClipsNotes extends HookConsumerWidget {
  final String clipId;

  const ClipsNotes(this.clipId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var dataProvider = clipsNotesListProvider(clipId);
    var data = ref.watch(dataProvider);
    var showDate = ref.watch(ClipsShowProvider(clipId));
    return LayoutBuilder(builder: (context, constraints) {
      var padding = getPaddingForNote(constraints);

      return MkScaffold(
          header: MkAppbar(
              showBack: true,
              isSmallLeadingCenter: false,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      TablerIcons.paperclip,
                      size: 18,
                      color: themes.fgColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text("富文本"),
                  ],
                ),
              ),
              bottom: const Tab(
                child: SizedBox(),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      MainRouterDelegate.of(context).popRoute();
                    },
                    tooltip: "编辑",
                    icon: const Icon(TablerIcons.pencil, size: 18),
                    color: themes.fgColor,
                  ),
                  IconButton(
                    onPressed: () {
                      MainRouterDelegate.of(context).popRoute();
                    },
                    tooltip: "删除",
                    icon: const Icon(TablerIcons.trash, size: 18),
                    color: themes.fgColor,
                  )
                ],
              )),
          body: Builder(
            builder: (context) {
              var mediaPadding = MediaQuery.paddingOf(context);
              return RefreshIndicator.adaptive(
                // 通知刷新指示器
                onRefresh: () => ref.refresh(dataProvider.future),
                edgeOffset: mediaPadding.top,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: CustomScrollView(
                    // controller: scrollController,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(padding, mediaPadding.top,
                            padding, mediaPadding.bottom),
                        sliver: SliverMainAxisGroup(
                          slivers: [
                            SliverToBoxAdapter(
                              child: MkCard(
                                shadow: false,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(showDate.valueOrNull?.name ??
                                            "没有获取到标题"),
                                        IconButton(
                                            onPressed: () => {
                                                  // Toast提示
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text('已添加到收藏夹'),
                                                  ))
                                                },
                                            icon: const Icon(TablerIcons.heart))
                                      ],
                                    ),
                                    // 添加分割线
                                    Divider(
                                      height: 1,
                                      color: themes.dividerColor,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        badges.Badge(
                                          badgeContent: Tooltip(
                                            message: showDate.valueOrNull?.user
                                                        .onlineStatus ==
                                                    "online"
                                                ? "在线"
                                                : "离线",
                                            child: Container(
                                              width: 10.0,
                                              height: 10.0,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 88, 212, 201),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                            ),
                                          ),
                                          badgeStyle: badges.BadgeStyle(
                                              badgeColor: themes.panelColor,
                                              padding: const EdgeInsets.all(3)),
                                          position:
                                              badges.BadgePosition.bottomStart(
                                                  start: 1),
                                          child: MkImage(
                                            width: 40,
                                            height: 40,
                                            showDate.valueOrNull?.user
                                                    .avatarUrl ??
                                                "",
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 10,
                              ),
                            ),
                            SliverList.separated(
                              addAutomaticKeepAlives: true,
                              itemBuilder: (BuildContext context, int index) {
                                BorderRadius borderRadius =
                                    const BorderRadius.all(Radius.circular(12));
                                return NoteCard(
                                    key: ValueKey(
                                        data.valueOrNull!.list[index].id),
                                    borderRadius: borderRadius,
                                    data: data.valueOrNull!.list[index]);

                                // return KeepAliveWrapper(
                                //   child: NoteCard(
                                //     key: ValueKey(data.valueOrNull![index].id),
                                //     borderRadius: borderRadius,
                                //     data: data.valueOrNull![index],
                                //   ),
                                // );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  width: double.infinity,
                                  height: 10,
                                );
                              },
                              itemCount: data.valueOrNull?.list.length ?? 0,
                            ),
                            SliverLayoutBuilder(
                              builder: (context, constraints) {
                                if (data.valueOrNull?.haveMore ?? true) {
                                  if (constraints.remainingPaintExtent > 0) {
                                    ref.read(dataProvider.notifier).load();
                                  }
                                  return const SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: LoadingCircularProgress(),
                                      ),
                                    ),
                                  );
                                }
                                return const SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 16,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ));
    });
  }
}
