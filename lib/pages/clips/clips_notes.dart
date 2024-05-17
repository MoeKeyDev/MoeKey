import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/clips/clips.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../apis/models/clips.dart';
import '../../router/main_router_delegate.dart';
import '../../status/themes.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/notes/note_card.dart';
import '../notes/note_page.dart';

class ClipsNotes extends HookConsumerWidget {
  final String clipId;

  const ClipsNotes(this.clipId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var dataProvider = clipsNotesListProvider(clipId);
    var data = ref.watch(dataProvider);
    var showDate = ref.watch(clipsShowProvider(clipId));
    return LayoutBuilder(builder: (context, constraints) {
      var padding = getPaddingForNote(constraints);

      return MkScaffold(
          header: buildMkAppbar(themes, showDate, context),
          body: buildBody(ref, dataProvider, padding, showDate, themes, data));
    });
  }

  Builder buildBody(
      WidgetRef ref,
      ClipsNotesListProvider dataProvider,
      double padding,
      AsyncValue<ClipsModel> showDate,
      ThemeColorModel themes,
      AsyncValue<ClipsNoteListState> data) {
    return Builder(
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
                  padding: EdgeInsets.fromLTRB(
                      padding, mediaPadding.top, padding, mediaPadding.bottom),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      if (showDate.valueOrNull != null)
                        SliverToBoxAdapter(
                          child: _ClipContentCard(
                            clipId: clipId,
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
                              key: ValueKey(data.valueOrNull!.list[index].id),
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
                        separatorBuilder: (BuildContext context, int index) {
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
    );
  }

  MkAppbar buildMkAppbar(ThemeColorModel themes,
      AsyncValue<ClipsModel> showDate, BuildContext context) {
    return MkAppbar(
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
              Text(showDate.valueOrNull?.name ?? ""),
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
        ));
  }
}

class _ClipContentCard extends HookConsumerWidget {
  const _ClipContentCard({super.key, required this.clipId});

  final String clipId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var showDate = ref.watch(clipsShowProvider(clipId));
    var themes = ref.watch(themeColorsProvider);
    if (showDate.value == null) {
      return const MkCard(child: SizedBox());
    }
    return MkCard(
      padding: EdgeInsets.zero,
      shadow: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: UserInfo(
              data: showDate.value!.user,
              suffix: Tooltip(
                message: "添加到收藏",
                child: IconButton(
                  onPressed: () => {
                    // Toast提示
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //   content: Text('已添加到收藏夹'),
                    // ))
                  },
                  icon: Icon(
                    TablerIcons.heart,
                    size: 20,
                    color: themes.fgColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MFMText(
                  text: showDate.valueOrNull?.description ?? "",
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
