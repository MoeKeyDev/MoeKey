import 'package:flutter/material.dart';

class MfmJellyCode extends StatefulWidget {
  const MfmJellyCode({
    super.key,
    required this.child,
    this.speed,
  });

  final Widget child;
  final Duration? speed;

  @override
  State<MfmJellyCode> createState() => _SpinCodeState();
}

class _SpinCodeState extends State<MfmJellyCode>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleXAnimation;
  final _scaleXSequence = TweenSequence([
    TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.25), weight: 30), // 0% -> 30%
    TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 0.75), weight: 10), // 30% -> 40%
    TweenSequenceItem(
        tween: Tween(begin: 0.75, end: 1.15), weight: 10), // 40% -> 50%
    TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.95), weight: 15), // 50% -> 65%
    TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.05), weight: 10), // 65% -> 75%
    TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 1.0), weight: 25), // 75% -> 100%> 35%
  ]);

  late Animation<double> _scaleYAnimation;
  final _scaleYSequence = TweenSequence([
    TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.75), weight: 30), // 0% -> 30%
    TweenSequenceItem(
        tween: Tween(begin: 0.75, end: 1.25), weight: 10), // 30% -> 40%
    TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 0.85), weight: 10), // 40% -> 50%
    TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.05), weight: 15), // 50% -> 65%
    TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 0.95), weight: 10), // 65% -> 75%
    TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0), weight: 25), // 75% -> 100%> 35%
  ]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.speed);

    _scaleXAnimation = _controller.drive(_scaleXSequence);
    _scaleYAnimation = _controller.drive(_scaleYSequence);

    Future(() async {
      _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
                _scaleXAnimation.value, _scaleYAnimation.value, 1.0),
            child: widget.child,
          );
        });
  }
}
