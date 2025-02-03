import 'package:freezed_annotation/freezed_annotation.dart';
import 'note.dart';
import 'user_lite.dart';

part 'user_full.freezed.dart';

part 'user_full.g.dart';

@unfreezed
class UserFullModel with _$UserFullModel {
  factory UserFullModel({
    String? avatarBlurhash,
    String? avatarUrl,
    String? bannerBlurhash,
    String? bannerUrl,
    String? birthday,
    required DateTime createdAt,
    String? description,
    String? email,
    @Default({}) Map<String, dynamic> emojis,
    required num followersCount,
    required num followingCount,
    String? host,
    required String id,
    @Default(false) bool isAdmin,
    required OnlineStatus onlineStatus,
    DateTime? updatedAt,
    required String username,
    String? name,
    @Default([]) List<dynamic> fields,
    List<AvatarDecoration>? avatarDecorations,
    String? ffVisibility,
    FollowVisibility? followersVisibility,
    FollowVisibility? followingVisibility,
    @Default([]) List<NoteModel> pinnedNotes,
    @Default([]) List<String> pinnedNotesIds,
    String? uri,
    String? url,
    required num notesCount,
    @Default(false) bool publicReactions,
    @Default(false) bool isFollowed,
    @Default(false) bool isFollowing,
    @Default(false) bool hasPendingFollowRequestFromYou,
    @Default(false) bool hasPendingFollowRequestToYou,
    @Default(false) bool isLocked,
  }) = _UserFullModel;

  factory UserFullModel.fromJson(Map<String, dynamic> json) =>
      _$UserFullModelFromJson(json);
}

enum FollowVisibility {
  @JsonValue("followers")
  FOLLOWERS,
  @JsonValue("private")
  PRIVATE,
  @JsonValue("public")
  PUBLIC
}
