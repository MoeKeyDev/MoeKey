import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

class CustomRectTween extends RectTween {
  CustomRectTween({required Rect a, required Rect b, Curve? curve})
    : curve = curve ?? const Cubic(0.2, 0, 0, 1),
      super(begin: a, end: b);

  /// An emphasized ease-out keeps the thumbnail responsive at the start while
  /// letting it settle gently into the full preview bounds.
  final Curve curve;

  @override
  Rect lerp(double t) {
    return Rect.lerp(begin, end, curve.transform(t))!;
  }
}
