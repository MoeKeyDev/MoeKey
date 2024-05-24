import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:moekey/apis/models/note.dart';

import 'init_database.dart';

class NotesDatabase {
  /// 服务器地址
  String server;

  NotesDatabase({required this.server});

  Future<LazyBox<String>> _getDatabase() async {
    return openLazyDatabase<String>(name: "notes_cache", server: server);
  }

  put(String noteId, NoteModel note) async {
    var db = await _getDatabase();
    await db.put(noteId, await compute((note) => note.toJson(), note));
  }

  Future<NoteModel?> get(String noteId) async {
    var db = await _getDatabase();
    var res = await db.get(noteId);
    if (res != null) {
      return compute((res) => NoteModel.fromJson(res), res);
    }
    return null;
  }
}
