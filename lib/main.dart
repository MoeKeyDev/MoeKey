import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:moekey/pages/home/home_page.dart';
import 'package:moekey/pages/login/login_page.dart';
import 'package:moekey/state/server.dart';
import 'package:moekey/state/themes.dart';
import 'package:moekey/widgets/loading_weight.dart';

import 'generated/l10n.dart';
import 'networks/websocket.dart';

var logger = Logger();

class HttpProxy extends HttpOverrides {
  String proxyServer = "";

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    if (kDebugMode) {
      proxyServer = "172.20.1.200:7890";
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  HttpOverrides.global = HttpProxy();
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //       statusBarColor: Colors.transparent,
  //       statusBarBrightness: Brightness.dark,
  //       statusBarIconBrightness: Brightness.dark,
  //       systemNavigationBarColor: Colors.transparent,
  //       systemNavigationBarIconBrightness: Brightness.dark),
  // );
  runApp(const ProviderScope(child: MyApp()));
}

final globalNav = GlobalKey<NavigatorState>();
final globalMaterialAppKey = GlobalKey();
final ContextMenuController globalContextMenuController =
    ContextMenuController();

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
    var user = ref.watch(currentLoginUserProvider.future);
    // 启动webSocket
    ref.watch(moekeyGlobalEventProvider);
    ref.watch(moekeyMainChannelProvider);
    var isLaunch = useState(false);
    Future.wait([user]).then((value) async {
      if (isLaunch.value) return;
      isLaunch.value = true;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          if (value[0] != null) {
            return HomePage();
          }
          return const LoginPage();
        },
      ), (route) => false);
    });
    return const Scaffold(
      body: LoadingWidget(),
    );
  }
}
