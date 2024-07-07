import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/main.dart';
import 'package:moekey/status/notes_listener.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import 'misskey_api.dart';

part 'notifications.g.dart';

@riverpod
class Notifications extends _$Notifications {
  @override
  Future<MkLoadMoreListModel<NotificationModel>> build() async {
    var model = MkLoadMoreListModel<NotificationModel>();
    var list = await notificationsGrouped();
    model.list += list!;
    return model;
  }

  var loading = false;

  ///i/notifications-grouped
  Future<List<NotificationModel>> notificationsGrouped(
      {String? untilId}) async {
    try {
      var apis = ref.read(misskeyApisProvider);
      var res = await apis.account.notificationsGrouped(untilId: untilId);
      return res;
    } catch (e, s) {
      logger.e(e);
      logger.e(s);
    }
    return [];
  }

  loadMore() async {
    if (loading) return null;
    loading = true;
    try {
      var model = state.valueOrNull ?? MkLoadMoreListModel<NotificationModel>();
      var res = await notificationsGrouped(untilId: model.list.lastOrNull?.id);

      if (res.isNotEmpty) {
        model.list += res;
      } else {
        model.hasMore = false;
      }
      state = AsyncData(model);
    } finally {
      loading = false;
    }
  }
}

@riverpod
class MentionsNotifications extends _$MentionsNotifications {
  @override
  FutureOr<NoteListModel> build({bool specified = false}) async {
    var model = NoteListModel();
    model.list = (await mentions()) ?? [];
    return model;
  }

  var loading = false;

  ///i/notifications-grouped
  Future<List<NoteModel>> mentions({String? untilId}) async {
    var apis = ref.watch(misskeyApisProvider);
    var notes = await apis.notes
        .mentions(untilId: untilId, limit: 20, specified: specified);
    return notes;
  }

  loadMore() async {
    if (loading) return;
    if (!state.value!.hasMore) return;
    loading = true;
    try {
      String? untilId;
      if (state.valueOrNull!.list.isNotEmpty) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList = await mentions(untilId: untilId);

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
}
