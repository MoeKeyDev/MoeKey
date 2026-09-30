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
import '../../video/app_video_pool.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';

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
    this.videoContext,
    this.videoSubIndex = 0,
  });

  final num? maxHeight;
  final num? minHeight;
  final UniqueKey? heroKey;
  final DriveFileModel imageFile;
  final void Function()? onClick;
  final BoxFit fit;
  final bool showHideButton;
  final NoteVideoContext? videoContext;
  final int videoSubIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themeColorsProvider);
    var isHidden = useState(imageFile.isSensitive);
    useEffect(() {
      isHidden.value = imageFile.isSensitive;
      return null;
    }, [imageFile.id, imageFile.isSensitive]);
    var isImage = false;
    var isVideo = false;
    if (imageFile.type.startsWith("image")) {
      isImage = true;
    }
    if (imageFile.type.startsWith("video")) {
      isVideo = true;
    }
    Widget buildImage(FeedVideo? video) => LayoutBuilder(
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
                if (onClick != null && (isImage || isVideo)) {
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
                  // Keep the foreground image mounted so both network loading
                  // and decoding finish beneath the sensitive-content mask.
                  // Opacity 0 suppresses painting without stopping image loading.
                  if (isImage)
                    ExcludeSemantics(
                      excluding: isHidden.value,
                      child: IgnorePointer(
                        ignoring: isHidden.value,
                        child: Opacity(
                          opacity: isHidden.value ? 0 : 1,
                          child: MkImage(
                            imageFile.thumbnailUrl ?? imageFile.url,
                            proxy: const MkImageProxyOptions(),
                            heroKey: heroKey,
                            blurHash: imageFile.blurhash,
                            width: double.infinity,
                            height: double.infinity,
                            fit: fit,
                          ),
                        ),
                      ),
                    )
                  else if (isVideo && !isHidden.value)
                    VideoPlayerComponent(
                      key: ValueKey(imageFile.id),
                      video: video!,
                      placeholder: imageFile.blurhash?.isNotEmpty == true
                          ? RepaintBoundary(
                              child: BlurHash(imageFile.blurhash!),
                            )
                          : null,
                      cover: imageFile.thumbnailUrl == null
                          ? null
                          : MkImage(
                              imageFile.thumbnailUrl!,
                              blurHash: imageFile.blurhash,
                              fit: fit,
                              proxy: const MkImageProxyOptions(),
                            ),
                    ),
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
    if (!isVideo) return buildImage(null);
    Widget feed(BuildContext context) {
      final identity =
          videoContext ?? NoteVideoContext.of(context, imageFile.id);
      return VideoFeedView(
        scope: identity.listKey,
        videoKey: identity.attachmentKey(imageFile.id),
        noteId: identity.noteId,
        listIndex: identity.listIndex,
        listSubIndex: videoSubIndex,
        url: imageFile.url,
        enable: !isHidden.value,
        builder: (_, video) => buildImage(video),
      );
    }

    return AppVideoViewport.hasOf(context)
        ? feed(context)
        : AppVideoViewport(
            origin: videoContext,
            child: Builder(builder: feed),
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

    if (imageFile.type.startsWith("video") && imageFile.thumbnailUrl == null) {
      return const SizedBox.expand();
    }

    return RepaintBoundary(
      child: ImageFiltered(
        // Reuse the same native filter object. Recreating it during a keyboard
        // metrics rebuild would otherwise mark this render object for paint.
        imageFilter: _blurFilter,
        child: MkImage(
          imageFile.thumbnailUrl ?? imageFile.url,
          proxy: const MkImageProxyOptions(),
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
