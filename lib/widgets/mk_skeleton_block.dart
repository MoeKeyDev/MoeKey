import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

/// A basic shimmer block used to compose loading placeholders.
class MkSkeletonBlock extends StatelessWidget {
  const MkSkeletonBlock({
    super.key,
    required this.height,
    this.color,
    this.width,
    this.widthFactor,
    this.alignment = Alignment.centerLeft,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.shape = BoxShape.rectangle,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1600),
  }) : assert(widthFactor == null || (widthFactor > 0 && widthFactor <= 1));

  /// Defaults to the current Misskey foreground color at 10% opacity.
  final Color? color;
  final double height;
  final double? width;
  final double? widthFactor;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry borderRadius;
  final BoxShape shape;
  final bool animated;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final explicitColor = color;
    if (explicitColor != null) {
      return _buildBlock(explicitColor);
    }
    return Consumer(
      builder: (context, ref, child) {
        final themeColor = ref.watch(
          themeColorsProvider.select((themes) => themes.fgColor),
        );
        return _buildBlock(themeColor.withValues(alpha: 0.1));
      },
    );
  }

  Widget _buildBlock(Color effectiveColor) {
    Widget block = SizedBox(
      width: width,
      height: height,
      child: _SkeletonWave(
        color: effectiveColor,
        borderRadius: borderRadius,
        shape: shape,
        enabled: animated,
        duration: animationDuration,
      ),
    );

    final factor = widthFactor;
    if (factor != null) {
      block = FractionallySizedBox(
        alignment: alignment,
        widthFactor: factor,
        child: block,
      );
    }

    return ExcludeSemantics(child: block);
  }
}

class _SkeletonWave extends StatefulWidget {
  const _SkeletonWave({
    required this.color,
    required this.borderRadius,
    required this.shape,
    required this.enabled,
    required this.duration,
  });

  final Color color;
  final BorderRadiusGeometry borderRadius;
  final BoxShape shape;
  final bool enabled;
  final Duration duration;

  @override
  State<_SkeletonWave> createState() => _SkeletonWaveState();
}

class _SkeletonWaveState extends State<_SkeletonWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _syncAnimation();
  }

  @override
  void didUpdateWidget(_SkeletonWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.duration != widget.duration) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (widget.enabled && !_reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedBorderRadius = widget.shape == BoxShape.rectangle
        ? widget.borderRadius.resolve(Directionality.of(context))
        : BorderRadius.zero;
    if (!widget.enabled || _reduceMotion) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.rectangle
              ? resolvedBorderRadius
              : null,
        ),
      );
    }

    return CustomPaint(
      painter: _SkeletonWavePainter(
        animation: _controller,
        color: widget.color,
        borderRadius: resolvedBorderRadius,
        shape: widget.shape,
      ),
    );
  }
}

class _SkeletonWavePainter extends CustomPainter {
  _SkeletonWavePainter({
    required this.animation,
    required this.color,
    required this.borderRadius,
    required this.shape,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;
  final BorderRadius borderRadius;
  final BoxShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final bounds = Offset.zero & size;
    final highlightColor = Color.lerp(
      color,
      Colors.white.withValues(alpha: color.a),
      0.22,
    )!.withValues(alpha: (color.a * 1.55 + 0.015).clamp(0.0, 1.0));
    final bandWidth = size.width * 1.05 + size.height * 0.25;
    final bandCenter =
        -bandWidth / 2 + (size.width + bandWidth) * animation.value;
    final paint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [color, color, highlightColor, color, color],
            stops: const [0, 0.15, 0.5, 0.85, 1],
          ).createShader(
            Rect.fromLTWH(
              bandCenter - bandWidth / 2,
              0,
              bandWidth,
              size.height,
            ),
          );

    if (shape == BoxShape.circle) {
      canvas.drawOval(bounds, paint);
    } else {
      canvas.drawRRect(borderRadius.toRRect(bounds), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SkeletonWavePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shape != shape ||
        oldDelegate.animation != animation;
  }
}
