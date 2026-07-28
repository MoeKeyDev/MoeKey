import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/notifications.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/notifications/notifications_user_card.dart';

import '../../apis/models/notification.dart';
import '../../apis/services/following_service.dart';
import '../../generated/l10n.dart';
import '../../utils/achievement_title.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/reactions.dart';

enum _FollowRequestAction { idle, loading, accepted, rejected }

final _incomingFollowRequestStatusProvider = FutureProvider.autoDispose
    .family<IncomingFollowRequestStatus, String>((ref, userId) {
      return ref
          .watch(misskeyApisProvider)
          .following
          .incomingRequestStatus(userId: userId);
    });

class NotificationsGroupList extends HookConsumerWidget {
  const NotificationsGroupList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final data = ref.watch(notificationsProvider);
    final list = data.value?.list ?? [];
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = EdgeInsets.symmetric(
          horizontal: getPaddingForNote(constraints),
        );
        return MkRefreshLoadList(
          onLoad: () => ref.read(notificationsProvider.notifier).loadMore(),
          onRefresh: () => ref.refresh(notificationsProvider.future),
          hasMore: data.value?.hasMore,
          slivers: [
            SliverList.separated(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final borderRadius = index == 0
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      )
                    : BorderRadius.zero;
                return Padding(
                  padding: padding,
                  child: NotificationItemCard(
                    data: list[index],
                    borderRadius: borderRadius,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: padding,
                  child: SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: themes.dividerColor),
                    ),
                  ),
                );
              },
            ),
          ],
          empty: list.isEmpty,
        );
      },
    );
  }
}

class NotificationItemCard extends HookConsumerWidget {
  const NotificationItemCard({
    super.key,
    required this.data,
    required this.borderRadius,
    this.navigationEnabled = true,
  });

  final NotificationModel data;
  final BorderRadius borderRadius;
  final bool navigationEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final currentUser = ref.watch(currentLoginUserProvider)?.userInfo;
    final followRequestAction = useState(_FollowRequestAction.idle);
    final followRequesterId = data.user?.id ?? data.userId;
    final followRequestStatus =
        data.notificationType == NotificationType.receiveFollowRequest &&
            followRequesterId != null
        ? ref.watch(_incomingFollowRequestStatusProvider(followRequesterId))
        : null;

    Widget currentUserAvatar(IconData fallbackIcon) {
      if (currentUser?.avatarUrl != null) {
        return MkImage(
          currentUser!.avatarUrl!,
          blurHash: currentUser.avatarBlurhash,
          shape: BoxShape.circle,
          width: double.infinity,
          height: double.infinity,
        );
      }
      return _iconAvatar(fallbackIcon, themes.accentColor);
    }

    Widget noteAuthorAvatar(IconData fallbackIcon) {
      final author = data.note?.user;
      if (author?.avatarUrl?.isNotEmpty == true) {
        return MkImage(
          author!.avatarUrl!,
          blurHash: author.avatarBlurhash,
          shape: BoxShape.circle,
          width: double.infinity,
          height: double.infinity,
        );
      }
      return _iconAvatar(fallbackIcon, themes.accentColor);
    }

    NotificationsUserCard card({
      required Widget content,
      Widget? name,
      Widget? avatar,
      Widget? badge,
      Widget? footer,
      void Function(BuildContext context)? onTap,
    }) {
      return NotificationsUserCard(
        data: data,
        borderRadius: borderRadius,
        content: content,
        name: name,
        avatar: avatar,
        avatarBadge: badge,
        footer: footer,
        onTap: onTap,
      );
    }

    void openUser(BuildContext context) {
      if (!navigationEnabled) {
        return;
      }
      final userId = data.user?.id ?? data.userId;
      if (userId != null) {
        context.push('/user/$userId');
      }
    }

    void openNote(BuildContext context) {
      if (!navigationEnabled) {
        return;
      }
      if (data.note != null) {
        context.push('/notes/${data.note!.id}');
      }
    }

