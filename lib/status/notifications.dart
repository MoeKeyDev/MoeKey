import 'package:moekey/apis/models/notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../logger.dart';
import 'misskey_api.dart';

part 'notifications.g.dart';

@riverpod
class Notifications extends _$Notifications {
  @override
  Future<MkLoadMoreListModel<NotificationModel>> build() async {
    var model = MkLoadMoreListModel<NotificationModel>();
    var list = await notificationsGrouped();
    model.list += list;
    return model;
  }

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
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.valueOrNull ?? MkLoadMoreListModel<NotificationModel>();
    try {
      var res = await notificationsGrouped(untilId: model.list.lastOrNull?.id);

      if (res.isNotEmpty) {
        model.list += res;
      } else {
        model.hasMore = false;
      }
    } finally {
      state = AsyncData(model);
    }
  }
}

@riverpod
class MentionsNotifications extends _$MentionsNotifications {
  @override
  FutureOr<NoteListModel> build({bool specified = false}) async {
    var model = NoteListModel();
    model.list = await mentions();
    return model;
  }

  ///i/notifications-grouped
  Future<List<NoteModel>> mentions({String? untilId}) async {
    var apis = ref.watch(misskeyApisProvider);
    var notes = await apis.notes
        .mentions(untilId: untilId, limit: 20, specified: specified);
    return notes;
  }

  loadMore() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.valueOrNull ?? NoteListModel();
    try {
      String? untilId;
      if (state.valueOrNull!.list.isNotEmpty) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList = await mentions(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
    } finally {
      state = AsyncData(model);
    }
  }
}
