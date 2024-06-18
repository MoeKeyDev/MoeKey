import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/main.dart';
import 'package:moekey/status/notes_listener.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import 'misskey_api.dart';

part 'notifications.g.dart';

@riverpod
class Notifications extends _$Notifications {
  @override
  FutureOr<List<NotificationModel>> build() async {
    return (await notificationsGrouped());
  }

  var loading = false;

  ///i/notifications-grouped
  notificationsGrouped({String? untilId}) async {
    if (loading) return;
    loading = true;
    try {
      var apis = ref.read(misskeyApisProvider);
      var res = await apis.account.notificationsGrouped(untilId: untilId);
      return res;
    } catch (e, s) {
      logger.e(e);
      logger.e(s);
    } finally {
      loading = false;
    }
  }

  loadMore() async {
    var list = state.valueOrNull ?? [];
    var res = await notificationsGrouped(untilId: state.valueOrNull?.last.id);
    if (res != null) {
      state = AsyncData(list + res);
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
