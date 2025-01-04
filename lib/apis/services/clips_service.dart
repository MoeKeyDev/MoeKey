import 'package:moekey/apis/services/services.dart';

import '../models/clips.dart';
import '../models/note.dart';

class ClipsService extends MisskeyApiServices {
  ClipsService({required super.client});

  Future<ClipsModel> create({
    required String name,
    required String description,
    required bool isPublic,
  }) async {
    var res = await client.post("/clips/create", data: {
      "name": name,
      "description": description,
      "isPublic": isPublic,
    });
    return ClipsModel.fromJson(res);
  }

  Future<ClipsModel> update({
    required String clipId,
    required String name,
    required String description,
    required bool isPublic,
  }) async {
    var res = await client.post("/clips/update", data: {
      "clipId": clipId,
      "name": name,
      "description": description,
      "isPublic": isPublic,
    });
    return ClipsModel.fromJson(res);
  }

  Future delete({
    required String clipId,
  }) async {
    var res = await client.post("/clips/delete", data: {
      "clipId": clipId,
    });
    return res;
  }

  Future<List<ClipsModel>> list() async {
    var res = await client.post<List?>("/clips/list", data: {
      "allowPartial": true,
    });
    if (res == null) {
      return [];
    }

    return List<ClipsModel>.from(res.map((e) => ClipsModel.fromJson(e)));
  }

  Future<List<NoteModel>> notes({
    required String clipId,
    int limit = 10,
    String? untilId,
  }) async {
    var res = await client.post<List?>("/clips/notes", data: {
      "clipId": clipId,
      "limit": limit,
      if (untilId != null) "untilId": untilId,
    });
    if (res == null) {
      return [];
    }

    return List<NoteModel>.from(res.map((e) => NoteModel.fromJson(e)));
  }

  Future<List<ClipsModel>> myFavorites() async {
    var res = await client.post<List?>("/clips/my-favorites", data: {
      "allowPartial": true,
    });
    if (res == null) {
      return [];
    }

    return List<ClipsModel>.from(res.map((e) => ClipsModel.fromJson(e)));
  }

  Future<ClipsModel?> show({required String clipId}) async {
    var res = await client.post("/clips/show", data: {
      "clipId": clipId,
    });
    if (res == null) {
      return null;
    }

    return ClipsModel.fromJson(res);
  }

  Future addNote({
    required String clipId,
    required String noteId,
  }) {
    return client.post("/clips/add-note", data: {
      "clipId": clipId,
      "noteId": noteId,
    });
  }

  Future removeNote({
    required String clipId,
    required String noteId,
  }) {
    return client.post("/clips/remove-note", data: {
      "clipId": clipId,
      "noteId": noteId,
    });
  }

  Future favorite({
    required String clipId,
  }) {
    return client.post("/clips/favorite", data: {
      "clipId": clipId,
    });
  }

  Future unFavorite({
    required String clipId,
  }) {
    return client.post("/clips/unfavorite", data: {
      "clipId": clipId,
    });
  }
}
