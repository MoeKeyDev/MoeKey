import 'dart:async';

import 'package:moekey/status/websocket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/following.dart';
import '../apis/models/note.dart';
import '../apis/models/user_full.dart';
import '../main.dart';
import '../widgets/notes/note_pagination_list.dart';
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
    return apis.user.following(userId: userId, limit: 50);
  }
}

@riverpod
class UserInfo extends _$UserInfo {
  StreamSubscription<Map>? listen;

  @override
  FutureOr<UserFullModel?> build(
      {String? username,
      String? host,
      String? userId,
      UserFullModel? userModel}) async {
    var apis = ref.read(misskeyApisProvider);
    var model = userModel ??
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
        UserFullModel userModel = state.value!;
        logger.d(userModel);
        if (event["type"] == "follow" && event["body"]["id"] == model?.id) {
          userModel.isFollowing = true;
          userModel.hasPendingFollowRequestFromYou = false;
        }
        if (event["type"] == "unfollow" && event["body"]["id"] == model?.id) {
          userModel.isFollowing = false;
          userModel.hasPendingFollowRequestFromYou = false;
        }
        state = AsyncValue.data(userModel);
      } catch (e) {
        logger.e(e);
      }
    });
    return model;
  }

  followingCreate() async {
    if (state.value == null) {
      return;
    }
    UserFullModel userModel = state.value!;
    userModel.hasPendingFollowRequestFromYou = true;
    state = AsyncValue.data(userModel);
    var apis = ref.read(misskeyApisProvider);
    await apis.following.create(userId: userModel.id);
  }

  followingDelete() async {
    if (state.value == null) {
      return;
    }
    UserFullModel userModel = state.value!;
    userModel.hasPendingFollowRequestFromYou = true;
    state = AsyncValue.data(userModel);
    var apis = ref.read(misskeyApisProvider);
    await apis.following.delete(userId: userModel.id);
  }

  followingCancel() async {
    if (state.value == null) {
      return;
    }
    UserFullModel userModel = state.value!;
    userModel.hasPendingFollowRequestFromYou = false;
    state = AsyncValue.data(userModel);
    var apis = ref.read(misskeyApisProvider);
    await apis.following.requestsCancel(userId: userModel.id);
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

  var loading = false;

  load() async {
    if (!(state.value?.hasMore ?? true)) return;
    if (loading) return;
    loading = true;
    try {
      String? untilId;
      if (state.valueOrNull?.list.isNotEmpty ?? false) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList;

      notesList = await notes(untilId: untilId);

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

@riverpod
class UserReactionsList extends _$UserReactionsList {
  @override
  FutureOr<NoteListModel> build({
    required String userId,
  }) async {
    var note = NoteListModel();

    note.list = await reactions();

    return note;
  }

  Future<List<NoteModel>> reactions({String? untilId}) async {
    var apis = ref.read(misskeyApisProvider);
    var list = await apis.user.reactions(userId: userId, untilId: untilId);
    return list;
  }

  var loading = false;

  load() async {
    if (!(state.value?.hasMore ?? true)) return;
    if (loading) return;
    loading = true;
    try {
      String? untilId;
      if (state.valueOrNull?.list.isNotEmpty ?? false) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList = await reactions(untilId: untilId);

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
