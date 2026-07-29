import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

enum MobileComposerPanel { hidden, attachments, emoji }

class MobileComposerKeyboardMetrics {
  double inset = 0;
  double lastVisibleHeight = 0;
}

class MobileComposerDragHandle extends StatelessWidget {
  const MobileComposerDragHandle({
    super.key,
    required this.onDrag,
    required this.onDragEnd,
  });

  final ValueChanged<double> onDrag;
  final ValueChanged<double> onDragEnd;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeUpDown,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) => onDrag(-details.delta.dy),
        onVerticalDragEnd: (details) {
          onDragEnd(-(details.primaryVelocity ?? 0));
        },
        onVerticalDragCancel: () => onDragEnd(0),
        child: SizedBox(
          height: 24,
          width: double.infinity,
          child: Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One bottom slot shared by the system keyboard and composer panels.
///
/// When a panel replaces an open keyboard, [panelHeight] is captured from the
/// keyboard. The panel is laid out behind the keyboard before focus is
/// released, so the toolbar stays still while the keyboard reveals the panel.
class MobileComposerBottomArea extends StatefulWidget {
  const MobileComposerBottomArea({
    super.key,
    required this.mode,
    required this.panelHeight,
    required this.metrics,
    required this.switchingToKeyboard,
    required this.onKeyboardSettled,
    required this.onResize,
    required this.onResizeEnd,
    this.horizontalPaintOverflow = 0,
    this.backgroundColor,
    required this.child,
  });

  final MobileComposerPanel mode;
  final double panelHeight;
  final MobileComposerKeyboardMetrics metrics;
  final bool switchingToKeyboard;
  final VoidCallback onKeyboardSettled;
  final ValueChanged<double> onResize;
  final ValueChanged<double> onResizeEnd;
  final double horizontalPaintOverflow;
  final Color? backgroundColor;
  final Widget child;

  @override
  State<MobileComposerBottomArea> createState() =>
      _MobileComposerBottomAreaState();
}

class _MobileComposerBottomAreaState extends State<MobileComposerBottomArea> {
  static const _keyboardSettleDelay = Duration(milliseconds: 80);
  static const _panelAnimationDuration = Duration(milliseconds: 220);

  Timer? _keyboardSettleTimer;
  Timer? _keyboardHeightCaptureTimer;
  double _keyboardInset = 0;
  bool _animatePanelHeight = false;
  bool _animateNextPanelResize = false;
  bool _isAnimatingToKeyboardMinimum = false;
  double _keyboardTransitionStartHeight = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateKeyboardInset();
  }

  @override
  void didUpdateWidget(MobileComposerBottomArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    final panelVisibilityChanged =
        (oldWidget.mode == MobileComposerPanel.hidden) !=
        (widget.mode == MobileComposerPanel.hidden);
    final panelHeightChanged = oldWidget.panelHeight != widget.panelHeight;
    final startedSwitchingToKeyboard =
        !oldWidget.switchingToKeyboard && widget.switchingToKeyboard;
    if (startedSwitchingToKeyboard &&
        panelHeightChanged &&
        _keyboardInset == 0) {
      _isAnimatingToKeyboardMinimum = true;
      _keyboardTransitionStartHeight = oldWidget.panelHeight;
      _animatePanelHeight = false;
    } else if (_isAnimatingToKeyboardMinimum && widget.switchingToKeyboard) {
      // Follow the platform keyboard frames instead of running a competing
      // fixed-duration tween.
      _animatePanelHeight = false;
    } else if (_animateNextPanelResize &&
        panelHeightChanged &&
        _keyboardInset == 0) {
      _animatePanelHeight = true;
      _animateNextPanelResize = false;
    } else {
      _animatePanelHeight =
          panelVisibilityChanged &&
          _keyboardInset == 0 &&
          !oldWidget.switchingToKeyboard &&
          !widget.switchingToKeyboard;
    }

    if (!widget.switchingToKeyboard) {
      _isAnimatingToKeyboardMinimum = false;
      _keyboardSettleTimer?.cancel();
    } else if (!oldWidget.switchingToKeyboard && _keyboardInset > 0) {
      _scheduleKeyboardSettled();
    }
  }

  @override
  void dispose() {
    _keyboardSettleTimer?.cancel();
    _keyboardHeightCaptureTimer?.cancel();
    super.dispose();
  }

  void _updateKeyboardInset() {
    final nextInset = MediaQuery.viewInsetsOf(context).bottom;
    if (nextInset != _keyboardInset && !_isAnimatingToKeyboardMinimum) {
      // The platform already animates viewInsets. Mirroring that transition
      // with another height tween makes the composer lag behind the keyboard.
      _animatePanelHeight = false;
    }
    _keyboardInset = nextInset;
    widget.metrics.inset = nextInset;
    if (nextInset > 0) {
      _scheduleKeyboardHeightCapture(nextInset);
      if (widget.switchingToKeyboard) {
        _scheduleKeyboardSettled();
      }
    } else {
      _keyboardHeightCaptureTimer?.cancel();
    }
  }

  void _scheduleKeyboardHeightCapture(double height) {
    _keyboardHeightCaptureTimer?.cancel();
    _keyboardHeightCaptureTimer = Timer(_keyboardSettleDelay, () {
      if (mounted && _keyboardInset == height) {
        widget.metrics.lastVisibleHeight = height;
      }
    });
  }

  void _scheduleKeyboardSettled() {
    _keyboardSettleTimer?.cancel();
    _keyboardSettleTimer = Timer(_keyboardSettleDelay, () {
      if (mounted && widget.switchingToKeyboard && _keyboardInset > 0) {
        widget.onKeyboardSettled();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.viewPaddingOf(context).bottom;
    final keepsPanelHeight =
        widget.mode != MobileComposerPanel.hidden || widget.switchingToKeyboard;
    final baseHeight = keepsPanelHeight
        ? math.max(_keyboardInset, widget.panelHeight)
        : _keyboardInset > 0
        ? _keyboardInset
        : safeAreaBottom;
    final height =
        _isAnimatingToKeyboardMinimum &&
            widget.switchingToKeyboard &&
            widget.panelHeight > 0
        ? math.max(
            _keyboardInset,
            _keyboardTransitionStartHeight +
                (widget.panelHeight - _keyboardTransitionStartHeight) *
                    (_keyboardInset / widget.panelHeight).clamp(0.0, 1.0),
          )
        : baseHeight;

    return AnimatedContainer(
      duration: _animatePanelHeight ? _panelAnimationDuration : Duration.zero,
      curve: Curves.easeOutCubic,
      height: height,
      child: ClipRect(
        key: const ValueKey('mobile-composer-panel-clip'),
        clipper: _MobileComposerPanelClipper(
          horizontalOverflow: widget.horizontalPaintOverflow,
        ),
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            if (widget.backgroundColor != null)
              Positioned(
                top: 0,
                bottom: 0,
                left: -widget.horizontalPaintOverflow,
                right: -widget.horizontalPaintOverflow,
                child: ColoredBox(
                  key: const ValueKey('mobile-composer-panel-background'),
                  color: widget.backgroundColor!,
                ),
              ),
            if (widget.mode != MobileComposerPanel.hidden)
              LayoutBuilder(
                builder: (context, constraints) {
                  // During the opening tween the viewport can be only a few
                  // pixels tall. Lay the panel out at its final height and
                  // reveal it through the ClipRect instead of passing those
                  // transient constraints into its internal Flex widgets.
                  return OverflowBox(
                    alignment: Alignment.topCenter,
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                    minHeight: height,
                    maxHeight: height,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: safeAreaBottom),
                      child: Column(
                        children: [
                          MobileComposerDragHandle(
                            onDrag: widget.onResize,
                            onDragEnd: (velocity) {
                              _animateNextPanelResize = true;
                              widget.onResizeEnd(velocity);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _animateNextPanelResize = false;
                              });
                            },
                          ),
                          Expanded(
                            child: KeyedSubtree(
                              key: ValueKey(widget.mode),
                              child: widget.child,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileComposerPanelClipper extends CustomClipper<Rect> {
  const _MobileComposerPanelClipper({required this.horizontalOverflow});

  final double horizontalOverflow;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      -horizontalOverflow,
      0,
      size.width + horizontalOverflow,
      size.height,
    );
  }

  @override
  bool shouldReclip(_MobileComposerPanelClipper oldClipper) {
    return horizontalOverflow != oldClipper.horizontalOverflow;
  }
}
