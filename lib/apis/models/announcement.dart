import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'announcement.freezed.dart';

part 'announcement.g.dart';

@unfreezed
abstract class Announcement with _$Announcement {
  factory Announcement({
    double? closeDuration,
    required DateTime createdAt,
    required AnnouncementDisplay display,
    double? displayOrder,
    required bool forYou,
    required AnnouncementIcon icon,
    required String id,
    String? imageUrl,
    @Default(false) bool isRead,
    required bool needConfirmationToRead,
    required bool silence,
    required String text,
    required String title,
    DateTime? updatedAt,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}

enum AnnouncementDisplay {
  @JsonValue('banner')
  banner,
  @JsonValue('dialog')
  dialog,
  @JsonValue('normal')
  normal,
}

enum AnnouncementIcon {
  @JsonValue('error')
  error,
  @JsonValue('info')
  info,
  @JsonValue('success')
  success,
  @JsonValue('warning')
  warning,
}
