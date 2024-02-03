import 'package:moekey/models/note.dart';
import 'package:moekey/models/user_full.dart';
import 'package:moekey/networks/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
Future<UserFullModel> userInfo(UserInfoRef ref,
    {required String userId}) async {
  var http = await ref.read(httpProvider.future);
  var user = await ref.read(currentLoginUserProvider.future);

  var res = await http
      .post("/users/show", data: {"userId": userId, "i": user?.token});
  return UserFullModel.fromMap(res.data);
}

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
