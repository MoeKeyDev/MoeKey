import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    db.put(
        "$name-timeline",
        await compute(
            (list) => jsonEncode(List.from(list.map((e) => e.toMap()))), list));
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
    List list = await compute((message) {
      return jsonDecode(message);
    }, res);
    return List<NoteModel>.from(list.map((e) => NoteModel.fromMap(e)));
  }
}
