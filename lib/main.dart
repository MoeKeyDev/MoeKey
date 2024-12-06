import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/router/router.dart';
import 'package:moekey/status/themes.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  // 初始化BlurHash
  await BlurHash.loadShader();
  runApp(const ProviderScope(child: MyApp()));
}

// final globalNav = GlobalKey<NavigatorState>();

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themesProvider);
    var mediaQueryData = MediaQuery.of(context);
    mediaQueryData = mediaQueryData.copyWith(textScaler: TextScaler.linear(1));
    // return MediaQuery(
    //   data: mediaQueryData,
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     navigatorKey: globalNav,
    //     theme: theme,
    //     home: const SplashPage(),
    //     // builder: (context, child) {
    //     //   return Overlay();
    //     // },
    //     localizationsDelegates: const [
    //       S.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate,
    //       GlobalCupertinoLocalizations.delegate,
    //     ],
    //     supportedLocales: S.delegate.supportedLocales,
    //   ),
    // );
    return MediaQuery(
        data: mediaQueryData,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: theme,
          routerConfig: ref.watch(routerProvider),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        ));
  }
}
