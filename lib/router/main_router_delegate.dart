import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainRouterDelegate extends RouterDelegate<RouterItem>
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  final _stack = <RouterItem>[];

  List<RouterItem> get stack => _stack;

  static MainRouterDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MainRouterDelegate, 'Delegate type must match');
    return delegate as MainRouterDelegate;
  }

  MainRouterDelegate({required RouterItem initRouter}) {
    initPath = initRouter.path;
    _stack.add(initRouter);
  }

  late String initPath;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  RouterItem? get currentConfiguration =>
      _stack.isNotEmpty ? _stack.last : null;
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        for (var item in _stack)
          if (item.animated)
            MaterialPage(child: item.page())
          else
            MyPage(
              key: ValueKey(item.path),
              child: item.page(),
            )
      ],
      onPopPage: (route, result) {
        _stack.removeLast();

        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouterItem configuration) {
    if (_stack.isEmpty || configuration.path != _stack.last.path) {
      if (configuration.launchMode == LaunchMode.standard) {
        _stack.add(configuration);
      } else if (configuration.launchMode == LaunchMode.single) {
        // 遍历路由栈
        bool notFind = true;
        for (var (index, element) in _stack.indexed) {
          if (element.path == configuration.path) {
            var tmp = _stack.removeAt(index);
            _stack.add(tmp);
            notFind = false;
            break;
          }
        }
        if (notFind) {
          _stack.add(configuration);
        }
      }
      notifyListeners();
    }
    return SynchronousFuture<void>(null);
  }
}

class RouterItem {
  String path;
  Widget Function() page;
  LaunchMode launchMode;
  bool animated;
  RouterItem({
    required this.path,
    required this.page,
    this.launchMode = LaunchMode.standard,
    this.animated = true,
  });

  @override
  String toString() {
    return 'RouterItem{path: $path, page: $page, launchMode: $launchMode}';
  }
}

enum LaunchMode {
  // 普通
  standard("standard"),
  // 单例
  single("single");

  const LaunchMode(this.launchMode);

  final String launchMode;
}

class MyPage<T> extends Page<T> {
  /// Creates a material page.
  const MyPage({
    required this.child,
    super.key,
  });

  /// The content to be shown in the [Route] created by this page.
  final Widget child;
  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) {
        return this.child;
      },
    );
  }
}
