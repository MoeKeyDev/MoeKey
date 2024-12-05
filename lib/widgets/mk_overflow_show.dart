import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../generated/l10n.dart';

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
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: _RenderObjectLayoutBox(
        limit: widget.limit,
        height: widget.height,
        enable: !isShow,
        children: [
          widget.content,
          Builder(
            builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    isShow = !isShow;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                      style: ButtonStyle(
                        textStyle: WidgetStatePropertyAll<TextStyle>(
                          DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontSize: 12),
                        ),
                        foregroundColor: WidgetStatePropertyAll<Color>(
                            DefaultTextStyle.of(context).style.color!),
                      ),
                      child: Text(S.current.viewMore),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// 计算出来的大小
class _RenderObjectLayoutBox extends MultiChildRenderObjectWidget {
  const _RenderObjectLayoutBox({
    super.children,
    required this.limit,
    required this.height,
    required this.enable,
  });

  final double limit;
  final double height;
  final bool enable;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderObject(height: height, limit: limit, enable: enable);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderObject renderObject) {
    renderObject.limit = limit;
    renderObject.height = height;
    renderObject.enable = enable;
    renderObject.markNeedsLayout();
  }
}

class _RenderObjectLayoutBoxParentData
    extends ContainerBoxParentData<RenderBox> {
  bool isShowMask = false;
}

class _RenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _RenderObjectLayoutBoxParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            _RenderObjectLayoutBoxParentData> {
  _RenderObject({
    required this.limit,
    required this.height,
    required this.enable,
  });

  double limit;
  double height;
  bool enable;

  @override
  void performLayout() {
    RenderBox child = firstChild!;
    child.layout(constraints, parentUsesSize: true);
    var childSize = child.size;
    if (childSize.height > limit && enable) {
      size = Size(constraints.maxWidth, height);
      (child.parentData as _RenderObjectLayoutBoxParentData).isShowMask = true;
    } else {
      size = Size(constraints.maxWidth, childSize.height);
      (child.parentData as _RenderObjectLayoutBoxParentData).isShowMask = false;
    }
    var showMoreChild =
        (child.parentData as _RenderObjectLayoutBoxParentData).nextSibling!;

    showMoreChild.layout(BoxConstraints.loose(size), parentUsesSize: true);
    if ((child.parentData as _RenderObjectLayoutBoxParentData).isShowMask) {
      (showMoreChild.parentData as _RenderObjectLayoutBoxParentData).offset =
          Offset((size.width - showMoreChild.size.width) / 2,
              size.height - showMoreChild.size.height);
    } else {
      (showMoreChild.parentData as _RenderObjectLayoutBoxParentData).offset =
          Offset(-size.width, -size.height);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var layer = ShaderMaskLayer();
    var rect = Offset.zero & size;
    layer.shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.transparent],
            stops: [0, 1])
        .createShader(
            Rect.fromLTRB(0, rect.height - 60, rect.width, rect.height));
    layer.maskRect = offset & size;
    layer.blendMode = BlendMode.dstIn;
    RenderBox child = firstChild!;
    if ((child.parentData as _RenderObjectLayoutBoxParentData).isShowMask) {
      context.pushLayer(layer, (context, offset) {
        // 这里需要裁剪掉多余的部分
        context.pushClipRect(
          true,
          offset,
          Rect.fromLTRB(0, 0, size.width, size.height),
          (context, offset) {
            context.paintChild(
              child,
              (child.parentData as _RenderObjectLayoutBoxParentData).offset +
                  offset,
            );
          },
          clipBehavior: Clip.hardEdge,
        );
      }, offset);

      RenderBox showMoreChild =
          (child.parentData as _RenderObjectLayoutBoxParentData).nextSibling!;
      context.paintChild(
          showMoreChild,
          offset +
              (showMoreChild.parentData as _RenderObjectLayoutBoxParentData)
                  .offset);
    } else {
      context.paintChild(
          child,
          (child.parentData as _RenderObjectLayoutBoxParentData).offset +
              offset);
    }
    // print(layer);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RenderObjectLayoutBoxParentData) {
      child.parentData = _RenderObjectLayoutBoxParentData();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
