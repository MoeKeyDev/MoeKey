import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/notes_listener.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/notes/note_children.dart';

import '../../apis/models/note.dart';
import '../../apis/models/user_lite.dart';
import '../../generated/l10n.dart';
import '../../status/apis.dart';
import '../../status/misskey_api.dart';
import '../../status/note_deletion_registry.dart';
import '../../status/notes.dart';
import '../../status/server.dart';
import '../../utils/time_ago_since_date.dart';
import '../../utils/time_to_desired_format.dart';
import '../../widgets/context_menu.dart';
import '../../widgets/mfm_text/mfm_text.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/mk_scaffold.dart';
import '../../widgets/mk_skeleton_block.dart';
import '../../widgets/notes/note_card.dart';
import '../../widgets/notes/note_poll.dart';
import '../../widgets/reactions.dart';

const _authorNotesPageSize = 10;
const _authorNotesPullExtentPercentage = 1 / 6;

double _authorNotesPullThreshold(double containerExtent) {
  return containerExtent * _authorNotesPullExtentPercentage;
}

String _newestNoteId(Iterable<NoteModel> notes, String fallback) {
  return notes.fold(
    fallback,
    (newest, note) => note.id.compareTo(newest) > 0 ? note.id : newest,
  );
}

String _oldestNoteId(Iterable<NoteModel> notes, String fallback) {
  return notes.fold(
    fallback,
    (oldest, note) => note.id.compareTo(oldest) < 0 ? note.id : oldest,
  );
}

ValueNotifier<T> _useKeyedState<T>(T initialValue, List<Object?> keys) {
  final notifier = useMemoized(() => ValueNotifier(initialValue), keys);
  useListenable(notifier);
  useEffect(() => notifier.dispose, [notifier]);
  return notifier;
}

class NotesPage extends HookConsumerWidget {
  const NotesPage({super.key, required this.noteId, this.previewNote});

  final String noteId;
  final NoteModel? previewNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.of(context).padding;
    var themes = ref.watch(themeColorsProvider);
    var notes = notesProvider(noteId);
    var dataProvider = ref.watch(notes);

    var conversation = dataProvider.value?.conversation ?? [];
    var data = dataProvider.value?.data ?? previewNote;
    final replyContentVisible = useState<bool?>(null);
    final currentNoteSliverKey = useMemoized(GlobalKey.new, [noteId]);
    final newerAuthorNotes = _useKeyedState<List<NoteModel>>(const [], [
      noteId,
    ]);
    final olderAuthorNotes = _useKeyedState<List<NoteModel>>(const [], [
      noteId,
    ]);
    ref.listen(deletedNoteIdsProvider, (_, deletedNoteIds) {
      final filteredNewer = excludeDeletedNotes(
        newerAuthorNotes.value,
        deletedNoteIds,
      );
      if (filteredNewer.length != newerAuthorNotes.value.length) {
        newerAuthorNotes.value = filteredNewer;
      }
      final filteredOlder = excludeDeletedNotes(
        olderAuthorNotes.value,
        deletedNoteIds,
      );
      if (filteredOlder.length != olderAuthorNotes.value.length) {
        olderAuthorNotes.value = filteredOlder;
      }
    });
    final loadingNewerAuthorNotes = _useKeyedState(false, [noteId]);
    final loadingOlderAuthorNotes = _useKeyedState(false, [noteId]);
    final canLoadNewerAuthorNotes = _useKeyedState(true, [noteId]);
    final canLoadOlderAuthorNotes = _useKeyedState(true, [noteId]);
    final topPullDistance = useMemoized(() => ValueNotifier(0.0), [noteId]);
    final bottomPullDistance = useMemoized(() => ValueNotifier(0.0), [noteId]);
    useEffect(() {
      return () {
        topPullDistance.dispose();
        bottomPullDistance.dispose();
      };
    }, [topPullDistance, bottomPullDistance]);
    final topPullArmed = useRef(false);
    final bottomPullArmed = useRef(false);

    void resetAuthorTimelinePull() {
      topPullDistance.value = 0;
      bottomPullDistance.value = 0;
      topPullArmed.value = false;
      bottomPullArmed.value = false;
    }

