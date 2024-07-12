import 'package:moekey/apis/index.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../apis/models/login_user.dart';
import '../utils/get_token.dart';
import 'server.dart';

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

    var apis = MisskeyApis(instance: host, accessToken: "");

    var app = await apis.app.create();
    if (app == null) {
      throw Exception("登陆失败： 应用创建失败");
    }
    String secret = app.secret!;

    var authSession = await apis.auth.sessionGenerate(appSecret: secret);
    if (authSession == null) {
      throw Exception("登陆失败： token获取失败");
    }
    String token = authSession.token;
    String url = authSession.url;
    // 浏览器打开url完成认证
    launchUrlString(url);

    ref.onDispose(() => didDispose = true);
    while (true) {
      if (didDispose) break;
      await Future.delayed(const Duration(seconds: 1));
      var key = await apis.auth.sessionUserKey(appSecret: secret, token: token);
      if (key?["error"] != null) {
        if (key?["error"]["code"] == "PENDING_SESSION") {
          // 等待中
          continue;
        } else {
          // 失败
          throw Exception("登陆失败");
        }
      }
      if (key == null) {
        throw Exception("登陆失败");
      }
      if (key["accessToken"] != null) {
        // 成功登陆
        return LoginUser(
            id: key["user"]["id"],
            name: key["user"]["name"] ?? key["user"]["username"],
            serverUrl: host,
            token: getToken(key["accessToken"], secret),
            userInfo: UserFullModel.fromMap(key["user"]));
      }
    }
    return null;
  }
}
