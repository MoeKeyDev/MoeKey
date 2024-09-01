import 'dart:io';

import 'package:moekey/apis/services/services.dart';

import '../models/note.dart';
import '../models/translate.dart';

class NotesService extends MisskeyApiServices {
  NotesService({required super.client});

  Future<List<NoteModel>> timeline({
    String api = "timeline",
    int limit = 10,
    String? untilId,
    String? sinceId,
  }) async {
    var res = await client.post<List?>("/notes/$api", data: {
      "limit": 10,
      if (untilId != null) "untilId": untilId,
      if (sinceId != null) "sinceId": sinceId
    });
    if (res == null) {
      return [];
    }
    return List<NoteModel>.from(res.map((e) => NoteModel.fromMap(e)));
  }

  Future<NoteTranslate?> translate({required String noteId}) async {
    var data = await client.post("/notes/translate", data: {
      "noteId": noteId,
      "targetLang": Platform.localeName.replaceAll("_", "-"),
    });
    if (data == null) {
      return null;
    }
    return NoteTranslate.fromMap(data);
  }

  Future<LinkPreview?> linkPreview({required String url}) async {
    String myLocale = Platform.localeName.replaceAll("_", "-");
    var res = await client.get("${client.host}/url", data: {
      "url": url,
      "lang": myLocale,
    });
    if (res == null) {
      return null;
    }
    return LinkPreview.fromMap(res);
  }

  Future<NoteModel?> show({required String noteId}) async {
    var data = await client.post(
      "/notes/show",
      data: {
        "noteId": noteId,
      },
    );
    if (data == null) {
      return null;
    }
    return NoteModel.fromMap(data);
  }

  Future<List<NoteModel>> children({
    required String noteId,
    int limit = 30,
    String? untilId,
  }) async {
    var data = await client.post<List?>("/notes/children", data: {
      "noteId": noteId,
      "limit": limit,
      if (untilId != null) "untilId": untilId,
    });
    if (data == null) {
      return [];
    }
    return List<NoteModel>.from(data.map((e) => NoteModel.fromMap(e)));
  }

  Future<List<NoteModel>> pollsRecommendation(
      {int limit = 10, String? untilId}) async {
    var data = await client.post<List?>(
      "/notes/polls/recommendation",
      data: {
        "limit": limit,
        if (untilId != null) "untilId": untilId,
      },
    );
    if (data == null) {
      return [];
    }
    return List<NoteModel>.from(data.map((e) => NoteModel.fromMap(e)));
  }

  Future<List<NoteModel>> featured({int limit = 10, String? untilId}) async {
    var data = await client.post<List?>(
      "/notes/featured",
      data: {
        "limit": limit,
        if (untilId != null) "untilId": untilId,
      },
    );
    if (data == null) {
      return [];
    }
    return List<NoteModel>.from(data.map((e) => NoteModel.fromMap(e)));
  }

  Future<NoteModel?> reNote({required String renoteId}) async {
    var data = await client.post("/notes/create", data: {
      "localOnly": false,
      "visibility": "public",
      "renoteId": renoteId,
    });
    if (data == null) {
      return null;
    }
    return NoteModel.fromMap(data);
  }

  Future createReactions(
      {required String noteId, required String reaction}) async {
    await client.post("/notes/reactions/create", data: {
      "noteId": noteId,
      "reaction": reaction,
    });
  }

  Future deleteReactions({required String noteId}) async {
    await client.post("/notes/reactions/delete", data: {
      "noteId": noteId,
    });
  }

  Future<List<NoteModel>> mentions({
    int limit = 30,
    String? untilId,
    bool specified = false,
  }) async {
    var data = await client.post<List?>("/notes/mentions", data: {
      "limit": limit,
      if (specified) "visibility": "specified",
      if (untilId != null) "untilId": untilId,
    });
    if (data == null) {
      return [];
    }
    return List<NoteModel>.from(data.map((e) => NoteModel.fromMap(e)));
  }

  Future<List<NoteModel>> search({
    required String query,
    String? sinceId,
    String? untilId,
    int limit = 10,
    String? host,
    String? userId,
    String? channelId,
  }) async {
    var data = await client.post("/notes/search", data: {
      "query": query,
      "limit": limit,
      if (sinceId != null) "sinceId": sinceId,
      if (untilId != null) "untilId": untilId,
      if (host != null) "host": host,
      if (userId != null) "userId": userId,
      if (channelId != null) "channelId": channelId,
    });
    if (data == null) {
      return [];
    }
    return List<NoteModel>.from(data.map((e) => NoteModel.fromMap(e)));
  }
}