    Future<void> loadNewerAuthorNotes() async {
      final currentNote = data;
      if (currentNote == null ||
          loadingNewerAuthorNotes.value ||
          !canLoadNewerAuthorNotes.value) {
        return;
      }

      loadingNewerAuthorNotes.value = true;
      try {
        final result = await ref
            .read(misskeyApisProvider)
            .user
            .notes(
              userId: currentNote.userId,
              withRenotes: true,
              limit: _authorNotesPageSize,
              sinceId: _newestNoteId(newerAuthorNotes.value, currentNote.id),
              allowPartial: true,
            );
        if (!context.mounted) return;
        if (result.isEmpty) {
          canLoadNewerAuthorNotes.value = false;
          return;
        }
        final mergedNotes = excludeDeletedNotes(
          [...newerAuthorNotes.value, ...result],
          ref.read(deletedNoteIdsProvider),
        )..sort((a, b) => a.id.compareTo(b.id));
        newerAuthorNotes.value = mergedNotes;
      } catch (_) {
        // Keep the edge enabled so the user can pull again to retry.
      } finally {
        if (context.mounted) loadingNewerAuthorNotes.value = false;
      }
    }

    Future<void> loadOlderAuthorNotes() async {
      final currentNote = data;
      if (currentNote == null ||
          loadingOlderAuthorNotes.value ||
          !canLoadOlderAuthorNotes.value) {
        return;
      }

      loadingOlderAuthorNotes.value = true;
      try {
        final result = await ref
            .read(misskeyApisProvider)
            .user
            .notes(
              userId: currentNote.userId,
              withRenotes: true,
              limit: _authorNotesPageSize,
              untilId: _oldestNoteId(olderAuthorNotes.value, currentNote.id),
              allowPartial: true,
            );
        if (!context.mounted) return;
        if (result.isEmpty) {
          canLoadOlderAuthorNotes.value = false;
          return;
        }
        final knownIds = {
          currentNote.id,
          for (final note in olderAuthorNotes.value) note.id,
        };
        olderAuthorNotes.value = excludeDeletedNotes([
          ...olderAuthorNotes.value,
          ...result.where((note) => knownIds.add(note.id)),
        ], ref.read(deletedNoteIdsProvider));
      } catch (_) {
        // Keep the edge enabled so the user can pull again to retry.
      } finally {
        if (context.mounted) loadingOlderAuthorNotes.value = false;
      }
    }

    void finishAuthorTimelinePull({bool load = true}) {
      final loadNewer = load && topPullArmed.value;
      final loadOlder = load && bottomPullArmed.value;
      resetAuthorTimelinePull();
      if (loadNewer) scheduleMicrotask(loadNewerAuthorNotes);
      if (loadOlder) scheduleMicrotask(loadOlderAuthorNotes);
    }

    bool handleAuthorTimelinePull(ScrollNotification notification) {
      if (notification.depth != 0) return false;

      void updatePullState(ScrollMetrics metrics, double primaryDelta) {
        final threshold = _authorNotesPullThreshold(metrics.viewportDimension);
        var topDistance = topPullDistance.value;
        var bottomDistance = bottomPullDistance.value;

        if (topDistance > 0 || metrics.pixels < metrics.minScrollExtent) {
          topDistance = math.max(0.0, topDistance + primaryDelta);
        } else {
          topDistance = 0;
        }
        if (bottomDistance > 0 || metrics.pixels > metrics.maxScrollExtent) {
          bottomDistance = math.max(0.0, bottomDistance - primaryDelta);
        } else {
          bottomDistance = 0;
        }
        topPullDistance.value = topDistance;
        bottomPullDistance.value = bottomDistance;

        final nextTopArmed =
            canLoadNewerAuthorNotes.value &&
            !loadingNewerAuthorNotes.value &&
            topDistance >= threshold;
        final nextBottomArmed =
            canLoadOlderAuthorNotes.value &&
            !loadingOlderAuthorNotes.value &&
            bottomDistance >= threshold;

        if (nextTopArmed != topPullArmed.value) {
          topPullArmed.value = nextTopArmed;
          unawaited(HapticFeedback.heavyImpact());
        }
        if (nextBottomArmed != bottomPullArmed.value) {
          bottomPullArmed.value = nextBottomArmed;
          unawaited(HapticFeedback.heavyImpact());
        }
      }

      if (notification is ScrollStartNotification) {
        resetAuthorTimelinePull();
      } else if (notification is ScrollUpdateNotification) {
        final primaryDelta = notification.dragDetails?.primaryDelta;
        if (primaryDelta != null) {
          updatePullState(notification.metrics, primaryDelta);
        }
      } else if (notification is ScrollEndNotification) {
        finishAuthorTimelinePull();
      }
      return false;
    }

