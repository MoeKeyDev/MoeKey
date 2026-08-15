import 'dart:async';

import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../apis/models/drive.dart';
import '../../apis/models/meta.dart';
import '../../apis/models/note.dart';
import '../../apis/models/user_lite.dart';
import '../../generated/l10n.dart';
import '../../hook/use_extended_page_controller.dart';
import '../../status/apis.dart';
import '../../status/dio.dart';
import '../../utils/custom_rect_tween.dart';
import '../../utils/save_image.dart';
import '../../widgets/mfm_text/mfm_text.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/video_player.dart';

class ImagePreviewPage extends HookConsumerWidget {
  const ImagePreviewPage({
    super.key,
    required this.initialIndex,
    required this.galleryItems,
    required this.heroKeys,
    required this.note,
    this.onPageChanged,
    this.backgroundDecoration,
  });

  final List<DriveFileModel> galleryItems;
  final NoteModel note;
  final ValueChanged<int>? onPageChanged;
  final BoxDecoration? backgroundDecoration;
  final int initialIndex;
  final List<UniqueKey> heroKeys;

  bool _isImage(DriveFileModel file) => file.type.startsWith('image/');
  bool _isVideo(DriveFileModel file) => file.type.startsWith('video/');

  void _preloadImage(int index, BuildContext context) {
    if (index < 0 || index >= galleryItems.length) return;
    final file = galleryItems[index];
    if (_isImage(file)) {
      final thumbnailUrl = file.thumbnailUrl;
      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
        precacheImage(getExtendedResizeImage(thumbnailUrl), context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeInitialIndex = initialIndex.clamp(0, galleryItems.length - 1);
    final pageController = useExtendedPageController(
      initialPage: safeInitialIndex,
    );
    final currentIndex = useState(safeInitialIndex);
    final chromeVisible = useState(true);
    final mediaZoomed = useState(false);
    final mediaSlideOffset = useState(Offset.zero);
    final mediaSlideScale = useState(1.0);
    final slidePageKey = useMemoized(
      GlobalKey<ExtendedImageSlidePageState>.new,
    );
    final trackedPointer = useRef<int?>(null);
    final pointerStart = useRef<Offset?>(null);
    final pointerPrevious = useRef<Offset?>(null);
    final verticalDismissStarted = useRef(false);
    final http = ref.watch(httpProvider);
    final meta = ref.watch(instanceMetaProvider);
    final currentFile = galleryItems[currentIndex.value];

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        _preloadImage(safeInitialIndex - 1, context);
        _preloadImage(safeInitialIndex + 1, context);
      });
      return null;
    }, const []);

    useEffect(() {
      if (!_isVideo(currentFile)) return null;
      final controller = ref.read(
        sharedVideoControllerProvider(currentFile.url),
      );
      var cancelled = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!cancelled) unawaited(controller.setMuted(false));
      });
      return () {
        cancelled = true;
        unawaited(controller.restoreAfterPreview());
      };
    }, [currentFile.url]);

    void toggleChrome() => chromeVisible.value = !chromeVisible.value;

    void finishVerticalDismiss() {
      if (verticalDismissStarted.value) {
        slidePageKey.currentState?.endSlide(ScaleEndDetails());
      }
      trackedPointer.value = null;
      pointerStart.value = null;
      pointerPrevious.value = null;
      verticalDismissStarted.value = false;
    }

    void pointerDown(PointerDownEvent event) {
      if (mediaZoomed.value || trackedPointer.value != null) {
        finishVerticalDismiss();
        return;
      }
      trackedPointer.value = event.pointer;
      pointerStart.value = event.position;
      pointerPrevious.value = event.position;
    }

    void pointerMove(PointerMoveEvent event) {
      if (mediaZoomed.value || trackedPointer.value != event.pointer) return;
      final start = pointerStart.value;
      final previous = pointerPrevious.value;
      if (start == null || previous == null) return;
      final total = event.position - start;
      if (!verticalDismissStarted.value) {
        if (total.distance < 10) return;
        if (total.dy.abs() <= total.dx.abs()) {
          trackedPointer.value = null;
          return;
        }
        verticalDismissStarted.value = true;
      }
      slidePageKey.currentState?.slide(
        Offset(0, event.position.dy - previous.dy),
      );
      pointerPrevious.value = event.position;
    }

    return ExtendedImageSlidePage(
      key: slidePageKey,
      slideAxis: SlideAxis.vertical,
      slideType: SlideType.onlyImage,
      onSlidingPage: (state) {
        mediaSlideOffset.value = state.offset;
        mediaSlideScale.value = state.scale;
      },
      slidePageBackgroundHandler: (offset, pageSize) {
        final opacity = (1 - offset.dy.abs() / pageSize.height).clamp(0.0, 1.0);
        return Colors.black.withValues(alpha: opacity);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: mediaSlideOffset.value,
              child: Transform.scale(
                scale: mediaSlideScale.value,
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: pointerDown,
                  onPointerMove: pointerMove,
                  onPointerUp: (_) => finishVerticalDismiss(),
                  onPointerCancel: (_) => finishVerticalDismiss(),
                  child: ExtendedImageGesturePageView.builder(
                    itemCount: galleryItems.length,
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      mediaZoomed.value = false;
                      currentIndex.value = index;
                      _preloadImage(index - 1, context);
                      _preloadImage(index + 1, context);
                      onPageChanged?.call(index);
                    },
                    itemBuilder: (context, index) {
                      final file = galleryItems[index];
                      if (_isVideo(file)) {
                        return VideoPlayerComponent(
                          key: ValueKey(file.id),
                          url: file.url,
                          presentation: VideoPlayerPresentation.preview,
                          controlsVisible:
                              chromeVisible.value &&
                              currentIndex.value == index,
                          onSurfaceTap: toggleChrome,
                          onZoomChanged: index == currentIndex.value
                              ? (value) => mediaZoomed.value = value
                              : null,
                        );
                      }
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: toggleChrome,
                        child: _PreviewImage(
                          file: file,
                          heroKey:
                              currentIndex.value == index &&
                                  index < heroKeys.length
                              ? heroKeys[index]
                              : null,
                          onZoomChanged: index == currentIndex.value
                              ? (value) => mediaZoomed.value = value
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (supportsVideoWindowFullscreen(defaultTargetPlatform) &&
                galleryItems.length > 1)
              _DesktopPageNavigation(
                visible: chromeVisible.value,
                onPrevious: currentIndex.value > 0
                    ? () => pageController.animateToPage(
                        currentIndex.value - 1,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                      )
                    : null,
                onNext: currentIndex.value < galleryItems.length - 1
                    ? () => pageController.animateToPage(
                        currentIndex.value + 1,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                      )
                    : null,
              ),
            _PreviewChrome(
              visible: chromeVisible.value,
              index: currentIndex.value,
              itemCount: galleryItems.length,
              note: note,
              reserveVideoControls: _isVideo(currentFile),
              onBack: () =>
                  Navigator.of(context, rootNavigator: true).maybePop(),
              onDownload: http.value == null
                  ? null
                  : () => _downloadCurrent(
                      context,
                      http.value!,
                      meta,
                      currentFile,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadCurrent(
    BuildContext context,
    Dio http,
    AsyncValue<MetaDetailedModel?> meta,
    DriveFileModel file,
  ) async {
    final success = await saveMedia(
      http: http,
      url: file.url,
      mimeType: file.type,
      album: meta.value?.name ?? 'MoeKey',
      name: file.name,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? S.current.saveSuccess : S.current.saveFailed),
      ),
    );
  }
}

class _DesktopPageNavigation extends StatelessWidget {
  const _DesktopPageNavigation({
    required this.visible,
    required this.onPrevious,
    required this.onNext,
  });

  final bool visible;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        child: Stack(
          children: [
            Positioned(
              left: 18,
              top: 0,
              bottom: 0,
              child: Center(
                child: _PreviewPageButton(
                  tooltip: '上一项',
                  onPressed: onPrevious,
                  icon: Icons.chevron_left,
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 0,
              bottom: 0,
              child: Center(
                child: _PreviewPageButton(
                  tooltip: '下一项',
                  onPressed: onNext,
                  icon: Icons.chevron_right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewPageButton extends StatelessWidget {
  const _PreviewPageButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: 34,
      style: IconButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white30,
        backgroundColor: Colors.black.withValues(alpha: 0.55),
        disabledBackgroundColor: Colors.black.withValues(alpha: 0.25),
        minimumSize: const Size.square(52),
      ),
      icon: Icon(icon),
    );
  }
}

class _PreviewImage extends StatefulWidget {
  const _PreviewImage({required this.file, this.heroKey, this.onZoomChanged});

  final DriveFileModel file;
  final UniqueKey? heroKey;
  final ValueChanged<bool>? onZoomChanged;

  @override
  State<_PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<_PreviewImage> {
  final TransformationController _transformationController =
      TransformationController();
  bool _zoomed = false;

  DriveFileModel get file => widget.file;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_transformationChanged);
  }

  @override
  void didUpdateWidget(_PreviewImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.id != widget.file.id) {
      _transformationController.value = Matrix4.identity();
    }
  }

  void _transformationChanged() {
    final zoomed = _transformationController.value.getMaxScaleOnAxis() > 1.001;
    if (zoomed != _zoomed && mounted) {
      setState(() => _zoomed = zoomed);
      widget.onZoomChanged?.call(zoomed);
    }
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    final scale = _zoomed ? 1.0 : 2.0;
    if (scale == 1) {
      _transformationController.value = Matrix4.identity();
      return;
    }
    final position = details.localPosition;
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(
        -position.dx * (scale - 1),
        -position.dy * (scale - 1),
        0,
        1,
      )
      ..scaleByDouble(scale, scale, 1, 1);
  }

  @override
  void dispose() {
    if (_zoomed) widget.onZoomChanged?.call(false);
    _transformationController.removeListener(_transformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget image = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTapDown: _handleDoubleTapDown,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1,
        maxScale: 5,
        panEnabled: _zoomed,
        scaleEnabled: true,
        clipBehavior: Clip.hardEdge,
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ProgressiveImagePlaceholder(file: file),
              ExtendedImage(
                image: getExtendedOriginalImage(file.url),
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                loadStateChanged: (state) {
                  final completed =
                      state.extendedImageLoadState == LoadState.completed;
                  return AnimatedOpacity(
                    opacity: completed ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: completed
                        ? state.completedWidget
                        : const SizedBox.expand(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    final heroKey = widget.heroKey;
    if (heroKey != null) {
      image = Hero(
        tag: heroKey,
        createRectTween: (begin, end) => CustomRectTween(a: begin!, b: end!),
        child: image,
      );
    }
    return image;
  }
}

class _ProgressiveImagePlaceholder extends StatelessWidget {
  const _ProgressiveImagePlaceholder({required this.file});

  final DriveFileModel file;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = file.thumbnailUrl;
    final blurhash = file.blurhash;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (blurhash != null && blurhash.isNotEmpty)
          Center(
            child: AspectRatio(
              aspectRatio:
                  (file.properties?.width ?? 16) /
                  (file.properties?.height ?? 9),
              child: BlurHash(blurhash),
            ),
          ),
        if (thumbnailUrl != null &&
            thumbnailUrl.isNotEmpty &&
            thumbnailUrl != file.url)
          ExtendedImage(
            image: getExtendedResizeImage(thumbnailUrl),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            loadStateChanged: (state) {
              final completed =
                  state.extendedImageLoadState == LoadState.completed;
              return AnimatedOpacity(
                opacity: completed ? 1 : 0,
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOut,
                child: completed
                    ? state.completedWidget
                    : const SizedBox.expand(),
              );
            },
          ),
      ],
    );
  }
}

class _PreviewChrome extends StatelessWidget {
  const _PreviewChrome({
    required this.visible,
    required this.index,
    required this.itemCount,
    required this.note,
    required this.reserveVideoControls,
    required this.onBack,
    required this.onDownload,
  });

  final bool visible;
  final int index;
  final int itemCount;
  final NoteModel note;
  final bool reserveVideoControls;
  final VoidCallback onBack;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  8 + viewPadding.left,
                  4 + viewPadding.top,
                  8 + viewPadding.right,
                  24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.72),
                      Colors.black.withValues(alpha: 0.38),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      onPressed: onBack,
                      color: Colors.white,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Text(
                          '${index + 1} / $itemCount',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: '下载',
                      onPressed: onDownload,
                      color: Colors.white,
                      disabledColor: Colors.white38,
                      icon: const Icon(Icons.download),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: (reserveVideoControls ? 64 : 0) + viewPadding.bottom,
              child: _NoteSummary(note: note),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteSummary extends StatefulWidget {
  const _NoteSummary({required this.note});

  final NoteModel note;

  @override
  State<_NoteSummary> createState() => _NoteSummaryState();
}

class _NoteSummaryState extends State<_NoteSummary> {
  final ScrollController _textScrollController = ScrollController();
  bool _expanded = false;

  NoteModel get note => widget.note;

  @override
  void dispose() {
    _textScrollController.dispose();
    super.dispose();
  }

  bool _textExceedsThreeLines(BuildContext context, double maxWidth) {
    final text = note.text;
    if (text == null || text.trim().isEmpty || maxWidth <= 0) return false;
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 14, height: 1.35),
      ),
      maxLines: 3,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
    if (_expanded && _textScrollController.hasClients) {
      _textScrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = note.user;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.88)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: MkImage(
              user.avatarUrl ?? '',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canExpand = _textExceedsThreeLines(
                  context,
                  constraints.maxWidth,
                );
                final expandedTextHeight =
                    (MediaQuery.sizeOf(context).height * 0.32).clamp(
                      120.0,
                      320.0,
                    );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 22,
                      child: ClipRect(
                        child: DefaultTextStyle.merge(
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          child: MFMText(
                            text: user.name?.isNotEmpty == true
                                ? user.name!
                                : user.username,
                            emojis: user.emojis,
                            currentServerHost: user.host,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            bigEmojiCode: false,
                            feature: const [MFMFeature.emojiCode],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      user.getAtUserName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    if (note.text?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeInOutCubic,
                        height: _expanded ? expandedTextHeight : 58,
                        child: ClipRect(
                          child: DefaultTextStyle.merge(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.35,
                            ),
                            child: _expanded
                                ? Scrollbar(
                                    controller: _textScrollController,
                                    thumbVisibility: true,
                                    interactive: true,
                                    child: SingleChildScrollView(
                                      controller: _textScrollController,
                                      primary: false,
                                      padding: const EdgeInsets.only(right: 14),
                                      child: MFMText(
                                        text: note.text!,
                                        ast: note.textAst,
                                        emojis: note.emojis,
                                        currentServerHost: user.host,
                                        bigEmojiCode: false,
                                      ),
                                    ),
                                  )
                                : MFMText(
                                    text: note.text!,
                                    ast: note.textAst,
                                    emojis: note.emojis,
                                    currentServerHost: user.host,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    bigEmojiCode: false,
                                  ),
                          ),
                        ),
                      ),
                      if (canExpand)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _toggleExpanded,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                            ),
                            icon: AnimatedRotation(
                              turns: _expanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeInOutCubic,
                              child: const Icon(
                                Icons.keyboard_arrow_up,
                                size: 18,
                              ),
                            ),
                            label: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                              child: Text(
                                _expanded ? '收起' : '展开',
                                key: ValueKey(_expanded),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
