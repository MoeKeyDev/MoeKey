import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverFixedHeader extends SingleChildRenderObjectWidget {
  const SliverFixedHeader({
    super.key,
    required this.pinnedOffset,
    required Widget child,
  }) : super(child: child);

  final double pinnedOffset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverFixedHeader(pinnedOffset: pinnedOffset);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverFixedHeader renderObject) {
    renderObject.pinnedOffset = pinnedOffset;
  }
}

class RenderSliverFixedHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverFixedHeader({required double pinnedOffset})
      : _pinnedOffset = pinnedOffset;

  late double _pinnedOffset = 0;

  set pinnedOffset(double value) {
    if (_pinnedOffset == value) {
      return;
    }
    _pinnedOffset = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    // 1.对子节点进行约束 SliverConstraints
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    final paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);

    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    final topOffset =
        constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
    double origin = 0;
    if (topOffset <= _pinnedOffset) {
      origin = _pinnedOffset - topOffset;
    }
    final paintExtent = min(constraints.remainingPaintExtent, origin);
    // 2.上报当前节点的布局信息给 viewport
    geometry = SliverGeometry(
      // visible: paintExtent > 0.0
      paintOrigin: paintExtent,
      scrollExtent: childExtent,
      paintExtent: min(constraints.remainingPaintExtent, childExtent),
      layoutExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
    );
  }

// @override
// void paint(PaintingContext context, Offset offset) {
//   if (child != null && geometry!.visible) {
//     final SliverPhysicalParentData childParentData =
//         child!.parentData! as SliverPhysicalParentData;
//     // 4.绘制子节点
//     // topOffset = constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
//     //其中 offset = topOffset(sliver 到达顶部后等于 0） + paintOrigin(默认等于0）
//     //其中 paintOffset(默认等于0)
//     //即到达顶部后，如果两者都等于0，并且 visible 不等于 false，则 child 保持当前位置不变。
//     context.paintChild(child!, offset + childParentData.paintOffset);
//   }
// }

// @override
// double childMainAxisPosition(RenderBox child) {
//   return 0;
// }
}