    Future<void> respondToFollowRequest(bool accept) async {
      final userId = data.user?.id ?? data.userId;
      if (userId == null ||
          followRequestAction.value == _FollowRequestAction.loading) {
        return;
      }
      followRequestAction.value = _FollowRequestAction.loading;
      try {
        final following = ref.read(misskeyApisProvider).following;
        if (accept) {
          await following.requestsAccept(userId: userId);
        } else {
          await following.requestsReject(userId: userId);
        }
        followRequestAction.value = accept
            ? _FollowRequestAction.accepted
            : _FollowRequestAction.rejected;
        ref.invalidate(_incomingFollowRequestStatusProvider(userId));
      } catch (_) {
        followRequestAction.value = _FollowRequestAction.idle;
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(S.current.notifyActionFailed)));
        }
      }
    }

    Widget labelledContent(String label, {String? summary}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          if (summary != null && summary.isNotEmpty) ...[
            const SizedBox(height: 4),
            MFMText(
              text: summary,
              bigEmojiCode: false,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              currentServerHost: data.note?.user.host,
            ),
          ],
        ],
      );
    }

    switch (data.notificationType) {
      case NotificationType.note:
        return card(
          content: labelledContent(
            S.current.notifyNewNote,
            summary: _noteSummary(data.note),
          ),
          avatar: noteAuthorAvatar(TablerIcons.note),
          onTap: openNote,
        );
      case NotificationType.follow:
        return card(
          content: Text(S.current.notifyFollowedYou),
          badge: _iconBadge(themes, TablerIcons.plus, themes.accentColor),
          onTap: openUser,
        );
      case NotificationType.mention:
        return card(
          content: labelledContent(
            S.current.notifyMentionedYou,
            summary: _noteSummary(data.note),
          ),
          badge: _iconBadge(themes, TablerIcons.at, themes.mentionColor),
          onTap: openNote,
        );
      case NotificationType.reply:
        return card(
          content: labelledContent(
            S.current.notifyRepliedToYou,
            summary: _noteSummary(data.note),
          ),
          badge: _iconBadge(
            themes,
            TablerIcons.arrow_back_up,
            themes.accentColor,
          ),
          onTap: openNote,
        );
      case NotificationType.renote:
        return card(
          content: labelledContent(
            S.current.notifyRenoted,
            summary: _noteSummary(data.note?.renote),
          ),
          badge: _iconBadge(themes, TablerIcons.repeat, themes.reNoteColor),
          onTap: openNote,
        );
      case NotificationType.quote:
        return card(
          content: labelledContent(
            S.current.notifyQuoted,
            summary: _noteSummary(data.note),
          ),
          badge: _iconBadge(themes, TablerIcons.quote, themes.accentColor),
          onTap: openNote,
        );
      case NotificationType.reaction:
        return card(
          content: labelledContent(
            S.current.notifyReacted,
            summary: _noteSummary(data.note),
          ),
          badge: _reactionBadge(themes),
          onTap: openNote,
        );
      case NotificationType.pollEnded:
        return card(
          name: Text(S.current.notifyPollEnded),
          content: labelledContent(
            S.current.voteResult,
            summary: _noteSummary(data.note),
          ),
          avatar: noteAuthorAvatar(TablerIcons.chart_arrows),
          badge: _iconBadge(
            themes,
            TablerIcons.chart_arrows,
            themes.successColor,
          ),
          onTap: openNote,
        );
      case NotificationType.scheduledNotePosted:
        return card(
          name: Text(S.current.notifyScheduledNotePosted),
          content: labelledContent(
            S.current.notifyScheduledNotePostedDescription,
            summary: _noteSummary(data.note),
          ),
          avatar: currentUserAvatar(TablerIcons.send),
          badge: _iconBadge(themes, TablerIcons.send, themes.successColor),
          onTap: openNote,
        );
      case NotificationType.scheduledNotePostFailed:
        return card(
          name: Text(S.current.notifyScheduledNotePostFailed),
          content: labelledContent(
            S.current.notifyScheduledNotePostFailedDescription,
            summary: _draftSummary(data.noteDraft),
          ),
          avatar: currentUserAvatar(TablerIcons.alert_triangle),
          badge: _iconBadge(
            themes,
            TablerIcons.alert_triangle,
            themes.errorColor,
          ),
        );
      case NotificationType.receiveFollowRequest:
        return card(
          content: Text(S.current.notifyReceiveFollowRequest),
          badge: _iconBadge(themes, TablerIcons.clock, themes.accentColor),
          footer: _followRequestFooter(
            themes,
            followRequestAction.value,
            followRequestStatus,
            respondToFollowRequest,
          ),
          onTap: openUser,
        );
      case NotificationType.followRequestAccepted:
        return card(
          content: labelledContent(
            S.current.notifyFollowedAccepted,
            summary: data.message,
          ),
          badge: _iconBadge(themes, TablerIcons.check, themes.successColor),
          onTap: openUser,
        );
      case NotificationType.roleAssigned:
        return card(
          name: Text(S.current.notifyRoleAssigned),
          content: Text(data.role?.name ?? S.current.notifyRoleAssigned),
          avatar: currentUserAvatar(TablerIcons.badges),
          badge: data.role?.iconUrl != null
              ? _imageBadge(themes, data.role!.iconUrl!)
              : _iconBadge(themes, TablerIcons.badges, themes.accentColor),
        );
      case NotificationType.chatRoomInvitationReceived:
        return card(
          name: Text(S.current.notifyChatRoomInvitationUnsupported),
          content: Text(S.current.notifyNotSupport(data.type)),
          avatar: _iconAvatar(TablerIcons.messages, themes.accentColor),
          badge: _iconBadge(themes, TablerIcons.messages, themes.warnColor),
        );
      case NotificationType.achievementEarned:
        return card(
          name: Text(S.current.notifyAchievementEarned),
          content: Text(achievementTitle(context, data.achievement)),
          avatar: currentUserAvatar(TablerIcons.medal),
          badge: _iconBadge(themes, TablerIcons.medal, themes.warnColor),
        );
      case NotificationType.exportCompleted:
        return card(
          name: Text(S.current.notifyExportCompleted),
          content: Text(_exportedEntityName(data.exportedEntity)),
          avatar: currentUserAvatar(TablerIcons.archive),
          badge: _iconBadge(themes, TablerIcons.archive, themes.successColor),
        );
      case NotificationType.login:
        return card(
          name: Text(S.current.notifyLogin),
          content: Text(S.current.notifyLoginDescription),
          avatar: currentUserAvatar(TablerIcons.login_2),
          badge: _iconBadge(themes, TablerIcons.login_2, themes.accentColor),
        );
      case NotificationType.createToken:
        return card(
          name: Text(S.current.notifyCreateToken),
          content: Text(S.current.notifyCreateTokenDescription),
          avatar: currentUserAvatar(TablerIcons.key),
          badge: _iconBadge(themes, TablerIcons.key, themes.warnColor),
        );
      case NotificationType.app:
        return card(
          name: Text(
            data.header?.trim().isNotEmpty == true
                ? data.header!
                : S.current.notifyApp,
          ),
          content: MFMText(text: data.body ?? '', bigEmojiCode: false),
          avatar: data.icon != null
              ? MkImage(
                  data.icon!,
                  shape: BoxShape.circle,
                  width: double.infinity,
                  height: double.infinity,
                )
              : _iconAvatar(TablerIcons.apps, themes.accentColor),
        );
      case NotificationType.test:
        return card(
          name: Text(S.current.notifyTest),
          content: Text(S.current.notifyTestDescription),
          avatar: currentUserAvatar(TablerIcons.bell),
          badge: _iconBadge(themes, TablerIcons.bell, themes.accentColor),
        );
      case NotificationType.reactionGrouped:
        final isLikeOnly =
            data.note?.reactionAcceptance == NoteReactionAcceptance.likeOnly;
        return card(
          name: Text(
            S.current.notifyReactionGrouped(data.reactions?.length ?? 0),
          ),
          content: _reactionUsers(context, themes),
          avatar: _iconAvatar(
            isLikeOnly ? TablerIcons.heart : TablerIcons.plus,
            themes.warnColor,
          ),
          onTap: openNote,
        );
      case NotificationType.renoteGrouped:
        return card(
          name: Text(S.current.notifyRenoteGrouped(data.users?.length ?? 0)),
          content: _renoteUsers(context),
          avatar: _iconAvatar(TablerIcons.repeat, themes.reNoteColor),
          onTap: openNote,
        );
      case NotificationType.unknown:
        return card(
          name: Text(S.current.notifyNotSupport(data.type)),
          content: Text(data.type),
          avatar: _iconAvatar(TablerIcons.help, themes.warnColor),
        );
    }
  }

  Widget _reactionBadge(ThemeColorModel themes) {
    if (data.reaction == null) {
      return _iconBadge(themes, TablerIcons.help, themes.warnColor);
    }
    return Container(
      decoration: BoxDecoration(
        color: themes.panelColor,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: themes.panelColor, spreadRadius: 3)],
      ),
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: 20,
        height: 20,
        child: ReactionsIcon(
          emojiCode: data.reaction!,
          emojis: data.note?.reactionEmojis,
        ),
      ),
    );
  }

  Widget _reactionUsers(BuildContext context, ThemeColorModel themes) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in data.reactions ?? const <NoteReaction>[])
          GestureDetector(
            onTap: () => context.push('/user/${item.user.id}'),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  MkImage(
                    item.user.avatarUrl ?? '',
                    blurHash: item.user.avatarBlurhash,
                    shape: BoxShape.circle,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themes.panelColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: ReactionsIcon(
                          emojiCode: item.reaction,
                          emojis: data.note?.reactionEmojis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _renoteUsers(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final user in data.users ?? const [])
          GestureDetector(
            onTap: () => context.push('/user/${user.id}'),
            child: MkImage(
              user.avatarUrl ?? '',
              blurHash: user.avatarBlurhash,
              shape: BoxShape.circle,
              width: 38,
              height: 38,
            ),
          ),
      ],
    );
  }
}

