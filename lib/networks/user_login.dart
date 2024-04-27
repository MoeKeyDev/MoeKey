import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/login_user.dart';
import '../state/server.dart';
import '../utils/getToken.dart';
import 'dio.dart';

part 'user_login.g.dart';

@riverpod
class ApiUserLogin extends _$ApiUserLogin {
  var didDispose = false;

  @override
  FutureOr<LoginUser> build() async {
    var userModel = await login();
    if (userModel == null) {
      throw Exception("登陆失败");
    }
    // 保存
    await ref.watch(loginUserListProvider.notifier).addUser(userModel);
    await ref
        .watch(currentLoginUserProvider.notifier)
        .setLoginUser(userModel.id);
    return userModel;
  }

  Future<LoginUser?> login() async {
    var host = ref.read(selectServerHostProvider);
    var app = await createApp();
    String secret = app["secret"];

    var authSession = await authSessionGenerate(secret);
    String token = authSession["token"];
    String url = authSession["url"];
    launchUrlString(url);

    ref.onDispose(() => didDispose = true);
    while (true) {
      if (didDispose) break;
      await Future.delayed(const Duration(seconds: 1));
      var key = await authSessionUserKey(secret, token);
      if (key["error"] != null) {
        if (key["error"]["code"] == "PENDING_SESSION") {
          // 等待中
          continue;
        } else {
          // 失败
          throw Exception("登陆失败");
        }
      }

      if (key["accessToken"] != null) {
        // 成功登陆
        return LoginUser(
            id: key["user"]["id"],
            name: key["user"]["name"] ?? key["user"]["username"],
            serverUrl: host,
            token: getToken(key["accessToken"], secret),
            userInfo: key["user"]);
      }
    }
    return null;
  }

  Future<Map> createApp() async {
    var http = ref.read(selectHttpProvider);
    var data = await http.post("/app/create", data: {
      "name": "MoeKey",
      "description": "app",
      "permission": [
        "read:account",
        "write:account",
        "read:blocks",
        "write:blocks",
        "read:drive",
        "write:drive",
        "read:favorites",
        "write:favorites",
        "read:following",
        "write:following",
        "read:messaging",
        "write:messaging",
        "read:mutes",
        "write:mutes",
        "write:notes",
        "read:notifications",
        "write:notifications",
        "write:reactions",
        "write:votes",
        "read:pages",
        "write:pages",
        "write:page-likes",
        "read:page-likes",
        "write:gallery-likes",
        "read:gallery-likes",
        "write:clip-favorite",
        "read:clip-favorite",
      ]
    });
    return data.data;
  }

  Future<Map> authSessionGenerate(String appSecret) async {
    var http = ref.read(selectHttpProvider);
    var data = await http
        .post("/auth/session/generate", data: {"appSecret": appSecret});
    return data.data;
  }

  Future<Map> authSessionUserKey(String appSecret, String token) async {
    var http = ref.read(selectHttpProvider);
    var data = await http.post(
      "/auth/session/userkey",
      data: {"appSecret": appSecret, "token": token},
      options: Options(
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    return data.data;
  }
}
