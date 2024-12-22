import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/hook/use_mk_refresh_load_list_controller.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../status/misskey_api.dart';

part 'hashtag_page.g.dart';

class HashtagPage extends HookConsumerWidget {
  const HashtagPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = hashTagPageProvider(name);
    var state = ref.watch(model);
    var data = state.valueOrNull;
    var controller = useMkRefreshLoadListController();
    return MkScaffold(
      header: MkAppbar(
        showBack: true,
        content: GestureDetector(
          onTap: () {
            controller.refresh();
          },
          child: Text(
            "#$name",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Center(
        child: MkPaginationNoteList(
          onLoad: () => ref.read(model.notifier).load(),
          onRefresh: () => ref.refresh(model.future),
          hasMore: data?.hasMore ?? true,
          items: data?.list,
          controller: controller,
        ),
      ),
    );
  }
}

@riverpod
class HashTagPage extends _$HashTagPage {
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

  load() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.valueOrNull ?? NoteListModel();
    try {
      String? untilId;
      if (state.valueOrNull?.list.isNotEmpty ?? false) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList = await notes(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
    } finally {
      state = AsyncData(model);
    }
  }
}
