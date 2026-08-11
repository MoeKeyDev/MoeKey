import 'package:flutter/widgets.dart';

/// Fades content without interpolating its outer dimensions.
///
/// The child participates in layout at its final size from the first frame;
/// only paint opacity is animated.
class TimelineFadeIn extends StatelessWidget {
  const TimelineFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0, end: 1),
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity, child: child),
      child: child,
    );
  }
}
