import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:moekey/models/login_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<Map<String, LoginUser>> build() async {
    var prefs = await SharedPreferences.getInstance();
    Map<String, LoginUser> loginUserList = {};
    if (prefs.getString("loginUserList") != null) {
      Map<String, dynamic> res =
          jsonDecode(prefs.getString("loginUserList") ?? "");

      res.forEach((key, value) {
        loginUserList[key] = LoginUser(
            serverUrl: value["serverUrl"],
            token: value["token"],
            userInfo: value["userInfo"],
            name: value["name"],
            id: value["id"]);
      });
    }
    return loginUserList;
  }

  Future addUser(LoginUser user) async {
    var v = state.value ?? {};
    v[user.userInfo["id"]] = user;
    state = AsyncData(v);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("loginUserList", jsonEncode(v));
  }
}

@Riverpod(keepAlive: true)
class CurrentLoginUser extends _$CurrentLoginUser {
  @override
  FutureOr<LoginUser?> build() async {
    var prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString("currentLoginUser") ?? "";
    var userList = await ref.watch(loginUserListProvider.future);
    return userList[userid];
  }

  Future setLoginUser(String id) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("currentLoginUser", id);
    var userList = await ref.watch(loginUserListProvider.future);
    state = AsyncData(userList[id]);
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
