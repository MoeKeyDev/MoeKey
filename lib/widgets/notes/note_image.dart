import 'dart:ui';

import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';

import '../../apis/models/drive.dart';
import '../../generated/l10n.dart';
import '../mk_image.dart';
import '../video_player.dart';

class NoteImage extends HookConsumerWidget {
  const NoteImage({
    super.key,
    this.maxHeight,
    required this.imageFile,
    this.onClick,
    this.minHeight,
    required this.heroKey,
    this.fit = BoxFit.contain,
    this.showHideButton = true,
    this.onClickForVideo = false,
  });

  final num? maxHeight;
  final num? minHeight;
  final UniqueKey? heroKey;
  final DriveFileModel imageFile;
  final void Function()? onClick;
  final BoxFit fit;
  final bool showHideButton;
  final bool onClickForVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themeColorsProvider);
    var isHidden = useState(false);
    useEffect(() {
      if (imageFile.isSensitive) {
        isHidden.value = true;
      }
      return null;
    }, const []);
    var isImage = false;
    var isVideo = false;
    if (imageFile.type.startsWith("image")) {
      isImage = true;
    }
    if (imageFile.type.startsWith("video")) {
      isVideo = true;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.maxWidth;
        var height = maxHeight != null
            ? getHeight(
                imageFile.properties?.width ?? 16,
                imageFile.properties?.height ?? 9,
                width.toInt(),
                maxHeight!,
              )
            : constraints.maxHeight;
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: () {
              if (isHidden.value) {
                isHidden.value = false;
              } else {
                if (onClick != null && (isImage || onClickForVideo)) {
                  onClick!();
                }
              }
            },
            child: SizedBox(
              width: width,
              height: height.toDouble(),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ClipRect(
                  //   child:
                  _NoteImageBlurredBackground(imageFile: imageFile),
                  Container(color: Colors.black.withValues(alpha: 0.2)),
                  // ),
                  if (isHidden.value)
                    DefaultTextStyle(
                      style: DefaultTextStyle.of(
                        context,
                      ).style.copyWith(color: Colors.white, fontSize: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                TablerIcons.eye_exclamation,
                                color: Colors.white,
                                size: 13,
                              ),
                              Text(
                                imageFile.isSensitive
                                    ? S.current.sensitiveContent
                                    : isImage
                                    ? S.current.image
                                    : S.current.video,
                              ),
                            ],
                          ),
                          Text(S.current.sensitiveClickShow),
                        ],
                      ),
                    ),
                  if (!isHidden.value)
                    if (isImage) ...[
                      if (imageFile.thumbnailUrl != null)
                        MkImage(
                          heroKey: heroKey,
                          imageFile.thumbnailUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: fit,
                        )
                      else
                        MkImage(
                          heroKey: heroKey,
                          imageFile.url,
                          width: double.infinity,
                          height: double.infinity,
                          fit: fit,
                        ),
                    ] else if (isVideo)
                      VideoPlayerComponent(url: imageFile.url),
                  if (!isHidden.value && showHideButton)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          isHidden.value = true;
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                          decoration: BoxDecoration(
                            color: theme.fgColor.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: const Icon(
                            TablerIcons.eye_off,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  num getHeight(num w, num h, num ww, num wh) {
    var a = w / h;
    var wa = ww / wh;
    if (a >= wa) {
      return (ww / w) * h;
    } else {
      return wh;
    }
  }
}

class _NoteImageBlurredBackground extends StatelessWidget {
  const _NoteImageBlurredBackground({required this.imageFile});

  static final ImageFilter _blurFilter = ImageFilter.blur(
    sigmaX: 100,
    sigmaY: 100,
  );

  // A sigma-100 background contains no visible high-frequency detail. Decode
  // it into a bounded texture instead of uploading the source-sized image.
  // The foreground image still uses its normal resolution.
  static const int _cacheExtent = 256;

  final DriveFileModel imageFile;

  @override
  Widget build(BuildContext context) {
    final blurhash = imageFile.blurhash;
    if (blurhash != null && blurhash.isNotEmpty) {
      return RepaintBoundary(child: BlurHash(blurhash));
    }

    return RepaintBoundary(
      child: ImageFiltered(
        // Reuse the same native filter object. Recreating it during a keyboard
        // metrics rebuild would otherwise mark this render object for paint.
        imageFilter: _blurFilter,
        child: MkImage(
          imageFile.thumbnailUrl ?? imageFile.url,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
          cacheWidth: _cacheExtent,
          cacheHeight: _cacheExtent,
        ),
      ),
    );
  }
}
