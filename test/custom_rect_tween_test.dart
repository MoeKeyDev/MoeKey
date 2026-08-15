import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/utils/custom_rect_tween.dart';

void main() {
  test('hero rect tween preserves its exact endpoints', () {
    const begin = Rect.fromLTWH(24, 160, 120, 80);
    const end = Rect.fromLTWH(0, 0, 800, 600);
    final tween = CustomRectTween(a: begin, b: end);

    expect(tween.lerp(0), begin);
    expect(tween.lerp(1), end);
  });

  test('hero rect tween moves monotonically toward the destination', () {
    const begin = Rect.fromLTWH(40, 240, 100, 60);
    const end = Rect.fromLTWH(0, 0, 600, 800);
    final tween = CustomRectTween(a: begin, b: end);
    final first = tween.lerp(0.25);
    final second = tween.lerp(0.75);

    expect(second.top, lessThan(first.top));
    expect(second.width, greaterThan(first.width));
    expect(second.height, greaterThan(first.height));
  });
}