Widget _followRequestFooter(
  ThemeColorModel themes,
  _FollowRequestAction action,
  AsyncValue<IncomingFollowRequestStatus>? serverStatus,
  Future<void> Function(bool accept) respond,
) {
  if (action == _FollowRequestAction.accepted) {
    return Text(S.current.notifyAccepted);
  }
  if (action == _FollowRequestAction.rejected) {
    return Text(S.current.notifyRejected);
  }
  if (action == _FollowRequestAction.loading ||
      serverStatus?.isLoading == true) {
    return const Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
  final resolvedStatus = serverStatus?.value;
  if (resolvedStatus == IncomingFollowRequestStatus.accepted) {
    return Text(S.current.notifyAccepted);
  }
  if (resolvedStatus == IncomingFollowRequestStatus.handled) {
    return Text(S.current.done);
  }
  return Row(
    children: [
      Expanded(
        child: _followRequestButton(
          label: S.current.notifyAccept,
          icon: TablerIcons.check,
          color: themes.successColor,
          foregroundColor: themes.fgOnAccentColor,
          onPressed: () => respond(true),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _followRequestButton(
          label: S.current.notifyReject,
          icon: TablerIcons.x,
          color: themes.errorColor,
          foregroundColor: themes.fgOnAccentColor,
          onPressed: () => respond(false),
        ),
      ),
    ],
  );
}

Widget _followRequestButton({
  required String label,
  required IconData icon,
  required Color color,
  required Color foregroundColor,
  required VoidCallback onPressed,
}) {
  return FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: color,
      foregroundColor: foregroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
    ),
    child: SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(alignment: Alignment.centerLeft, child: Icon(icon, size: 16)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _iconBadge(ThemeColorModel themes, IconData icon, Color color) {
  return Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [BoxShadow(color: themes.panelColor, spreadRadius: 3)],
    ),
    child: Icon(icon, size: 15, color: themes.fgOnAccentColor),
  );
}

Widget _imageBadge(ThemeColorModel themes, String url) {
  return Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: themes.panelColor,
      boxShadow: [BoxShadow(color: themes.panelColor, spreadRadius: 3)],
    ),
    clipBehavior: Clip.antiAlias,
    child: MkImage(url, shape: BoxShape.circle),
  );
}