    data?.noteTranslate ??= previewNote?.noteTranslate;
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = getPaddingForNote(constraints);
        final headerExtent = 56 + mediaPadding.top;
        final scrollAnchor = constraints.maxHeight > 0
            ? (headerExtent / constraints.maxHeight).clamp(0.0, 1.0)
            : 0.0;
        final showReplyContent =
            replyContentVisible.value ?? (data?.repliesCount ?? 0) > 0;
        final noteFontSize = DefaultTextStyle.of(context).style.fontSize ?? 14;
        final compactConversation =
            constraints.maxWidth - (padding * 2) - 52 < 400;
        final conversationAvatarSize =
            (compactConversation ? 7 : 8) * (noteFontSize - 8);
        final conversationLeftPadding = 52 - (conversationAvatarSize / 2);
        final authorNotesPullThreshold = _authorNotesPullThreshold(
          constraints.maxHeight,
        );
        return MkScaffold(
          header: MkAppbar(
            showBack: true,
            content: Row(
              children: [
                if (!dataProvider.isLoading || data != null) ...[
                  GestureDetector(
                    child: MkImage(
                      data?.user.avatarUrl ?? "",
                      blurHash: data?.user.avatarBlurhash,
                      shape: BoxShape.circle,
                      width: 32,
                      height: 32,
                    ),
                    onTap: () {
                      context.push("/user/${data?.userId}");
                      // MainRouterDelegate.of(context)
                      //     .setNewRoutePath(RouterItem(
                      //   path: "user/${data?.userId}",
                      //   page: () {
                      //     return UserPage(userId: data?.userId ?? "0");
                      //   },
                      // ));
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MFMText(
                          text: data?.user.name ?? data?.user.username ?? "",
                          emojis: data?.user.emojis,
                          bigEmojiCode: false,
                          feature: const [MFMFeature.emojiCode],
                          after: [TextSpan(text: S.current.somebodyNote)],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (data?.createdAt != null)
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                              timeAgoSinceDate(data!.createdAt),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            // trailing: TextButton(onPressed: () {}, child: const Text("关注")),
          ),
          body: Listener(
            onPointerUp: (_) => finishAuthorTimelinePull(),
            onPointerCancel: (_) => finishAuthorTimelinePull(load: false),
            child: NotificationListener<ScrollNotification>(
              onNotification: handleAuthorTimelinePull,
              child: CustomScrollView(
                center: data == null ? null : currentNoteSliverKey,
                anchor: data == null ? 0.0 : scrollAnchor,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  if (data != null)
                    SliverToBoxAdapter(child: SizedBox(height: headerExtent)),
                  if (data != null)
                    _AuthorNotesLoadButtonSliver(
                      direction: AxisDirection.up,
                      visible: canLoadNewerAuthorNotes.value,
                      loading: loadingNewerAuthorNotes.value,
                      stretch: topPullDistance,
                      triggerDistance: authorNotesPullThreshold,
                      onPressed: loadNewerAuthorNotes,
                      topPadding: 16,
                      bottomPadding: 16,
                    ),
                  if (newerAuthorNotes.value.isNotEmpty)
                    _AuthorNotesSliver(
                      notes: newerAuthorNotes.value,
                      horizontalPadding: padding,
                      bottomPadding: 16,
                      growsUp: true,
                    ),
                  if (data != null &&
                      (conversation.isNotEmpty || data.replyId != null))
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                      sliver: SliverToBoxAdapter(
                        child: MkCard(
                          padding: EdgeInsets.fromLTRB(
                            conversationLeftPadding,
                            16,
                            24,
                            0,
                          ),
                          shadow: false,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: conversation.isEmpty
                              ? _ConversationNotePlaceholder(
                                  color: themes.fgColor.withValues(alpha: 0.1),
                                  lineColor: themes.dividerColor,
                                  avatarSize: conversationAvatarSize,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    for (var (index, item)
                                        in conversation.indexed)
                                      TimeLineNoteCardComponent(
                                        data: item,
                                        reply: true,
                                        disableReactions: true,
                                        replyLineBottomPadding:
                                            index == conversation.length - 1
                                            ? 0
                                            : 4,
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  if (data != null)
                    SliverPadding(
                      key: currentNoteSliverKey,
                      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                      sliver: SliverToBoxAdapter(
                        child: MkCard(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            data.replyId != null ? 0 : 16,
                            24,
                            24,
                          ),
                          shadow: false,
                          clipBehavior: data.replyId != null
                              ? Clip.none
                              : Clip.antiAlias,
                          borderRadius: BorderRadius.only(
                            topLeft: data.replyId == null
                                ? const Radius.circular(12)
                                : Radius.zero,
                            topRight: data.replyId == null
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomLeft: showReplyContent
                                ? Radius.zero
                                : const Radius.circular(12),
                            bottomRight: showReplyContent
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                          child: NotesPageNoteCard(data: data),
                        ),
                      ),
                    ),
                  if (showReplyContent)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                      sliver: SliverToBoxAdapter(
                        child: MkCard(
                          shadow: false,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          borderRadius: BorderRadius.zero,
                          child: Container(
                            decoration: BoxDecoration(
                              color: themes.dividerColor,
                            ),
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    sliver: NoteChildren(
                      noteId: noteId,
                      repliesCount: data?.repliesCount ?? 0,
                      onContentVisibilityChanged: (visible) {
                        if (replyContentVisible.value != visible) {
                          replyContentVisible.value = visible;
                        }
                      },
                    ),
                  ),
                  if (olderAuthorNotes.value.isNotEmpty)
                    _AuthorNotesSliver(
                      notes: olderAuthorNotes.value,
                      horizontalPadding: padding,
                      topPadding: 16,
                      bottomPadding: canLoadOlderAuthorNotes.value ? 0 : 16,
                    ),
                  if (data != null)
                    _AuthorNotesLoadButtonSliver(
                      direction: AxisDirection.down,
                      visible: canLoadOlderAuthorNotes.value,
                      loading: loadingOlderAuthorNotes.value,
                      stretch: bottomPullDistance,
                      triggerDistance: authorNotesPullThreshold,
                      onPressed: loadOlderAuthorNotes,
                      topPadding: 16,
                      bottomPadding: 16,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuthorNotesLoadButtonSliver extends ConsumerWidget {
  const _AuthorNotesLoadButtonSliver({
    required this.direction,
    required this.visible,
    required this.loading,
    required this.stretch,
    required this.triggerDistance,
    required this.onPressed,
    this.topPadding = 0,
    this.bottomPadding = 0,
  });

  final AxisDirection direction;
  final bool visible;
  final bool loading;
  final ValueNotifier<double> stretch;
  final double triggerDistance;
  final VoidCallback onPressed;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final isUp = direction == AxisDirection.up;
    return SliverToBoxAdapter(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        alignment: isUp ? Alignment.topCenter : Alignment.bottomCenter,
        clipBehavior: Clip.hardEdge,
        child: visible
            ? Padding(
                padding: EdgeInsets.only(
                  top: topPadding,
                  bottom: bottomPadding,
                ),
                child: Center(
                  child: ValueListenableBuilder<double>(
                    valueListenable: stretch,
                    builder: (context, pullDistance, child) {
                      final pullProgress = triggerDistance <= 0
                          ? 0.0
                          : (pullDistance / triggerDistance).clamp(0.0, 1.0);
                      final stretchedHeight = 38.0 + (pullProgress * 20.0);
                      return Tooltip(
                        message: S.current.more,
                        child: SizedBox(
                          width: 72,
                          height: 38,
                          child: OverflowBox(
                            minHeight: 38,
                            maxHeight: 58,
                            alignment: isUp
                                ? Alignment.bottomCenter
                                : Alignment.topCenter,
                            child: AnimatedContainer(
                              duration: pullDistance > 0
                                  ? Duration.zero
                                  : const Duration(milliseconds: 280),
                              curve: Curves.elasticOut,
                              width: 72,
                              height: stretchedHeight,
                              decoration: BoxDecoration(
                                color: themes.buttonBgColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: loading ? null : onPressed,
                                  hoverColor: themes.buttonHoverBgColor,
                                  splashColor: themes.buttonHoverBgColor,
                                  child: Center(
                                    child: loading
                                        ? LoadingCircularProgress(
                                            size: 18,
                                            strokeWidth: 3,
                                            color: themes.fgColor,
                                            backgroundColor: themes.fgColor
                                                .withValues(alpha: 0.1),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isUp
                                                    ? TablerIcons.chevron_up
                                                    : TablerIcons.chevron_down,
                                                size: 18,
                                                color: themes.fgColor,
                                              ),
                                              const SizedBox(width: 6),
                                              Icon(
                                                TablerIcons.user,
                                                size: 18,
                                                color: themes.fgColor,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}

class _AuthorNotesSliver extends ConsumerWidget {
  const _AuthorNotesSliver({
    required this.notes,
    required this.horizontalPadding,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.growsUp = false,
  });

  final List<NoteModel> notes;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final bool growsUp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dividerColor = ref.watch(themeColorsProvider).dividerColor;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        bottomPadding,
      ),
      sliver: SliverList.separated(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final isFirst = index == 0;
          final isLast = index == notes.length - 1;
          final isVisualTop = growsUp ? isLast : isFirst;
          final isVisualBottom = growsUp ? isFirst : isLast;
          final borderRadius = BorderRadius.only(
            topLeft: isVisualTop ? const Radius.circular(12) : Radius.zero,
            topRight: isVisualTop ? const Radius.circular(12) : Radius.zero,
            bottomLeft: isVisualBottom
                ? const Radius.circular(12)
                : Radius.zero,
            bottomRight: isVisualBottom
                ? const Radius.circular(12)
                : Radius.zero,
          );
          return RepaintBoundary(
            key: ValueKey('note-page-author-${notes[index].id}'),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: NoteCard(data: notes[index], borderRadius: borderRadius),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(height: 1, child: ColoredBox(color: dividerColor)),
      ),
    );
  }
}

class _ConversationNotePlaceholder extends StatelessWidget {
  const _ConversationNotePlaceholder({
    required this.color,
    required this.lineColor,
    required this.avatarSize,
  });

  final Color color;
  final Color lineColor;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 112,
        child: Stack(
          children: [
            Positioned(
              left: (avatarSize - 2) / 2,
              top: avatarSize + 4,
              bottom: 0,
              child: SizedBox(width: 2, child: ColoredBox(color: lineColor)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MkSkeletonBlock(
                  width: avatarSize,
                  height: avatarSize,
                  color: color,
                  shape: BoxShape.circle,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ConversationPlaceholderBar(
                        color: color,
                        widthFactor: 0.4,
                      ),
                      const SizedBox(height: 12),
                      _ConversationPlaceholderBar(
                        color: color,
                        widthFactor: 0.72,
                      ),
                      const SizedBox(height: 18),
                      _ConversationPlaceholderBar(
                        color: color,
                        widthFactor: 0.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationPlaceholderBar extends StatelessWidget {
  const _ConversationPlaceholderBar({
    required this.color,
    required this.widthFactor,
  });

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return MkSkeletonBlock(color: color, height: 10, widthFactor: widthFactor);
  }
}

class NotesPageNoteCard extends HookConsumerWidget {
  const NotesPageNoteCard({super.key, required this.data});

  final NoteModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isHiddenCw = useState(true);
    var themes = ref.watch(themeColorsProvider);
    var noteListener = noteListenerProvider(this.data);
    var data = ref.watch(noteListener);

    // useEffect(() {
    //   // 更新note缓存
    //   ref.read(noteListener.notifier).updateModel(data);
    //   return null;
    // }, [this.data.id]);

    var links = extractLinksFromMarkdown(data.text ?? "");
    var meta = ref.watch(instanceMetaProvider).value;
    var serverUrl = ref.watch(currentLoginUserProvider)!.serverUrl;
    return LayoutBuilder(
      builder: (context, constraints) {
        return ContextMenuBuilder(
          mode: const [
            ContextMenuMode.onSecondaryTap,
            ContextMenuMode.onLongPress,
          ],
          menu: buildNoteContextMenu(
            serverUrl,
            meta,
            data,
            ref,
            context,
            onDeleted: () {
              if (context.mounted) context.pop();
            },
            onRedrafted: (createdNote) {
              if (context.mounted) {
                context.replace(
                  '/notes/${createdNote.id}',
                  extra: createdNote.copyWith(),
                );
              }
            },
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              UserInfo(
                data: data.user,
                connectToPrevious: data.replyId != null,
                suffix: NoteVisibility.getIcon(data.visibility) != null
                    ? Icon(
                        NoteVisibility.getIcon(data.visibility)!,
                        size: 16,
                        color: themes.fgColor,
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              if (data.cw != null) ...[
                MFMText(
                  text: data.cw ?? "",
                  ast: data.cwAst,
                  emojis: data.emojis,
                  currentServerHost: data.user.host,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      isHiddenCw.value = !isHiddenCw.value;
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.hovered)) {
                          return themes.buttonHoverBgColor;
                        }
                        return themes.buttonBgColor;
                      }),
                      foregroundColor: WidgetStateProperty.all(themes.fgColor),
                      elevation: WidgetStateProperty.all(0),
                    ),
                    child: Text(
                      isHiddenCw.value
                          ? S.current.noteCwShow
                          : S.current.noteCwHide,
                    ),
                  ),
                ),
              ],
              if (!isHiddenCw.value || data.cw == null) ...[
                const SizedBox(height: 4),
                if (data.text != null)
                  MFMText(
                    text: data.text ?? "",
                    ast: data.textAst,
                    emojis: data.emojis,
                    currentServerHost: data.user.host,
                    isSelection: true,
                  ),
                if (meta != null &&
                    meta.translatorAvailable &&
                    data.noteTranslate == null)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        translateNote(data, ref);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          S.current.noteTranslate,
                          style: TextStyle(color: themes.accentColor),
                        ),
                      ),
                    ),
                  ),

                if (data.noteTranslate != null)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: themes.dividerColor, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(top: 8, bottom: 2),
                    child: [
                      if (data.noteTranslate!.loading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: LoadingCircularProgress(
                              size: 22,
                              strokeWidth: 4,
                            ),
                          ),
                        )
                      else
                        MFMText(
                          emojis: data.emojis,
                          currentServerHost: data.user.host,
                          before: [
                            TextSpan(
                              text: S.current.noteFormLanguageTranslation(
                                data.noteTranslate!.sourceLang,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          text: data.noteTranslate!.text,
                        ),
                    ][0],
                  ),
                const SizedBox(height: 4),
                // 投票
                if (data.poll != null) NotePoll(data: data),
                TimeLineImage(
                  files: data.files,
                  note: data,
                  mainAxisExtent: constraints.maxWidth * 0.7,
                ),
                for (var link in links)
                  NoteLinkPreview(
                    link: link,
                    fontsize: DefaultTextStyle.of(context).style.fontSize!,
                  ),
              ],
              if (data.reactions.isNotEmpty) const SizedBox(height: 8),
              if (data.renote != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: themes.fgColor.withValues(alpha: 0.6),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: TimeLineNoteCardComponent(
                    data: data.renote!,
                    isShowAction: false,
                    disableReactions: true,
                  ),
                ),
              // 发布日期
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Opacity(
                  opacity: 0.7,
                  child: Text(timeToDesiredFormat(data.createdAt)),
                ),
              ),
              ReactionsListComponent(
                emojis: data.reactionEmojis,
                reactionsList: data.reactions,
                id: data.id,
                myReaction: data.myReaction,
              ),
              const SizedBox(height: 4),
              TimeLineActions(fontsize: 14, data: data),
            ],
          ),
        );
      },
    );
  }
}

class UserInfo extends HookConsumerWidget {
  const UserInfo({
    super.key,
    required this.data,
    this.suffix,
    this.connectToPrevious = false,
  });

  final UserLiteModel data;
  final Widget? suffix;
  final bool connectToPrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (connectToPrevious)
          Positioned(
            left: 27,
            top: -8,
            height: 44,
            child: Container(width: 2, color: themes.dividerColor),
          ),
        Padding(
          padding: EdgeInsets.only(top: connectToPrevious ? 8 : 0),
          child: Row(
            children: [
              GestureDetector(
                child: MkImage(
                  data.avatarUrl ?? "",
                  blurHash: data.avatarBlurhash,
                  width: 56,
                  height: 56,
                  shape: BoxShape.circle,
                ),
                onTap: () {
                  context.push("/user/${data.id}");
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MFMText(
                        text: data.name ?? data.username,
                        emojis: data.emojis,
                        bigEmojiCode: false,
                        feature: const [MFMFeature.emojiCode],
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "@${data.username}"),
                            if (data.host != null)
                              TextSpan(
                                text: "@${data.host}",
                                style: TextStyle(
                                  color: themes.fgColor.withValues(alpha: 0.7),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (data.instance != null) UserInstanceBar(data: data),
                    ],
                  ),
                  onTap: () {
                    context.push("/user/${data.id}");
                  },
                ),
              ),
              ?suffix,
            ],
          ),
        ),
      ],
    );
  }
}
