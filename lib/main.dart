import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:moekey/database/init_database.dart';
import 'package:moekey/pages/home/home_page.dart';
import 'package:moekey/pages/login/login_page.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'generated/l10n.dart';
import 'status/websocket.dart';

var logger = Logger();

class HttpProxy extends HttpOverrides {
  String proxyServer = "";

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    if (kDebugMode) {
      proxyServer = "127.0.0.1:7890";
    }
    if (proxyServer == "") {
      return super.findProxyFromEnvironment(url, environment);
    }
    environment ??= {};
    environment['http_proxy'] = proxyServer;
    environment['https_proxy'] = proxyServer;
    return super.findProxyFromEnvironment(url, environment);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 视频初始化
  MediaKit.ensureInitialized();

  // 代理配置
  HttpOverrides.global = HttpProxy();

  // 初始化数据库
  await initDatabase();

  runApp(const ProviderScope(child: MyApp()));
}

final globalNav = GlobalKey<NavigatorState>();
final globalMaterialAppKey = GlobalKey();

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNav,
      key: globalMaterialAppKey,
      theme: theme,
      home: const SplashPage(),
      // builder: (context, child) {
      //   return Overlay();
      // },
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(currentLoginUserProvider);
    // 启动webSocket
    ref.watch(moekeyGlobalEventProvider);
    ref.watch(moekeyMainChannelProvider);
    var isLaunch = useState(false);
    useEffect(() {
      if (isLaunch.value) return;
      isLaunch.value = true;
      Future.delayed(
        Duration.zero,
        () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) {
              if (user != null) {
                return HomePage();
              }
              return const LoginPage();
            },
          ), (route) => false);
        },
      );

      return null;
    }, []);
    return const Scaffold(
      body: LoadingWidget(),
    );
  }
}