Widget _iconAvatar(IconData icon, Color color) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: const SizedBox(),
  ).withCenteredIcon(icon);
}

extension on Widget {
  Widget withCenteredIcon(IconData icon) {
    return Stack(
      fit: StackFit.expand,
      children: [
        this,
        Icon(icon, size: 28, color: Colors.white),
      ],
    );
  }
}

String _noteSummary(NoteModel? note) {
  if (note == null) {
    return '';
  }
  return '${note.cw ?? ''}${note.text ?? ''}'.replaceAll('\n', ' ').trim();
}

String _draftSummary(NotificationNoteDraft? draft) {
  if (draft == null) {
    return '';
  }
  return '${draft.cw ?? ''}${draft.text ?? ''}'.replaceAll('\n', ' ').trim();
}

String _exportedEntityName(String? value) {
  switch (value) {
    case 'antenna':
      return S.current.exportEntityAntenna;
    case 'blocking':
      return S.current.exportEntityBlocking;
    case 'clip':
      return S.current.exportEntityClip;
    case 'customEmoji':
      return S.current.exportEntityCustomEmoji;
    case 'favorite':
      return S.current.exportEntityFavorite;
    case 'following':
      return S.current.exportEntityFollowing;
    case 'muting':
      return S.current.exportEntityMuting;
    case 'note':
      return S.current.exportEntityNote;
    case 'userList':
      return S.current.exportEntityUserList;
    default:
      return value ?? '-';
  }
}
