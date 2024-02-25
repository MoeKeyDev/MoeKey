import 'dart:async';

import 'package:moekey/models/note.dart';
import 'package:moekey/models/user_full.dart';
import 'package:moekey/networks/dio.dart';
import 'package:moekey/networks/websocket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main.dart';
import '../state/server.dart';

part 'user.g.dart';

@riverpod
class UserFollowing extends _$UserFollowing {
  @override
  FutureOr<List> build(String userId) async {
    return load();
  }

  // users/following

  Future<List> load() async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var res = await http.post("/users/following", data: {
      "userId": userId,
      "limit": 50,
      "i": user!.token,
    });
    return res.data;
  }
}

@riverpod
class UserInfo extends _$UserInfo {
  StreamSubscription<Map>? listen;
  @override
  FutureOr<UserFullModel> build(
      {String? username, String? host, String? userId}) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);

    var res = await http.post("/users/show", data: {
      if (username != null) "username": username,
      if (host != null) "host": host,
      "i": user?.token,
      if (userId != null) "userId": userId,
    });
    var model = UserFullModel.fromMap(res.data);
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
        if (event["type"] == "follow" && event["body"]["id"] == model.id) {
          userModel.isFollowing = true;
          userModel.hasPendingFollowRequestFromYou = false;
        }
        if (event["type"] == "unfollow" && event["body"]["id"] == model.id) {
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
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    if (state.value == null) {
      return;
    }
    UserFullModel userModel = state.value!;
    userModel.hasPendingFollowRequestFromYou = true;
    state = AsyncValue.data(userModel);
    await http.post(
      "/following/create",
      data: {
        "userId": userModel.id,
        "withReplies": false,
        "i": user?.token,
      },
    );
  }

  followingDelete() async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    if (state.value == null) {
      return;
    }
    UserFullModel userModel = state.value!;
    userModel.hasPendingFollowRequestFromYou = true;
    state = AsyncValue.data(userModel);
    await http.post(
      "/following/delete",
      data: {
        "userId": userModel.id,
        "withReplies": false,
        "i": user?.token,
      },
    );
  }

  followingCancel() async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    if (state.value == null) {
      return;
    }
    UserFullModel userModel = state.value!;
    userModel.hasPendingFollowRequestFromYou = false;
    state = AsyncValue.data(userModel);
    await http.post(
      "/following/cancel",
      data: {
        "userId": userModel.id,
        "withReplies": false,
        "i": user?.token,
      },
    );
  }
}

// @riverpod
// Future<UserFullModel> userInfo(UserInfoRef ref,
//     {String? username, String? host, String? userId}) async {
//   var http = await ref.read(httpProvider.future);
//   var user = await ref.read(currentLoginUserProvider.future);
//
//   var res = await http.post("/users/show", data: {
//     if (username != null) "username": username,
//     if (host != null) "host": host,
//     "i": user?.token,
//     if (userId != null) "userId": userId,
//   });
//   return UserFullModel.fromMap(res.data);
// }

class UserNoteListsModel {
  List<NoteModel> list = [];
  bool hasMore = true;
}

@riverpod
class UserNotesList extends _$UserNotesList {
  @override
  FutureOr<UserNoteListsModel> build({
    required String userId,
    bool withRenotes = false,
    bool withReplies = false,
    bool withChannelNotes = false,
    bool withFiles = false,
    bool withFeatured = false,
    int key = 0,
  }) async {
    var note = UserNoteListsModel();
    if (withFeatured) {
      note.list = await featuredNotes();
    } else {
      note.list = await notes();
    }
    return note;
  }

  Future<List<NoteModel>> notes({String? untilId}) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);

    var res = await http.post("/users/notes", data: {
      "userId": userId,
      "withRenotes": withRenotes,
      "withReplies": withReplies,
      "withChannelNotes": withChannelNotes,
      "withFiles": withFiles,
      "limit": 30,
      if (untilId != null) "untilId": untilId,
      "i": user?.token
    });
    List<NoteModel> list = [];
    for (var item in res.data) {
      list.add(NoteModel.fromMap(item));
    }
    return list;
  }

  Future<List<NoteModel>> featuredNotes({String? untilId}) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);

    var res = await http.post("/users/featured-notes", data: {
      "userId": userId,
      "i": user?.token,
      "allowPartial": true,
      "limit": 10,
      if (untilId != null) "untilId": untilId,
    });
    List<NoteModel> list = [];
    for (var item in res.data) {
      list.add(NoteModel.fromMap(item));
    }
    return list;
  }

  var loading = false;
  load() async {
    if (!state.value!.hasMore) return;
    if (loading) return;
    loading = true;
    try {
      String? untilId;
      if (state.valueOrNull!.list.isNotEmpty) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList;
      if (withFeatured) {
        notesList = await featuredNotes(untilId: untilId);
      } else {
        notesList = await notes(untilId: untilId);
      }
      var model = UserNoteListsModel();
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
  FutureOr<UserNoteListsModel> build({
    required String userId,
  }) async {
    var note = UserNoteListsModel();

    note.list = await reactions();

    return note;
  }

  Future<List<NoteModel>> reactions({String? untilId}) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);

    var res = await http.post("/users/reactions", data: {
      "userId": userId,
      "limit": 30,
      if (untilId != null) "untilId": untilId,
      "i": user?.token
    });
    List<NoteModel> list = [];
    for (var item in res.data) {
      list.add(NoteModel.fromMap(item["note"]));
    }
    return list;
  }

  var loading = false;
  load() async {
    if (!state.value!.hasMore) return;
    if (loading) return;
    loading = true;
    try {
      String? untilId;
      if (state.valueOrNull!.list.isNotEmpty) {
        untilId = state.valueOrNull?.list.last.id;
      }
      List<NoteModel> notesList = await reactions(untilId: untilId);

      var model = UserNoteListsModel();
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
