import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:flutter/foundation.dart';

part 'me_detailed.freezed.dart';

part 'me_detailed.g.dart';

@freezed
class MeDetailed with _$MeDetailed {
  const factory MeDetailed({
    required String? avatarBlurhash,
    required List<AvatarDecoration> avatarDecorations,
    required String? avatarUrl,
    List<BadgeRole>? badgeRoles,
    required Map<String, String> emojis,
    required String? host,
    required String id,
    Instance? instance,
    bool? isBot,
    bool? isCat,
    double? makeNotesFollowersOnlyBefore,
    double? makeNotesHiddenBefore,
    required String? name,
    required OnlineStatus onlineStatus,
    bool? requireSigninToViewContents,
    required String username,
    required List<String>? alsoKnownAs,
    required String? bannerBlurhash,
    required String? bannerUrl,
    required String? birthday,
    required DateTime createdAt,
    required String? description,
    @Default([]) List<dynamic> fields,
    required String? followedMessage,
    required double followersCount,
    required FollowVisibility followersVisibility,
    required double followingCount,
    required FollowVisibility followingVisibility,
    bool? hasPendingFollowRequestFromYou,
    bool? hasPendingFollowRequestToYou,
    bool? isBlocked,
    bool? isBlocking,
    bool? isFollowed,
    bool? isFollowing,
    required bool isLocked,
    bool? isMuted,
    bool? isRenoteMuted,
    required bool isSilenced,
    required bool isSuspended,
    required String? lang,
    required DateTime? lastFetchedAt,
    required String? location,
    required String? memo,
    String? moderationNote,
    required String? movedTo,
    required double notesCount,
    Notify? notify,
    required List<String> pinnedNoteIds,
    required List<NoteModel> pinnedNotes,
    // required Page pinnedPage,
    required String? pinnedPageId,
    required bool publicReactions,
    // required List<RoleLite> roles,
    required bool securityKeys,
    required bool twoFactorEnabled,
    required DateTime? updatedAt,
    required String? uri,
    required String? url,
    required bool usePasswordLessLogin,
    required List<String> verifiedLinks,
    bool? withReplies,
    // required List<Achievement> achievements,
    required bool alwaysMarkNsfw,
    required bool autoAcceptFollowed,
    required bool autoSensitive,
    required String? avatarId,
    required String? bannerId,
    required bool carefulBot,
    String? email,
    required List<String> emailNotificationTypes,
    bool? emailVerified,
    required List<List<String>> hardMutedWords,
    required bool hasPendingReceivedFollowRequest,
    required bool hasUnreadAnnouncement,
    required bool hasUnreadAntenna,
    required bool hasUnreadChannel,
    required bool hasUnreadMentions,
    required bool hasUnreadNotification,
    required bool hasUnreadSpecifiedNotes,
    required bool hideOnlineStatus,
    required bool injectFeaturedNote,
    required bool? isAdmin,
    required bool isDeleted,
    required bool isExplorable,
    required bool? isModerator,
    required double loggedInDays,
    required List<String>? mutedInstances,
    required List<List<String>> mutedWords,
    required bool noCrawle,
    // required NotificationRecieveConfig notificationRecieveConfig,
    // required RolePolicies policies,
    required bool preventAiLearning,
    required bool receiveAnnouncementEmail,
    // List<SecurityKeysList>? securityKeysList,
    // required TwoFactorBackupCodesStock twoFactorBackupCodesStock,
    // required List<Announcement> unreadAnnouncements,
    required double unreadNotificationsCount,
  }) = _MeDetailed;

  factory MeDetailed.fromJson(Map<String, dynamic> json) =>
      _$MeDetailedFromJson(json);
}

enum Notify {
  @JsonValue("none")
  NONE,
  @JsonValue("normal")
  NORMAL
}
