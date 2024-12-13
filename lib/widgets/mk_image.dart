import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

ExtendedResizeImage getExtendedResizeImage(String url) {
  return ExtendedResizeImage(ExtendedNetworkImageProvider(url, cache: true),
      maxBytes: 500 << 10);
}

class MkImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape? shape;
  final String? blurHash;
  final UniqueKey? heroKey;

  const MkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape,
    this.blurHash,
    this.heroKey,
  });

  @override
  State<MkImage> createState() => _MkImageState();
}

class _MkImageState extends State<MkImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 额外判断svg
    if (widget.url.endsWith(".svg")) {
      return DecoratedBox(
        decoration: BoxDecoration(
          shape: widget.shape ?? BoxShape.rectangle,
        ),
        child: SvgPicture.network(widget.url,
            width: widget.width, height: widget.height, fit: widget.fit),
      );
    }
    return RepaintBoundary(
      child: Hero(
          tag: widget.heroKey ?? UniqueKey(),
          child: ExtendedImage(
            image: getExtendedResizeImage(widget.url),
            shape: widget.shape,
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.completed:
                  _controller.forward();
                  var image = FadeTransition(
                    opacity: _controller,
                    child: ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      height: widget.height,
                      width: widget.width,
                      fit: widget.fit,
                      filterQuality: FilterQuality.medium,
                    ),
                  );
                  if (widget.blurHash == null || widget.blurHash!.isEmpty) {
                    return image;
                  }
                  return BlurHash(
                    widget.blurHash!,
                    child: image,
                  );
                case LoadState.loading:
                case LoadState.failed:
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      var constraintsHeight = constraints.maxHeight;
                      var constraintsWidth = constraints.maxWidth;
                      if (constraints.maxHeight == double.infinity) {
                        constraintsHeight = constraints.minHeight;
                      }
                      if (constraints.maxWidth == double.infinity) {
                        constraintsWidth = constraints.minWidth;
                      }
                      return Container(
                        width:
                            widget.width ?? widget.height ?? constraintsWidth,
                        height: widget.height ?? constraintsHeight,
                        color: const Color.fromARGB(10, 0, 0, 0),
                        child: (widget.blurHash != null &&
                                widget.blurHash!.isNotEmpty)
                            ? BlurHash(widget.blurHash!)
                            : null,
                      );
                    },
                  );
              }
            },
          )),
    );
  }
}
