import 'dart:async';

import 'package:moekey/status/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../database/timeline.dart';
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
  FutureOr<List<NoteModel>> build({String api = "timeline"}) async {
    var db = await ref.watch(timelineDatabaseProvider.future);
    var cache = await db.getTimeline(api);
    if (cache != null) {
      return cache;
    }
    var list = await timeline(api: api);
    await db.setTimeline(api, list);
    return list;
  }

  Future<List<NoteModel>> timeline(
      {String? untilId, String? sinceId, String api = "timeline"}) async {
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

  load({String api = "timeline"}) async {
    if (loading) return;
    loading = true;
    try {
      state = AsyncData((state.valueOrNull ?? []) +
          await timeline(untilId: state.valueOrNull?.last.id, api: api));
      var db = await ref.watch(timelineDatabaseProvider.future);
      await db.setTimeline(api, state.value!);
    } finally {
      loading = false;
    }
  }

  cleanCache() async {
    var db = await ref.read(timelineDatabaseProvider.future);
    await db.cleanTimeline(api);
  }
}
