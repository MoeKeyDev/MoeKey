import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/database/init_database.dart';

class TimelineDatabase {
  /// 服务器地址
  String server;

  /// 用户ID
  String userId;

  TimelineDatabase({required this.server, required this.userId});

  Future<Box<String>> _getDatabase() async {
    return openDatabase<String>(name: "timeline", server: server, user: userId);
  }

  setTimeline(String name, List<NoteModel> list) async {
    var db = await _getDatabase();
    db.put("$name-timeline", jsonEncode(List.from(list.map((e) => e.toMap()))));
  }

  setTimelineScroll(String name, double pos) async {
    var db = await _getDatabase();
    db.put("$name-timeline-pos", jsonEncode(pos));
  }

  Future<double> getTimelineScroll(String name) async {
    var db = await _getDatabase();
    var pos = db.get("$name-timeline-pos");
    if (pos == null) {
      return 0;
    }
    return jsonDecode(pos);
  }

  cleanTimeline(String name) async {
    var db = await _getDatabase();
    db.delete("$name-timeline");
  }

  Future<List<NoteModel>?> getTimeline(String name) async {
    var db = await _getDatabase();
    var res = db.get("$name-timeline");
    if (res == null) {
      return null;
    }
    List list = jsonDecode(res);
    return List<NoteModel>.from(list.map((e) => NoteModel.fromMap(e)));
  }
}
