import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initDatabase() async {
  // 初始化Hive
  // 文档 https://docs.hivedb.dev/
  final appDocumentDirectory = await getApplicationSupportDirectory();
  Hive.init(appDocumentDirectory.path);

  await Hive.openBox<String>("preferences_string");
}

class Preferences {
  static Box<String> getPreferencesDatabase() {
    return Hive.box<String>("preferences_string");
  }

  static get(String key, {dynamic defaultValue}) {
    var value = getPreferencesDatabase().get(key);
    if (value == null) {
      return defaultValue;
    }
    return jsonDecode(value);
  }

  static set(String key, dynamic value) {
    getPreferencesDatabase().put(key, jsonEncode(value));
  }
}

Preferences getPreferencesDatabase() {
  return Preferences();
}

Future<Box<T>> openDatabase<T>({
  required String name,
  String? server,
  String? user,
}) async {
  if (user != null) {
    name = "$user-$name";
  }
  if (server != null) {
    var host = Uri.parse(server).host;
    name = "$host-$name";
  }

  return Hive.openBox<T>(name);
}

Future<LazyBox<T>> openLazyDatabase<T>({
  required String name,
  String? server,
  String? user,
}) async {
  if (user != null) {
    name = "$user-$name";
  }
  if (server != null) {
    var host = Uri.parse(server).host;
    name = "$host-$name";
  }
  return Hive.openLazyBox<T>(name);
}
