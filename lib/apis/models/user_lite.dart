import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_lite.freezed.dart';

part 'user_lite.g.dart';

@freezed
class UserLiteModel with _$UserLiteModel {
  const factory UserLiteModel({
    required String? avatarBlurhash,
    required List<AvatarDecoration> avatarDecorations,
    required String? avatarUrl,
    @Default([]) List<BadgeRole> badgeRoles,
    required Map<String, String> emojis,
    required String? host,
    required String id,
    Instance? instance,
    @Default(false) bool isBot,
    @Default(false) bool isCat,
    required double? makeNotesFollowersOnlyBefore,
    required double? makeNotesHiddenBefore,
    required String? name,
    required OnlineStatus onlineStatus,
    @Default(false) bool requireSigninToViewContents,
    required String username,
  }) = _UserLiteModel;

  factory UserLiteModel.fromJson(Map<String, dynamic> json) =>
      _$UserLiteModelFromJson(json);
}

extension UserLiteModelExtension on UserLiteModel {
  String getAtUserName() {
    return "@$username${host != null ? "@$host" : ""}";
  }
}

@freezed
class AvatarDecoration with _$AvatarDecoration {
  const factory AvatarDecoration({
    @Default(0) double angle,
    @Default(false) bool flipH,
    required String id,
    @Default(0) double offsetX,
    @Default(0) double offsetY,
    required String url,
  }) = _AvatarDecoration;

  factory AvatarDecoration.fromJson(Map<String, dynamic> json) =>
      _$AvatarDecorationFromJson(json);
}

@freezed
class BadgeRole with _$BadgeRole {
  const factory BadgeRole({
    required double displayOrder,
    required String? iconUrl,
    required String name,
  }) = _BadgeRole;

  factory BadgeRole.fromJson(Map<String, dynamic> json) =>
      _$BadgeRoleFromJson(json);
}

@freezed
class Instance with _$Instance {
  const factory Instance({
    required String? faviconUrl,
    required String? iconUrl,
    required String? name,
    required String? softwareName,
    required String? softwareVersion,
    required String? themeColor,
  }) = _Instance;

  factory Instance.fromJson(Map<String, dynamic> json) =>
      _$InstanceFromJson(json);
}

enum OnlineStatus {
  @JsonValue("active")
  ACTIVE,
  @JsonValue("offline")
  OFFLINE,
  @JsonValue("online")
  ONLINE,
  @JsonValue("unknown")
  UNKNOWN
}
