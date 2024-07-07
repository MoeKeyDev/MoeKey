import 'dart:ui';

import 'package:flutter/material.dart';

class MkRefreshController extends ChangeNotifier {
  refresh() {
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
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final int? edgeOffset;
  final MkRefreshController? controller;

  @override
  State<MkRefreshIndicator> createState() => _MkRefreshIndicatorState();
}

class _MkRefreshIndicatorState extends State<MkRefreshIndicator> {
  final GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  MkRefreshController? _controller;

  _updateController() {
    MkRefreshController? oldController = _controller;
    _controller = widget.controller ?? DefaultMkRefreshController.of(context);
    if (oldController != _controller) {
      oldController?.removeListener(_show);
    }
    _controller?.addListener(_show);
  }

  _show() {
    _indicatorKey.currentState?.show();
  }

  @override
  void initState() {
    super.initState();
    // _updateController();
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
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void didUpdateWidget(MkRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateController();
  }

  @override
  void dispose() {
    _controller?.addListener(_show);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }
}
