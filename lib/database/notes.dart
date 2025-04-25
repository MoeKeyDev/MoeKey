import 'package:hive/hive.dart';
import 'package:moekey/apis/models/note.dart';

import 'init_database.dart';

class NotesDatabase {
  /// 服务器地址
  String server;
  LazyBox? _box;

  NotesDatabase({required this.server});

  Future<LazyBox> _getDatabase() async {
    _box ??=
        await openLazyDatabase<String>(name: "notes_cache", server: server);
    return _box!;
  }

  put(String noteId, NoteModel note) async {
    var db = await _getDatabase();
    await db.put(noteId, note.toJson());
  }

  Future<NoteModel?> get(String noteId) async {
    var db = await _getDatabase();
    var res = await db.get(noteId);
    if (res != null) {
      return NoteModel.fromJson(res);
    }
    return null;
  }
}
