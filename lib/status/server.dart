import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moekey/database/init_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/models/login_user.dart';

part 'server.g.dart';

@Riverpod(keepAlive: true)
class SelectServerHost extends _$SelectServerHost {
  @override
  String build() {
    return "";
  }

  setServer(String host) {
    state = host;
    ref.notifyListeners();
  }
}

@Riverpod(keepAlive: true)
class LoginUserList extends _$LoginUserList {
  @override
  Map<String, LoginUser> build() {
    var list = getPreferencesDatabase().get("LoginUserList", defaultValue: {});
    return Map<String, LoginUser>.from(
      list.map((key, value) {
        return MapEntry<String, LoginUser>(key, LoginUser.fromMap(value));
      }),
    );
  }

  Future addUser(LoginUser user) async {
    var v = state;
    v[user.userInfo.id] = user;
    var db = getPreferencesDatabase();
    var list = db.get("LoginUserList", defaultValue: {});
    list[user.userInfo.id] = user.toMap();
    db.put("LoginUserList", list);
    ref.notifyListeners();
  }

  Future removeUser(String id) async {
    var v = state;
    v.remove(id);
    var db = getPreferencesDatabase();
    var list = db.get("LoginUserList", defaultValue: {});
    list.remove(id);
    db.put("LoginUserList", list);
    ref.notifyListeners();
  }
}

@Riverpod(keepAlive: true)
class CurrentLoginUser extends _$CurrentLoginUser {
  @override
  LoginUser? build() {
    try {
      var userList = ref.watch(loginUserListProvider);
      var preference = getPreferencesDatabase();
      var userid = preference.get("currentLoginUser", defaultValue: "");
      if (!userList.containsKey(userid)) {
        return null;
      }
      return userList[userid];
    } on TypeError catch (e) {
      print(e);
      print(e.stackTrace);
    }
    return null;
  }

  setLoginUser(String id) {
    var preference = getPreferencesDatabase();
    preference.put("currentLoginUser", id);
    var userList = ref.watch(loginUserListProvider);
    if (!userList.containsKey(id)) {
      return null;
    }
    state = userList[id];
    ref.notifyListeners();
  }
}

@riverpod
class ProxyServer extends _$ProxyServer {
  @override
  FutureOr<String> build() async {
    var prefs = await SharedPreferences.getInstance();
    if (kDebugMode && Platform.isWindows) {
      return "127.0.0.1:7890";
    }
    return prefs.getString("proxyServer ") ?? "";
  }

  Future setProxyServer(String host) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("proxyServer", host);
    state = AsyncValue.data(host);
  }
}
