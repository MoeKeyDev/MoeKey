import 'package:moekey/networks/dio.dart';
import 'package:moekey/state/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';

part 'notifications.g.dart';

@riverpod
class Notifications extends _$Notifications {
  @override
  FutureOr<List> build() async {
    return (await notificationsGrouped());
  }

  var loading = false;

  ///i/notifications-grouped
  notificationsGrouped({String? untilId}) async {
    if (loading) return;
    loading = true;
    try {
      var http = await ref.watch(httpProvider.future);
      var user = await ref.watch(currentLoginUserProvider.future);
      var res = await http.post("/i/notifications-grouped", data: {
        "limit": 20,
        "i": user?.token,
        if (untilId != null) "untilId": untilId,
      });
      return res.data;
    } finally {
      loading = false;
    }
    // state = AsyncData(res.data);
  }

  loadMore() async {
    var list = state.valueOrNull ?? [];
    var res =
        await notificationsGrouped(untilId: state.valueOrNull?.last["id"]);
    if (res != null) {
      state = AsyncData(list + res);
    }
  }
}

@riverpod
class MentionsNotifications extends _$MentionsNotifications {
  @override
  FutureOr<List<NoteModel>> build({bool specified = false}) async {
    return (await mentions()) ?? [];
  }

  var loading = false;

  ///i/notifications-grouped
  Future<List<NoteModel>?> mentions({String? untilId}) async {
    if (loading) return null;
    loading = true;
    try {
      var http = await ref.watch(httpProvider.future);
      var user = await ref.watch(currentLoginUserProvider.future);
      var res = await http.post("/notes/mentions", data: {
        "limit": 20,
        "i": user?.token,
        if (specified) "visibility": "specified",
        if (untilId != null) "untilId": untilId,
      });
      List<NoteModel> list = [];
      for (var item in res.data) {
        list.add(NoteModel.fromMap(item));
      }
      return list;
    } finally {
      loading = false;
    }
    // state = AsyncData(res.data);
  }

  loadMore() async {
    var list = state.valueOrNull ?? [];
    var res = await mentions(untilId: state.valueOrNull?.last.id);
    if (res != null) {
      state = AsyncData(list + res);
    }
  }
}
