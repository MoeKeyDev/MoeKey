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

/// Applies accumulated note-height deltas through Flutter's official
/// new-content-dimensions correction phase. The viewport reruns layout before
/// painting whenever this returns a different pixel offset.
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
    return base + correction.take();
  }
}

/// Reports changes to a note's outer size during layout.
///
/// Descendants do not need to know about the timeline. Images, emoji wraps,
/// previews, and expanded content can lay themselves out normally; the list
/// receives one delta for the final outer note size.
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
