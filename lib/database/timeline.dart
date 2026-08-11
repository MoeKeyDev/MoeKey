import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/database/init_database.dart';

class TimelineCacheData {
  const TimelineCacheData({required this.notes});

  final List<NoteModel> notes;
}

class TimelineDatabase {
  /// 服务器地址
  String server;

  /// 用户ID
  String userId;

  TimelineDatabase({required this.server, required this.userId});

  Future<Box<String>> _getDatabase() async {
    return openDatabase<String>(name: "timeline", server: server, user: userId);
  }

  Future<void> setTimeline(String name, List<NoteModel> list) async {
    var db = await _getDatabase();
    final payload = List.from(list.map((note) => note.toJson()));
    await db.put("$name-timeline", await compute(jsonEncode, payload));
  }

  Future<void> cleanTimeline(String name) async {
    var db = await _getDatabase();
    await db.delete("$name-timeline");
  }

  Future<TimelineCacheData?> getTimeline(String name) async {
    var db = await _getDatabase();
    var res = db.get("$name-timeline");
    if (res == null) {
      return null;
    }
    final decoded = await compute(jsonDecode, res);
    // Accept both the original list cache and caches written by versions that
    // briefly stored gap metadata.
    final List<dynamic> notesJson;
    if (decoded is List) {
      notesJson = decoded;
    } else if (decoded is Map) {
      notesJson = List<dynamic>.from(decoded['notes'] as List? ?? const []);
    } else {
      return null;
    }
    return TimelineCacheData(
      notes: List<NoteModel>.from(
        notesJson.map((note) => NoteModel.fromJson(note)),
      ),
    );
  }
}
