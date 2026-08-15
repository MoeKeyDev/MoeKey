import 'package:flutter/material.dart';

class TimelineInsertTransition extends StatefulWidget {
  const TimelineInsertTransition({
    super.key,
    required this.animate,
    required this.child,
  });

  final bool animate;
  final Widget child;

  @override
  State<TimelineInsertTransition> createState() =>
      _TimelineInsertTransitionState();
}

class _TimelineInsertTransitionState extends State<TimelineInsertTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> size;
  late final Animation<double> opacity;
  late final Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: widget.animate ? 0 : 1,
    );
    size = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
    opacity = CurvedAnimation(
      parent: controller,
      curve: const Interval(0, 0.9, curve: Curves.easeOutCubic),
    );
    offset = Tween<Offset>(
      begin: const Offset(0, -0.025),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    if (widget.animate) {
      _startIfVisible();
    }
  }

  @override
  void didUpdateWidget(TimelineInsertTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.animate && widget.animate && controller.value == 1) {
      _startIfVisible(restart: true);
    }
  }

  void _startIfVisible({bool restart = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_intersectsViewport()) {
        controller.value = 1;
        return;
      }
      if (restart) {
        controller.forward(from: 0);
      } else {
        controller.forward();
      }
    });
  }

  bool _intersectsViewport() {
    final itemBox = context.findRenderObject();
    final scrollable = Scrollable.maybeOf(context);
    final viewportBox = scrollable?.context.findRenderObject();
    if (itemBox is! RenderBox ||
        viewportBox is! RenderBox ||
        !itemBox.hasSize ||
        !viewportBox.hasSize) {
      return false;
    }
    final itemTop = itemBox.localToGlobal(Offset.zero).dy;
    final itemBottom = itemTop + itemBox.size.height;
    final viewportTop = viewportBox.localToGlobal(Offset.zero).dy;
    final viewportBottom = viewportTop + viewportBox.size.height;
    return itemBottom >= viewportTop && itemTop < viewportBottom;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: size,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: opacity,
        child: SlideTransition(position: offset, child: widget.child),
      ),
    );
  }
}
