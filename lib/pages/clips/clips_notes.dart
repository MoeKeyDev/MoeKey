import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/networks/clips/clips.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../router/main_router_delegate.dart';
import '../../state/themes.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/notes/note_card.dart';

class ClipsNotes extends HookConsumerWidget {
  final String clipId;

  const ClipsNotes(this.clipId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var dataProvider = clipsNotesListProvider(clipId);
    var data = ref.watch(dataProvider);
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
                    Text("富文本"),
                  ],
                ),
              ),
              bottom: Tab(
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
              return CustomScrollView(
                // controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(padding, mediaPadding.top,
                        padding, mediaPadding.bottom),
                    sliver: SliverMainAxisGroup(
                      slivers: [
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
              );
            },
          ));
    });
  }
}
