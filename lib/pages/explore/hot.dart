import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../logger.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/mk_header.dart';
import '../../widgets/mk_nav_button.dart';

part 'hot.g.dart';

var navs = [S.current.notes, S.current.vote];

class ExploreHotPage extends HookConsumerWidget {
  const ExploreHotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var select = useState(0);

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
              hasMore: data.value?.hasMore,
              items: data.value?.list,
              initialLoading: data.isLoading && data.value == null,
              initialError: data.hasError && data.value == null
                  ? data.error
                  : null,
              onRetry: () => ref.invalidate(dataProvider),
              loadMoreError: data.value?.loadMoreError,
              onRetryLoadMore: () => ref.read(dataProvider.notifier).load(),
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
            ),
          ],
        );
      },
    );
  }
}

@riverpod
class ExploreHotPageStates extends _$ExploreHotPageStates {
  bool _isLoadingMore = false;

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

  Future<void> load() async {
    if (state.isLoading || _isLoadingMore) return;

    final model = state.value;
    if (model == null) return;

    _isLoadingMore = true;
    model.loadMoreError = null;
    ref.notifyListeners();
    try {
      final apis = ref.watch(misskeyApisProvider);
      final list = index == 1
          ? await apis.notes.pollsRecommendation(
              untilId: model.list.lastOrNull?.id,
            )
          : await apis.notes.featured(untilId: model.list.lastOrNull?.id);
      if (list.isEmpty) {
        model.hasMore = false;
      }
      model.list += list;
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      model.loadMoreError = error;
    } finally {
      _isLoadingMore = false;
      state = AsyncData(model);
      ref.notifyListeners();
    }
  }
}
