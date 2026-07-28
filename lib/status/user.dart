import 'dart:async';

import 'package:moekey/status/websocket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/following.dart';
import '../apis/models/note.dart';
import '../apis/models/user_full.dart';
import '../logger.dart';
import 'misskey_api.dart';

part 'user.g.dart';

@riverpod
class UserFollowing extends _$UserFollowing {
  @override
  FutureOr<List<Following>> build(String userId) async {
    return load();
  }

  // users/following

  Future<List<Following>> load() async {
    var apis = ref.read(misskeyApisProvider);
    return apis.user.follow(userId: userId, limit: 50);
  }
}

@riverpod
class UserInfo extends _$UserInfo {
  StreamSubscription<Map>? listen;

  @override
  FutureOr<UserFullModel?> build({
    String? username,
    String? host,
    String? userId,
    UserFullModel? userModel,
  }) async {
    var apis = ref.read(misskeyApisProvider);
    var model =
        userModel ??
        await apis.user.show(username: username, host: host, userId: userId);
    // 如果服务端没有返回用户名HOST，默认使用本示例的地址
    model?.host ??= Uri.parse(apis.instance).host;
    ref.onDispose(() {
      logger.d("========= NotesListener dispose ===================");
      listen?.cancel();
      listen = null;
    });
    listen?.cancel();
    listen = null;
    listen = moekeyStreamMainChannelController.stream.listen((event) {
      try {
        logger.d("监听到Main Channel 事件");
        if (state.value == null) {
          logger.d("内容不存在");
          return;
        }
        final userModel = state.value!;
        logger.d(userModel);
        if (event["type"] == "follow" && event["body"]["id"] == model?.id) {
          state = AsyncValue.data(
            userModel.copyWith(
              isFollowing: true,
              hasPendingFollowRequestFromYou: false,
            ),
          );
          return;
        }
        if (event["type"] == "unfollow" && event["body"]["id"] == model?.id) {
          state = AsyncValue.data(
            userModel.copyWith(
              isFollowing: false,
              hasPendingFollowRequestFromYou: false,
            ),
          );
          return;
        }
      } catch (e) {
        logger.e(e);
      }
    });
    return model;
  }

  Future<void> followingCreate() async {
    final previous = state.value;
    if (previous == null) {
      return;
    }
    final pending = previous.copyWith(hasPendingFollowRequestFromYou: true);
    state = AsyncValue.data(pending);
    var apis = ref.read(misskeyApisProvider);
    try {
      await apis.following.create(userId: pending.id);
      if (!pending.isLocked) {
        state = AsyncValue.data(
          pending.copyWith(
            isFollowing: true,
            hasPendingFollowRequestFromYou: false,
          ),
        );
      }
    } catch (_) {
      state = AsyncValue.data(previous);
      rethrow;
    }
  }

  Future<void> followingDelete() async {
    final previous = state.value;
    if (previous == null) {
      return;
    }
    final pending = previous.copyWith(hasPendingFollowRequestFromYou: true);
    state = AsyncValue.data(pending);
    var apis = ref.read(misskeyApisProvider);
    try {
      await apis.following.delete(userId: pending.id);
      state = AsyncValue.data(
        pending.copyWith(
          isFollowing: false,
          hasPendingFollowRequestFromYou: false,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(previous);
      rethrow;
    }
  }

  Future<void> followingCancel() async {
    final previous = state.value;
    if (previous == null) {
      return;
    }
    var apis = ref.read(misskeyApisProvider);
    try {
      await apis.following.requestsCancel(userId: previous.id);
      state = AsyncValue.data(
        previous.copyWith(hasPendingFollowRequestFromYou: false),
      );
    } catch (_) {
      state = AsyncValue.data(previous);
      rethrow;
    }
  }
}

@riverpod
class UserNotesList extends _$UserNotesList {
  @override
  FutureOr<NoteListModel> build({
    required String userId,
    bool withRenotes = false,
    bool withReplies = false,
    bool withChannelNotes = false,
    bool withFiles = false,
    bool withFeatured = false,
    int key = 0,
  }) async {
    var note = NoteListModel();

    note.list = await notes();

    return note;
  }

  Future<List<NoteModel>> notes({String? untilId}) async {
    var apis = ref.read(misskeyApisProvider);

    var list = await apis.user.notes(
      userId: userId,
      untilId: untilId,
      withChannelNotes: withChannelNotes,
      withFeatured: withFeatured,
      withFiles: withFiles,
      withRenotes: withRenotes,
      withReplies: withReplies,
    );
    return list;
  }

  Future<void> load() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.value ?? NoteListModel();
    try {
      String? untilId;
      if (state.value?.list.isNotEmpty ?? false) {
        untilId = state.value?.list.last.id;
      }
      List<NoteModel> notesList;

      notesList = await notes(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
    } finally {
      state = AsyncData(model);
    }
  }
}

@riverpod
class UserReactionsList extends _$UserReactionsList {
  @override
  FutureOr<NoteListModel> build({required String userId}) async {
    var note = NoteListModel();

    note.list = await reactions();

    return note;
  }

  Future<List<NoteModel>> reactions({String? untilId}) async {
    var apis = ref.read(misskeyApisProvider);
    var list = await apis.user.reactions(userId: userId, untilId: untilId);
    return list;
  }

  Future<void> load() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.value ?? NoteListModel();
    try {
      String? untilId;
      if (state.value?.list.isNotEmpty ?? false) {
        untilId = state.value?.list.last.id;
      }
      List<NoteModel> notesList = await reactions(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
    } finally {
      state = AsyncData(model);
    }
  }
}
