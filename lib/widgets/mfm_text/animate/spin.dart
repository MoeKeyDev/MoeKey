import 'dart:math';

import 'package:flutter/material.dart';

class MfmSpinCode extends StatefulWidget {
  const MfmSpinCode(
      {super.key,
      required this.child,
      this.x = false,
      this.y = false,
      this.speed,
      this.left = false,
      this.alternate = false});

  final Widget child;
  final bool x;
  final bool y;
  final Duration? speed;
  final bool left;
  final bool alternate;

  @override
  State<MfmSpinCode> createState() => _SpinCodeState();
}

class _SpinCodeState extends State<MfmSpinCode>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animate;

  @override
  void initState() {
    super.initState();
    var duration = widget.speed ?? const Duration(milliseconds: 1500);
    controller = AnimationController(duration: duration, vsync: this);
    animate = Tween(
            begin: widget.left ? 2 * pi : 0.0, end: widget.left ? 0.0 : 2 * pi)
        .animate(controller);
    controller.repeat(reverse: widget.alternate);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Matrix4 transform = Matrix4.identity()..setEntry(3, 2, 0.01);
    if (!widget.x && !widget.y) {
      transform.rotateZ(animate.value);
    }
    if (widget.x) {
      transform.rotateX(animate.value);
    }
    if (widget.y) {
      transform.rotateY(-animate.value);
    }
    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: widget.child,
    );
  }
}
