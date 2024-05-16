import 'dart:async';

import 'package:moekey/networks/dio.dart';
import 'package:moekey/state/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';

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
    var http = await ref.watch(httpProvider.future);
    var user = await ref.watch(currentLoginUserProvider.future);
    var res = await http.post("/notes/$api", data: {
      "i": user?.token,
      "limit": 10,
      if (untilId != null) "untilId": untilId,
      if (sinceId != null) "sinceId": sinceId
    });
    var noteList = ref.read(noteListProvider.notifier);
    List<NoteModel> list = [];
    for (var item in res.data) {
      var data = NoteModel.fromMap(item);
      noteList.registerNote(data);
      list.add(data);
    }
    return list;
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
