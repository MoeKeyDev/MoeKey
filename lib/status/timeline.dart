import 'dart:async';

import 'package:moekey/status/server.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../database/timeline.dart';
import 'misskey_api.dart';
import 'notes_listener.dart';

part 'timeline.g.dart';

@riverpod
Future<TimelineDatabase> timelineDatabase(TimelineDatabaseRef ref) async {
  var user = ref.watch(currentLoginUserProvider);
  var instance = user?.serverUrl;
  return TimelineDatabase(
      server: instance ?? "default", userId: user?.id ?? "default");
}

@riverpod
class Timeline extends _$Timeline {
  @override
  FutureOr<NoteListModel> build({String api = "timeline"}) async {
    var db = await ref.watch(timelineDatabaseProvider.future);
    var cache = await db.getTimeline(api);
    var model = NoteListModel();
    if (cache != null) {
      model.list = cache;
    } else {
      var list = await timeline();
      model.list = list;
      db.setTimeline(api, list);
    }
    return model;
  }

  Future<List<NoteModel>> timeline({String? untilId, String? sinceId}) async {
    var apis = ref.watch(misskeyApisProvider);
    var list = await apis.notes.timeline(
      limit: 10,
      untilId: untilId,
      api: api,
      sinceId: sinceId,
    );
    return list;
  }

  var loading = false;

  load() async {
    if (loading) return;
    if (!(state.value?.hasMore ?? true)) return;
    loading = true;
    try {
      String? untilId;
      if (state.valueOrNull?.list.isNotEmpty ?? false) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList;

      notesList = await timeline(untilId: untilId);

      var model = NoteListModel();
      model.list = (state.valueOrNull?.list ?? []) + notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
      state = AsyncData(model);
    } finally {
      loading = false;
    }
  }

  cleanCache() async {
    var db = await ref.read(timelineDatabaseProvider.future);
    await db.cleanTimeline(api);
  }
}
