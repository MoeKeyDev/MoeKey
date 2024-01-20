import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class MkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape? shape;
  final String? blurHash;
  const MkImage(this.url,
      {super.key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.shape,
      this.blurHash});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      shape: shape,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              height: height,
              width: width,
              fit: fit,
              filterQuality: FilterQuality.medium,
            );
          case LoadState.loading:
            if (blurHash != null) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // 当某些情况拿不到最大高度的时候，用最小高度代替
                  var height = constraints.maxHeight;
                  if (constraints.maxHeight == double.infinity) {
                    height = constraints.minHeight;
                  }
                  return SizedBox(
                    height: height,
                    child: BlurHash(hash: blurHash!),
                  );
                },
              );
            }
            return const SizedBox(width: 0, height: 0);
          case LoadState.failed:
            return const SizedBox(width: 0, height: 0);
        }
      },
    );
  }
}
