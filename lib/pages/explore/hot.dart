import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/themes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mk_header.dart';
import '../../widgets/mk_nav_button.dart';
import '../../widgets/notes/note_card.dart';

part 'hot.g.dart';

class ExploreHotPage extends HookConsumerWidget {
  const ExploreHotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var themes = ref.watch(themeColorsProvider);
    var select = useState(0);
    const navs = ["帖子", "投票"];
    var dataProvider = exploreHotPageStatesProvider(select.value);
    var data = ref.watch(dataProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = getPaddingForNote(constraints);
        return Stack(
          children: [
            RefreshIndicator.adaptive(
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
                  cacheExtent:
                      (Platform.isAndroid || Platform.isIOS) ? null : 4000,
                  slivers: [
                    SliverPadding(
                      padding: MediaQuery.paddingOf(context)
                          .copyWith(left: padding, right: padding),
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          const SliverPadding(
                              padding: EdgeInsets.only(top: 40)),
                          SliverList.separated(
                            addAutomaticKeepAlives: true,
                            itemBuilder: (BuildContext context, int index) {
                              BorderRadius borderRadius;
                              if (index == 0) {
                                borderRadius = const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12));
                              } else {
                                borderRadius =
                                    const BorderRadius.all(Radius.zero);
                              }
                              return NoteCard(
                                  key: ValueKey(
                                      data.valueOrNull!.list[index].id),
                                  borderRadius: borderRadius,
                                  data: data.valueOrNull!.list[index]);
                              // return KeepAliveWrapper(
                              //     child: TimelineCardComponent(
                              //   data: data.valueOrNull![index],
                              //   borderRadius: borderRadius,
                              // ));
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
                            itemCount: (data.valueOrNull?.list.length ?? 0),
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
                ),
              ),
            ),
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
                    padding: EdgeInsets.symmetric(horizontal: padding),
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
      },
    );
  }
}

class _NoteListsModel {
  List<NoteModel> list = [];
  bool hasMore = true;
}

@riverpod
class ExploreHotPageStates extends _$ExploreHotPageStates {
  @override
  FutureOr<_NoteListsModel> build(int index) async {
    var apis = ref.watch(misskeyApisProvider);

    var model = _NoteListsModel();
    if (index == 1) {
      model.list = await apis.notes.pollsRecommendation();
    } else {
      model.list = await apis.notes.featured();
    }

    return model;
  }

  load() async {
    var model = state.value ?? _NoteListsModel();
    var apis = ref.watch(misskeyApisProvider);
    List<NoteModel> list = [];
    if (index == 1) {
      list = await apis.notes
          .pollsRecommendation(untilId: model.list.lastOrNull?.id);
    } else {
      list = await apis.notes.featured(untilId: model.list.lastOrNull?.id);
    }
    if (list.isEmpty) {
      model.hasMore = false;
    }
    model.list += list;
    state = AsyncData(model);
  }
}
