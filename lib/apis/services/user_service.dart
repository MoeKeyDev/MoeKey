import 'package:moekey/apis/models/clips.dart';
import 'package:moekey/apis/models/following.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/apis/services/services.dart';

class UserService extends MisskeyApiServices {
  UserService({required super.client});

  Future<List<Following>> follow({
    required String userId,
    String? untilId,
    int limit = 20,
    String? sinceId,
    String type = "following",
  }) async {
    var res = await client.post<List?>("/users/$type", data: {
      "userId": userId,
      "limit": limit,
      if (untilId != null) "untilId": untilId,
      if (sinceId != null) "sinceId": sinceId
    });
    if (res == null) {
      return [];
    }
    return List<Following>.from(res.map((e) => Following.fromMap(e)));
  }

  Future<UserFullModel?> show({
    String? username,
    String? host,
    String? userId,
  }) async {
    var res = await client.post("/users/show", data: {
      if (username != null) "username": username,
      if (host != null) "host": host,
      if (userId != null) "userId": userId,
    });
    if (res == null) {
      return null;
    }
    return UserFullModel.fromMap(res);
  }

  Future<List<NoteModel>> notes({
    required String userId,
    bool withRenotes = false,
    bool withReplies = false,
    bool withChannelNotes = false,
    bool withFiles = false,
    bool withFeatured = false,
    String? untilId,
  }) async {
    var res = await client.post<List?>(
      withFeatured ? "/users/featured-notes" : "/users/notes",
      data: {
        "userId": userId,
        "withRenotes": withRenotes,
        "withReplies": withReplies,
        "withChannelNotes": withChannelNotes,
        "withFiles": withFiles,
        "limit": 30,
        if (untilId != null) "untilId": untilId,
      },
    );

    if (res == null) {
      return [];
    }
    return List<NoteModel>.from(res.map((e) => NoteModel.fromMap(e)));
  }

  Future<List<NoteModel>> reactions({
    required String userId,
    String? untilId,
  }) async {
    var res = await client.post("/users/reactions", data: {
      "userId": userId,
      "limit": 30,
      if (untilId != null) "untilId": untilId,
    });
    if (res == null) {
      return [];
    }
    return List<NoteModel>.from(res.map((e) => NoteModel.fromMap(e["note"])));
  }

  Future<List<ClipsModel>> clips({
    required String userId,
    int limit = 10,
    String? sinceId,
    String? untilId,
  }) async {
    var res = await client.post<List>("/users/clips", data: {
      "userId": userId,
      "limit": 10,
      if (sinceId != null) "sinceId": sinceId,
      if (untilId != null) "untilId": untilId,
    });
    return List<ClipsModel>.from(res.map(
      (e) => ClipsModel.fromMap(e),
    ));
  }

  /// 获取全站置顶用户
  Future<List<UserFullModel>> pinnedUsers() async {
    var res = await client.post<List>("/pinned-users");
    return List<UserFullModel>.from(res.map(
      (e) => UserFullModel.fromMap(e),
    ));
  }

  /// 获取全站用户
  Future<List<UserFullModel>> users({
    int limit = 10,
    String? origin,
    String? sort,
    String? state,
  }) async {
    var res = await client.post<List>("/users", data: {
      "limit": 10,
      if (origin != null) "origin": origin,
      if (sort != null) "sort": sort,
      if (state != null) "state": state,
    });
    return List<UserFullModel>.from(res.map(
      (e) => UserFullModel.fromMap(e),
    ));
  }

  /// 搜索用户
  Future<List<UserFullModel>> search({
    required String query,
    int limit = 10,
    String origin = "combined",
    String? untilId,
  }) async {
    var res = await client.post<List>("/users/search", data: {
      "query": query,
      "limit": limit,
      "origin": origin,
      if (untilId != null) "untilId": untilId,
    });
    return List<UserFullModel>.from(res.map(
      (e) => UserFullModel.fromMap(e),
    ));
  }
}
