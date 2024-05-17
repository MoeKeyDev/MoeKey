import 'package:moekey/apis/models/notification.dart';
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
      var apis = await ref.read(misskeyApisProvider.future);
      var res = await apis.account.notificationsGrouped(untilId: untilId);
      return res;
    } catch (e, s) {
      print(e);
      print(s);
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
  FutureOr<List<NoteModel>> build({bool specified = false}) async {
    return (await mentions()) ?? [];
  }

  var loading = false;

  ///i/notifications-grouped
  Future<List<NoteModel>?> mentions({String? untilId}) async {
    if (loading) return null;
    loading = true;
    try {
      var apis = await ref.watch(misskeyApisProvider.future);
      return apis.notes
          .mentions(untilId: untilId, limit: 20, specified: specified);
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
