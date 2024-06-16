import 'package:hive/hive.dart';

import 'init_database.dart';
import '../apis/models/note.dart' as note;

class LinkPreviewDatabase {
  LazyBox<String>? _box;

  Future<LazyBox<String>> _getDatabase() async {
    _box ??= await openLazyDatabase<String>(name: "link_preview");
    return _box!;
  }

  put(String src, note.LinkPreview link) async {
    var db = await _getDatabase();
    await db.put(src, link.toJson());
  }

  Future<note.LinkPreview?> get(String src) async {
    var db = await _getDatabase();
    var res = await db.get(src);
    if (res != null) {
      return note.LinkPreview.fromJson(res);
    }
    return null;
  }
}
