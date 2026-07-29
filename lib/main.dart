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
class WindowSize extends InheritedWidget {
  const WindowSize({super.key, required this.isWide, required super.child});

  final bool isWide;

  static WindowSize? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WindowSize>();
  }

  @override
  bool updateShouldNotify(WindowSize oldWidget) {
    return isWide != oldWidget.isWide;
  }
}

class WindowSizeProvider extends HookConsumerWidget {
  const WindowSizeProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var isWide = constraints.maxWidth > 800;
        return WindowSize(isWide: isWide, child: child);
      },
    );
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themesProvider);
    // 获取 MediaQuery 的 platformBrightness
    var platformBrightness = MediaQuery.platformBrightnessOf(context);
    ref.watch(systemBrightnessProvider);
    // 更新 Provider 的值
    Future.delayed(Duration.zero, () {
      ref
          .read(systemBrightnessProvider.notifier)
          .updateBrightness(platformBrightness);
    });

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
    return WindowSizeProvider(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: ref.watch(routerProvider),
        builder: (context, child) {
          // Keep the app-wide text scale override below MaterialApp. Reading
          // MediaQuery.of above MaterialApp made MyApp and the router rebuild
          // for every animated keyboard inset frame.
          return MediaQuery.withNoTextScaling(
            child: child ?? const SizedBox.shrink(),
          );
        },
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
