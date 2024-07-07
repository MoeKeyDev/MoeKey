import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils/get_padding_note.dart';
import '../../widgets/mk_header.dart';
import '../../widgets/mk_nav_button.dart';

part 'hot.g.dart';

class ExploreHotPage extends HookConsumerWidget {
  const ExploreHotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var select = useState(0);
    const navs = ["帖子", "投票"];
    var dataProvider = exploreHotPageStatesProvider(select.value);
    var data = ref.watch(dataProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = getPaddingForNote(constraints);
        return Stack(
          children: [
            MkPaginationNoteList(
              padding: const EdgeInsets.only(top: 50),
              onLoad: () => ref.read(dataProvider.notifier).load(),
              onRefresh: () => ref.refresh(dataProvider.future),
              hasMore: data.valueOrNull?.hasMore,
              items: data.valueOrNull?.list,
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

@riverpod
class ExploreHotPageStates extends _$ExploreHotPageStates {
  @override
  FutureOr<NoteListModel> build(int index) async {
    var apis = ref.watch(misskeyApisProvider);

    var model = NoteListModel();
    if (index == 1) {
      model.list = await apis.notes.pollsRecommendation();
    } else {
      model.list = await apis.notes.featured();
    }

    return model;
  }

  load() async {
    var model = state.value ?? NoteListModel();
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
