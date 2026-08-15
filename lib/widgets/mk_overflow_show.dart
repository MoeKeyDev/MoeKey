import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MkOverflowShow extends StatefulWidget {
  const MkOverflowShow({
    super.key,
    required this.content,
    required this.action,
    required this.limit,
    required this.height,
  });

  final Widget content;
  final Widget Function(bool isShow, void Function(bool isShow)) action;
  final double limit;
  final double height;

  @override
  State<MkOverflowShow> createState() => _MkOverflowShowState();
}

class _MkOverflowShowState extends State<MkOverflowShow> {
  bool _isExpanded = false;
  bool _hasOverflow = false;

  void _setExpanded(bool value) {
    if (_isExpanded == value) return;
    setState(() => _isExpanded = value);
  }

  void _handleOverflowChanged(bool value) {
    if (_hasOverflow == value) return;
    _hasOverflow = value;
  }

  @override
  Widget build(BuildContext context) {
    return _OverflowLayout(
      limit: widget.limit,
      collapsedHeight: widget.height,
      collapsed: !_isExpanded,
      onOverflowChanged: _handleOverflowChanged,
      children: [
        widget.content,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _setExpanded(true),
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll<TextStyle>(
                  DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(
                  DefaultTextStyle.of(context).style.color!,
                ),
              ),
              child: widget.action(_isExpanded, _setExpanded),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverflowLayout extends MultiChildRenderObjectWidget {
  const _OverflowLayout({
    required super.children,
    required this.limit,
    required this.collapsedHeight,
    required this.collapsed,
    required this.onOverflowChanged,
  });

  final double limit;
  final double collapsedHeight;
  final bool collapsed;
  final ValueChanged<bool> onOverflowChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderOverflowLayout(
      limit: limit,
      collapsedHeight: collapsedHeight,
      collapsed: collapsed,
      onOverflowChanged: onOverflowChanged,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderOverflowLayout renderObject,
  ) {
    renderObject
      ..limit = limit
      ..collapsedHeight = collapsedHeight
      ..collapsed = collapsed
      ..onOverflowChanged = onOverflowChanged;
  }
}

class _OverflowParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderOverflowLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _OverflowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _OverflowParentData> {
  _RenderOverflowLayout({
    required this._limit,
    required this._collapsedHeight,
    required this._collapsed,
    required this._onOverflowChanged,
  });

  double _limit;
  double _collapsedHeight;
  bool _collapsed;
  ValueChanged<bool> _onOverflowChanged;
  bool _hasOverflow = false;
  bool _showOverflow = false;

  set limit(double value) {
    if (_limit == value) return;
    _limit = value;
    markNeedsLayout();
  }

  set collapsedHeight(double value) {
    if (_collapsedHeight == value) return;
    _collapsedHeight = value;
    markNeedsLayout();
  }

  set collapsed(bool value) {
    if (_collapsed == value) return;
    _collapsed = value;
    markNeedsLayout();
  }

  set onOverflowChanged(ValueChanged<bool> value) {
    _onOverflowChanged = value;
  }

  BoxConstraints _contentConstraints(BoxConstraints parentConstraints) {
    final width = parentConstraints.hasBoundedWidth
        ? parentConstraints.maxWidth
        : null;
    return BoxConstraints(
      minWidth: width ?? parentConstraints.minWidth,
      maxWidth: parentConstraints.maxWidth,
      minHeight: 0,
      maxHeight: double.infinity,
    );
  }

  Size _resolvedSize(Size contentSize, BoxConstraints parentConstraints) {
    final shouldCollapse = _collapsed && contentSize.height > _limit;
    final width = parentConstraints.hasBoundedWidth
        ? parentConstraints.maxWidth
        : contentSize.width;
    final height = shouldCollapse ? _collapsedHeight : contentSize.height;
    return parentConstraints.constrain(Size(width, height));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final content = firstChild;
    if (content == null) return constraints.smallest;
    final contentSize = content.getDryLayout(_contentConstraints(constraints));
    return _resolvedSize(contentSize, constraints);
  }

  @override
  void performLayout() {
    final content = firstChild!;
    final action = childAfter(content)!;

    // The surrounding viewport may give a finite height while an item is
    // entering, leaving, or being cached. Measure the content independently
    // from that height so overflow detection cannot change with scroll state.
    content.layout(_contentConstraints(constraints), parentUsesSize: true);

    final hasOverflow = content.size.height > _limit;
    if (_hasOverflow != hasOverflow) {
      _hasOverflow = hasOverflow;
      _onOverflowChanged(hasOverflow);
    }
    _showOverflow = _collapsed && hasOverflow;
    size = _resolvedSize(content.size, constraints);

    final contentParentData = content.parentData! as _OverflowParentData;
    contentParentData.offset = Offset.zero;

    action.layout(
      BoxConstraints(maxWidth: size.width, maxHeight: size.height),
      parentUsesSize: true,
    );
    final actionParentData = action.parentData! as _OverflowParentData;
    actionParentData.offset = _showOverflow
        ? Offset(
            (size.width - action.size.width) / 2,
            size.height - action.size.height,
          )
        : Offset(-action.size.width, -action.size.height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final content = firstChild!;
    final contentOffset =
        (content.parentData! as _OverflowParentData).offset + offset;

    if (!_showOverflow) {
      context.paintChild(content, contentOffset);
      return;
    }

    final fadeStart = (size.height - 60).clamp(0.0, size.height);
    final shaderLayer = ShaderMaskLayer(
      shader: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Colors.transparent],
      ).createShader(Rect.fromLTRB(0, fadeStart, size.width, size.height)),
      maskRect: offset & size,
      blendMode: BlendMode.dstIn,
    );

    context.pushClipRect(needsCompositing, offset, Offset.zero & size, (
      context,
      clipOffset,
    ) {
      context.pushLayer(shaderLayer, (context, layerOffset) {
        context.paintChild(content, contentOffset);
      }, clipOffset);
    }, clipBehavior: Clip.hardEdge);

    final action = childAfter(content)!;
    final actionOffset =
        (action.parentData! as _OverflowParentData).offset + offset;
    context.paintChild(action, actionOffset);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _OverflowParentData) {
      child.parentData = _OverflowParentData();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject child) {
    return _showOverflow ? Offset.zero & size : null;
  }
}
