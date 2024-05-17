import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import 'misskey_api.dart';

part 'timeline.g.dart';

@Riverpod(keepAlive: true)
class NoteList extends _$NoteList {
  @override
  Map<String, NoteModel> build() {
    return {};
  }

  registerNote(NoteModel data, {bool notUpdateReplyAndRenote = false}) {
    state[data.id] = data;
    if (notUpdateReplyAndRenote) {
      if (data.reply != null && state[data.reply?.id] == null) {
        state[data.reply!.id] = data.reply!;
      }
      if (data.renote != null && state[data.renote?.id] == null) {
        state[data.renote!.id] = data.renote!;
      }
    } else {
      if (data.reply != null) {
        state[data.reply!.id] = data.reply!;
      }
      if (data.renote != null) {
        state[data.renote!.id] = data.renote!;
      }
    }

    ref.notifyListeners();
  }
}

@riverpod
class Timeline extends _$Timeline {
  @override
  FutureOr<List<NoteModel>> build({String api = "timeline"}) async {
    return timeline(api: api);
  }

  Future<List<NoteModel>> timeline(
      {String? untilId, String? sinceId, String api = "timeline"}) async {
    var apis = await ref.watch(misskeyApisProvider.future);
    return await apis.notes.timeline(
      limit: 10,
      untilId: untilId,
      api: api,
      sinceId: sinceId,
    );
  }

  var loading = false;

  load({String api = "timeline"}) async {
    if (loading) return;
    loading = true;
    try {
      state = AsyncData((state.valueOrNull ?? []) +
          await timeline(untilId: state.valueOrNull?.last.id, api: api));
    } finally {
      loading = false;
    }
  }
}
