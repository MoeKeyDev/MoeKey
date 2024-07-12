import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:moekey/pages/clips/clips.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/widgets/clips/clips_create_dialog.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_modal.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../apis/models/clips.dart';
import '../../apis/models/note.dart';
import '../../status/themes.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mk_info_dialog.dart';
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
          header: buildMkAppbar(themes, showDate.value, context, ref),
          body: buildBody(
              ref, dataProvider, padding, showDate.value, themes, data.value));
    });
  }

  Builder buildBody(
      WidgetRef ref,
      ClipsNotesListProvider dataProvider,
      double padding,
      ClipsModel? showDate,
      ThemeColorModel themes,
      ClipsNoteListState? data) {
    return Builder(
      builder: (context) {
        return MkRefreshLoadList(
          padding: EdgeInsets.symmetric(horizontal: padding),
          onLoad: () => ref.read(dataProvider.notifier).load(),
          onRefresh: () => ref.refresh(dataProvider.future),
          hasMore: data?.haveMore,
          slivers: [
            if (showDate != null)
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
            SliverImplicitlyAnimatedList<NoteModel>(
              items: data?.list ?? [],
              itemBuilder: (BuildContext context, Animation<double> animation,
                  item, int i) {
                BorderRadius borderRadius =
                    const BorderRadius.all(Radius.circular(12));
                return SizeFadeTransition(
                  animation: animation,
                  axis: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: NoteCard(
                      key: ValueKey(item.id),
                      borderRadius: borderRadius,
                      data: item,
                      customContextmenu: [
                        ContextMenuItem(
                          danger: true,
                          label: "移除便签",
                          icon: TablerIcons.trash,
                          divider: true,
                          onTap: () {
                            var apis = ref.read(misskeyApisProvider);
                            apis.clips
                                .removeNote(clipId: clipId, noteId: item.id)
                                .then(
                              (value) {
                                ref.invalidate(dataProvider);
                              },
                            );
                            return false;
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
              areItemsTheSame: (oldItem, newItem) {
                return oldItem.id == newItem.id;
              },
            ),
          ],
        );
      },
    );
  }

  MkAppbar buildMkAppbar(ThemeColorModel themes, ClipsModel? showDate,
      BuildContext context, WidgetRef ref) {
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
              Text(showDate?.name ?? ""),
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
                showModel(
                  context: context,
                  builder: (context) {
                    return ClipCreateDialog(
                      clipId: clipId,
                    );
                  },
                );
              },
              tooltip: "编辑",
              icon: const Icon(TablerIcons.pencil, size: 18),
              color: themes.fgColor,
            ),
            IconButton(
              onPressed: () async {
                var res = await MkConfirm.show(children: [
                      Icon(
                        TablerIcons.alert_triangle,
                        size: 36,
                        color: themes.warnColor,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "要删掉「${showDate?.name ?? ""}」吗？",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ]) ??
                    false;
                if (res) {
                  var apis = ref.read(misskeyApisProvider);

                  await apis.clips.delete(clipId: clipId);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  ref.invalidate(clipsProvider);
                }
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
    var provider = clipsShowProvider(clipId);
    var showDate = ref.watch(provider);
    var themes = ref.watch(themeColorsProvider);
    if (showDate.value == null) {
      return const MkCard(child: SizedBox());
    }
    return MkCard(
      padding: EdgeInsets.zero,
      shadow: false,
      child: Column(
        children: [
          if (showDate.value != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: UserInfo(
                data: showDate.value!.user,
                suffix: Tooltip(
                  message: "添加到收藏",
                  child: IconButton(
                    onPressed: () async {
                      var apis = ref.read(misskeyApisProvider);
                      try {
                        if (showDate.value!.isFavorited) {
                          var res = await MkConfirm.show(children: [
                                Icon(
                                  TablerIcons.alert_triangle,
                                  size: 36,
                                  color: themes.warnColor,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                const Text(
                                  "确定要取消收藏吗？",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ]) ??
                              false;
                          if (res) {
                            await apis.clips.unFavorite(clipId: clipId);
                          }
                        } else {
                          await apis.clips.favorite(clipId: clipId);
                        }
                      } finally {
                        ref.invalidate(provider);
                      }
                    },
                    icon: Icon(
                      showDate.value!.isFavorited
                          ? TablerIcons.heart_filled
                          : TablerIcons.heart,
                      size: 20,
                      color: showDate.value!.isFavorited
                          ? const Color.fromARGB(255, 241, 97, 132)
                          : themes.fgColor,
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
