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
      "untilId": ?untilId,
      "sinceId": ?sinceId
    });
    if (res == null) {
      return [];
    }
    return List<Following>.from(res.map((e) => Following.fromJson(e)));
  }

  Future<UserFullModel?> show({
    String? username,
    String? host,
    String? userId,
  }) async {
    var res = await client.post("/users/show", data: {
      "username": ?username,
      "host": ?host,
      "userId": ?userId,
    });
    if (res == null) {
      return null;
    }
    return UserFullModel.fromJson(res);
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
        "untilId": ?untilId,
      },
    );

    if (res == null) {
      return [];
    }
    return List<NoteModel>.from(res.map((e) => NoteModel.fromJson(e)));
  }

  Future<List<NoteModel>> reactions({
    required String userId,
    String? untilId,
  }) async {
    var res = await client.post("/users/reactions", data: {
      "userId": userId,
      "limit": 30,
      "untilId": ?untilId,
    });
    if (res == null) {
      return [];
    }
    return List<NoteModel>.from(res.map((e) => NoteModel.fromJson(e["note"])));
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
      "sinceId": ?sinceId,
      "untilId": ?untilId,
    });
    return List<ClipsModel>.from(res.map(
      (e) => ClipsModel.fromJson(e),
    ));
  }

  /// 获取全站置顶用户
  Future<List<UserFullModel>> pinnedUsers() async {
    var res = await client.post<List>("/pinned-users");
    return List<UserFullModel>.from(res.map(
      (e) => UserFullModel.fromJson(e),
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
      "origin": ?origin,
      "sort": ?sort,
      "state": ?state,
    });
    return List<UserFullModel>.from(res.map(
      (e) => UserFullModel.fromJson(e),
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
      "untilId": ?untilId,
    });
    return List<UserFullModel>.from(res.map(
      (e) => UserFullModel.fromJson(e),
    ));
  }
}
