import 'dart:async';

import 'package:moekey/status/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../database/timeline.dart';
import '../logger.dart';
import 'misskey_api.dart';

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

  load() async {
    if (state.isLoading) return;

    var model = state.valueOrNull ?? NoteListModel();
    state = const AsyncValue.loading();
    try {
      String? untilId = model.list.lastOrNull?.id;

      List<NoteModel> notesList = await timeline(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
    } catch (e) {
      logger.e(e);
    }
    state = AsyncData(model);
  }

  cleanCache() async {
    var db = await ref.read(timelineDatabaseProvider.future);
    await db.cleanTimeline(api);
  }
}
