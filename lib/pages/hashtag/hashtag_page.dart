import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/hook/use_mk_refresh_load_list_controller.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../status/misskey_api.dart';
import '../../logger.dart';

part 'hashtag_page.g.dart';

class HashtagPage extends HookConsumerWidget {
  const HashtagPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = hashTagPageProvider(name);
    var state = ref.watch(model);
    var data = state.value;
    var controller = useMkRefreshLoadListController();
    return MkScaffold(
      header: MkAppbar(
        showBack: true,
        content: GestureDetector(
          onTap: () {
            controller.refresh();
          },
          child: Text("#$name", maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
      body: Center(
        child: MkPaginationNoteList(
          onLoad: () => ref.read(model.notifier).load(),
          onRefresh: () => ref.refresh(model.future),
          hasMore: data?.hasMore ?? true,
          items: data?.list,
          controller: controller,
          initialLoading: state.isLoading && data == null,
          initialError: state.hasError && data == null ? state.error : null,
          onRetry: () => ref.invalidate(model),
          loadMoreError: data?.loadMoreError,
          onRetryLoadMore: () => ref.read(model.notifier).load(),
        ),
      ),
    );
  }
}

@riverpod
class HashTagPage extends _$HashTagPage {
  bool _isLoadingMore = false;

  @override
  FutureOr<NoteListModel> build(String tag) async {
    var model = NoteListModel();
    model.list = await notes();
    return model;
  }

  Future<List<NoteModel>> notes({String? untilId}) async {
    var apis = ref.read(misskeyApisProvider);
    var list = await apis.notes.searchByTag(tag: tag, untilId: untilId);
    return list;
  }

  Future<void> load() async {
    if (state.isLoading || _isLoadingMore) return;
    final model = state.value;
    if (model == null) return;

    _isLoadingMore = true;
    model.loadMoreError = null;
    ref.notifyListeners();
    try {
      final untilId = model.list.lastOrNull?.id;
      final notesList = await notes(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
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
