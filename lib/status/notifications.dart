import 'dart:async';

import 'package:moekey/apis/models/notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../logger.dart';
import 'misskey_api.dart';
import 'websocket.dart';

part 'notifications.g.dart';

@riverpod
class Notifications extends _$Notifications {
  StreamSubscription<Map>? _mainChannelSubscription;
  Timer? _refreshTimer;

  @override
  Future<MkLoadMoreListModel<NotificationModel>> build() async {
    _refreshTimer?.cancel();
    await _mainChannelSubscription?.cancel();
    _mainChannelSubscription = moekeyStreamMainChannelController.stream.listen((
      event,
    ) {
      if (event['type'] != 'notification') {
        return;
      }
      _refreshTimer?.cancel();
      _refreshTimer = Timer(const Duration(milliseconds: 150), () {
        if (ref.mounted) {
          ref.invalidateSelf();
        }
      });
    });
    ref.onDispose(() {
      _refreshTimer?.cancel();
      _refreshTimer = null;
      final subscription = _mainChannelSubscription;
      if (subscription != null) {
        unawaited(subscription.cancel());
      }
      _mainChannelSubscription = null;
    });

    var model = MkLoadMoreListModel<NotificationModel>();
    var list = await notificationsGrouped();
    model.list += list;
    if (list.isEmpty) {
      model.hasMore = false;
    }
    return model;
  }

  ///i/notifications-grouped
  Future<List<NotificationModel>> notificationsGrouped({
    String? untilId,
  }) async {
    try {
      var apis = ref.watch(misskeyApisProvider);
      var res = await apis.account.notificationsGrouped(untilId: untilId);
      return res;
    } catch (e, s) {
      logger.e(e);
      logger.e(s);
    }
    return [];
  }

  Future<void> loadMore() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.value ?? MkLoadMoreListModel<NotificationModel>();
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
  bool _isLoadingMore = false;

  @override
  FutureOr<NoteListModel> build({bool specified = false}) async {
    var model = NoteListModel();
    model.list = await mentions();
    if (model.list.isEmpty) {
      model.hasMore = false;
    }
    return model;
  }

  ///i/notifications-grouped
  Future<List<NoteModel>> mentions({String? untilId}) async {
    var apis = ref.watch(misskeyApisProvider);
    var notes = await apis.notes.mentions(
      untilId: untilId,
      limit: 20,
      specified: specified,
    );
    return notes;
  }

  Future<void> loadMore() async {
    if (state.isLoading || _isLoadingMore) return;
    final model = state.value;
    if (model == null) return;

    _isLoadingMore = true;
    model.loadMoreError = null;
    ref.notifyListeners();
    try {
      final untilId = model.list.lastOrNull?.id;
      List<NoteModel> notesList = await mentions(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      model.loadMoreError = error;
    } finally {
      _isLoadingMore = false;
      state = AsyncData(model);
      ref.notifyListeners();
    }
  }
}
