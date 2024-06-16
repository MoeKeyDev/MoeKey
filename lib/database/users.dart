import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/database/init_database.dart';

class UsersDatabase {
  /// 服务器地址
  String server;

  /// 用户ID
  String userId;

  UsersDatabase({required this.server, required this.userId});

  Future<LazyBox<String>> _getDatabase() async {
    return openLazyDatabase<String>(name: "users_cache");
  }

  put(UserFullModel userFullModel) async {
    var db = await _getDatabase();
    compute((message) {
      var json = jsonEncode(message);
      db.put(message.id, json);
    }, userFullModel);
  }

  get(String id) async {
    var db = await _getDatabase();
  }
}
