import 'package:flutter/material.dart';

/// 视差组件
class Parallax extends StatelessWidget {
  const Parallax({super.key, required this.child, required this.offset});

  /// 子组件
  final Widget child;

  /// 偏移量 [-1.0  - 1.0]
  final double offset;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      // clipBehavior: Clip.none,
      child: CustomSingleChildLayout(
        delegate: _ParallaxDelegate(offset: offset),
        child: child,
      ),
    );
  }
}

class _ParallaxDelegate extends SingleChildLayoutDelegate {
  final double offset;

  @override
  bool shouldRelayout(covariant _ParallaxDelegate oldDelegate) {
    return oldDelegate.offset != offset;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
        maxHeight: double.infinity,
        minHeight: constraints.maxHeight,
        maxWidth: constraints.maxWidth,
        minWidth: constraints.maxWidth);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if (childSize.height <= size.height) return Offset.zero;
    var centerOffset = (childSize.height - size.height) / 2;
    var offset1 = (childSize.height - size.height) * offset;
    // 防止组件移动过快
    if (offset1 >= size.height * offset) {
      offset1 = size.height * offset;
    }
    return Offset(0, offset1 * 0.5 - centerOffset);
  }

  _ParallaxDelegate({required this.offset});
}
