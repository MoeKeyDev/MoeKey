import 'package:flutter/animation.dart';

class CustomRectTween extends RectTween {
  CustomRectTween({this.a, this.b}) : super(begin: a, end: b);
  final Rect? a;
  final Rect? b;

  @override
  Rect lerp(double t) {
    // Curves.elasticOut.transform(t);
    //any curve can be applied here e.g. Curve.elasticOut.transform(t);
    // final verticalDist = Cubic(0.72, 0.15, 0.5, 1).transform(t);

    final top = lerpDouble(a?.top, b?.top, t) * (1 - t);
    return Rect.fromLTRB(
      lerpDouble(a?.left, b?.left, t),
      top,
      lerpDouble(a?.right, b?.right, t),
      lerpDouble(a?.bottom, b?.bottom, t),
    );
  }

  double lerpDouble(num? a, num? b, double t) {
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
