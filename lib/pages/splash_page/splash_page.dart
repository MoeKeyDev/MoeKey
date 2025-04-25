import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:moekey/status/apis.dart';

import '../../database/init_database.dart';
import '../../status/server.dart';
import '../../status/websocket.dart';
import '../../widgets/loading_weight.dart';

class HttpProxy extends HttpOverrides {
  String proxyServer = "";

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    // if (kDebugMode) {
    //   proxyServer = "127.0.0.1:7890";
    // }
    if (proxyServer == "") {
      return super.findProxyFromEnvironment(url, environment);
    }
    environment ??= {};
    environment['http_proxy'] = proxyServer;
    environment['https_proxy'] = proxyServer;
    return super.findProxyFromEnvironment(url, environment);
  }
}

Future initApp(BuildContext context, WidgetRef ref) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 视频初始化
  MediaKit.ensureInitialized();

  // 代理配置
  HttpOverrides.global = HttpProxy();

  // 初始化数据库
  await initDatabase();

  var user = ref.read(currentLoginUserProvider);
  // 启动webSocket
  ref.read(moekeyGlobalEventProvider);
  ref.read(moekeyMainChannelProvider);
  if (user != null) {
    if (context.mounted) {
      await ref.read(instanceMetaProvider.future);
      if (!context.mounted) {
        return null;
      }
      context.replace("/timeline");
      return null;
    }
  }
  if (context.mounted) {
    context.replace("/login");
  }
}

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isLaunch = useState(false);
    useEffect(() {
      initApp(context, ref).then((value) {
        isLaunch.value = true;
      });
      return null;
    }, const []);
    return const Scaffold(
      body: LoadingWidget(),
    );
  }
}
