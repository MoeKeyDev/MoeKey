import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:moekey/apis/models/emojis.dart';
import 'package:moekey/apis/models/meta.dart';
import 'package:moekey/database/init_database.dart';

/// 实例信息
class InstanceDatabase {
  /// 服务器地址
  String server;

  InstanceDatabase({required this.server});

  Future<Box<String>> _getDatabase() {
    return openDatabase<String>(name: "instance_data", server: server);
  }

  /// 设置元数据
  setMeta(MetaDetailedModel model) async {
    var db = await _getDatabase();
    db.put("meta", model.toJson());
  }

  /// 获取元数据
  Future<MetaDetailedModel?> getMeta() async {
    var db = await _getDatabase();
    String? res = db.get("meta");
    if (res == null) {
      return null;
    }
    return MetaDetailedModel.fromJson(res);
  }

  /// 设置表情
  setEmojis(List<EmojiSimple> models) async {
    var db = await _getDatabase();
    db.put("emojis", jsonEncode(models));
  }

  /// 获取表情
  Future<List<EmojiSimple>?> getEmojis() async {
    var db = await _getDatabase();
    var res = db.get("emojis");
    if (res == null) {
      return null;
    }
    return List<EmojiSimple>.from(
        jsonDecode(res).map((x) => EmojiSimple.fromJson(x)));
  }
}
