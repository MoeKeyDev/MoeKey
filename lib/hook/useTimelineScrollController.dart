import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/timeline_listview.dart';

TimelineScrollController useTimelineScrollController({
  bool keepScrollOffset = true,
  double initialScrollOffset = 0.0,
  List<Object?>? keys,
}) {
  return use(
    _ScrollControllerHook(
      keepScrollOffset: keepScrollOffset,
      initialScrollOffset: initialScrollOffset,
    ),
  );
}

class _ScrollControllerHook extends Hook<TimelineScrollController> {
  const _ScrollControllerHook({
    required this.keepScrollOffset,
    required this.initialScrollOffset,
    List<Object?>? keys,
  }) : super(keys: keys);

  final bool keepScrollOffset;
  final double initialScrollOffset;

  @override
  HookState<TimelineScrollController, Hook<TimelineScrollController>>
      createState() => _ScrollControllerHookState();
}

class _ScrollControllerHookState
    extends HookState<TimelineScrollController, _ScrollControllerHook> {
  late final controller = TimelineScrollController(
      keepScrollOffset: hook.keepScrollOffset,
      initialScrollOffset: hook.initialScrollOffset);

  @override
  TimelineScrollController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useExtendedPageController';
}
