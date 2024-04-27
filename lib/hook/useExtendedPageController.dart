import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ExtendedPageController useExtendedPageController({
  int initialPage = 0,
  bool keepPage = true,
  double pageSpacing = 0.0,
  bool shouldIgnorePointerWhenScrolling = false,
  double viewportFraction = 1.0,
  List<Object?>? keys,
}) {
  return use(
    _ScrollControllerHook(
        initialPage: initialPage,
        keepPage: keepPage,
        pageSpacing: pageSpacing,
        keys: keys,
        shouldIgnorePointerWhenScrolling: shouldIgnorePointerWhenScrolling,
        viewportFraction: viewportFraction),
  );
}

class _ScrollControllerHook extends Hook<ExtendedPageController> {
  const _ScrollControllerHook({
    required this.initialPage,
    required this.keepPage,
    required this.shouldIgnorePointerWhenScrolling,
    required this.pageSpacing,
    required this.viewportFraction,
    super.keys,
  });

  final int initialPage;
  final bool keepPage;
  final bool shouldIgnorePointerWhenScrolling;
  final double pageSpacing;
  final double viewportFraction;

  @override
  HookState<ExtendedPageController, Hook<ExtendedPageController>>
      createState() => _ScrollControllerHookState();
}

class _ScrollControllerHookState
    extends HookState<ExtendedPageController, _ScrollControllerHook> {
  late final controller = ExtendedPageController(
      initialPage: hook.initialPage,
      keepPage: hook.keepPage,
      pageSpacing: hook.pageSpacing,
      shouldIgnorePointerWhenScrolling: hook.shouldIgnorePointerWhenScrolling,
      viewportFraction: hook.viewportFraction);

  @override
  ExtendedPageController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useExtendedPageController';
}
