import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef TimelineNoteSizeChanged =
    void Function(String noteId, Size oldSize, Size newSize);

class TimelineLayoutCorrection {
  double _pending = 0;

  void add(double delta) {
    _pending += delta;
  }

  double take() {
    final value = _pending;
    _pending = 0;
    return value;
  }
}

/// Keeps the visible content stationary when a note above it changes height.
///
/// Corrections are only applied while the list is idle. Applying one during a
/// drag or ballistic scroll would compete with the user's movement and can
/// visibly push the viewport in the opposite direction.
class TimelineSizeMaintainingScrollPhysics extends ScrollPhysics {
  const TimelineSizeMaintainingScrollPhysics({
    required this.correction,
    super.parent,
  });

  final TimelineLayoutCorrection correction;

  @override
  TimelineSizeMaintainingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TimelineSizeMaintainingScrollPhysics(
      correction: correction,
      parent: buildParent(ancestor),
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    final base = super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
    final pendingCorrection = correction.take();
    return isScrolling ? base : base + pendingCorrection;
  }
}

class TimelineNoteSizeObserver extends SingleChildRenderObjectWidget {
  const TimelineNoteSizeObserver({
    super.key,
    required this.noteId,
    required this.onSizeChanged,
    required super.child,
  });

  final String noteId;
  final TimelineNoteSizeChanged onSizeChanged;

  @override
  RenderTimelineNoteSizeObserver createRenderObject(BuildContext context) {
    return RenderTimelineNoteSizeObserver(
      noteId: noteId,
      onSizeChanged: onSizeChanged,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTimelineNoteSizeObserver renderObject,
  ) {
    renderObject
      ..noteId = noteId
      ..onSizeChanged = onSizeChanged;
  }
}

class RenderTimelineNoteSizeObserver extends RenderProxyBox {
  RenderTimelineNoteSizeObserver({
    required this.noteId,
    required this.onSizeChanged,
  });

  String noteId;
  TimelineNoteSizeChanged onSizeChanged;
  Size? _previousSize;

  @override
  void performLayout() {
    super.performLayout();
    final previousSize = _previousSize;
    _previousSize = size;
    if (previousSize == null || previousSize == size) return;
    onSizeChanged(noteId, previousSize, size);
  }
}
