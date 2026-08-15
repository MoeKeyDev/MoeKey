import 'dart:ui';

import 'package:flutter/material.dart';

class MkRefreshController extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

class DefaultMkRefreshController extends InheritedWidget {
  const DefaultMkRefreshController({
    super.key,
    required super.child,
    required this.controller,
  });

  final MkRefreshController controller;

  static MkRefreshController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DefaultMkRefreshController>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(covariant DefaultMkRefreshController oldWidget) {
    return oldWidget.controller != controller;
  }
}

class MkRefreshIndicator extends StatefulWidget {
  const MkRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.edgeOffset,
    this.controller,
    this.show = false,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final int? edgeOffset;
  final MkRefreshController? controller;
  final bool show;

  @override
  State<MkRefreshIndicator> createState() => _MkRefreshIndicatorState();
}

class _MkRefreshIndicatorState extends State<MkRefreshIndicator> {
  final GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  MkRefreshController? _controller;
  bool _showScheduled = false;

  void _updateController() {
    MkRefreshController? oldController = _controller;
    final newController =
        widget.controller ?? DefaultMkRefreshController.of(context);
    if (oldController == newController) return;
    oldController?.removeListener(_show);
    _controller = newController;
    _controller?.addListener(_show);
  }

  void _show() {
    final indicator = _indicatorKey.currentState;
    if (indicator == null) return;
    indicator.show();
    // A programmatic show can start after this subtree's build has completed.
    // Rebuilding once makes the indicator's snap state visible immediately,
    // even when the surrounding tab has just become active and is otherwise
    // static.
    if (mounted) setState(() {});
  }

  void _scheduleShow() {
    if (!widget.show || _showScheduled) return;
    _showScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showScheduled = false;
      if (mounted && widget.show) _show();
    });
  }

  @override
  void initState() {
    super.initState();
    _scheduleShow();
  }

  @override
  Widget build(BuildContext context) {
    var mediaPadding = MediaQuery.of(context).padding;
    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh,
      key: _indicatorKey,
      edgeOffset: mediaPadding.top + (widget.edgeOffset ?? 0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void didUpdateWidget(MkRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateController();
    if (widget.show && !oldWidget.show) _scheduleShow();
  }

  @override
  void dispose() {
    _controller?.removeListener(_show);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }
}
