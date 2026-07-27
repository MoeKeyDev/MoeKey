import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moekey/apis/models/user_lite.dart';

import 'note.dart';

part 'notification.freezed.dart';

part 'notification.g.dart';

/// A notification returned by Misskey.
///
/// The wire type is intentionally stored as a string. Misskey can add new
/// notification types before MoeKey is updated, and an unknown type must not
/// make the entire notifications response fail to decode.
@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required DateTime createdAt,
    required String id,
    NoteModel? note,
    NotificationNoteDraft? noteDraft,
    required String type,
    UserLiteModel? user,
    String? userId,
    String? reaction,
    String? message,
    NotificationRole? role,
    String? achievement,
    String? exportedEntity,
    String? fileId,
    String? body,
    String? header,
    String? icon,
    List<NoteReaction>? reactions,
    List<UserLiteModel>? users,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  NotificationType get notificationType => NotificationType.fromWireValue(type);
}

@freezed
abstract class NotificationNoteDraft with _$NotificationNoteDraft {
  const factory NotificationNoteDraft({String? text, String? cw}) =
      _NotificationNoteDraft;

  factory NotificationNoteDraft.fromJson(Map<String, dynamic> json) =>
      _$NotificationNoteDraftFromJson(json);
}

@freezed
abstract class NotificationRole with _$NotificationRole {
  const factory NotificationRole({required String name, String? iconUrl}) =
      _NotificationRole;

  factory NotificationRole.fromJson(Map<String, dynamic> json) =>
      _$NotificationRoleFromJson(json);
}

enum NotificationType {
  note('note'),
  follow('follow'),
  mention('mention'),
  reply('reply'),
  renote('renote'),
  quote('quote'),
  reaction('reaction'),
  pollEnded('pollEnded'),
  scheduledNotePosted('scheduledNotePosted'),
  scheduledNotePostFailed('scheduledNotePostFailed'),
  receiveFollowRequest('receiveFollowRequest'),
  followRequestAccepted('followRequestAccepted'),
  roleAssigned('roleAssigned'),
  chatRoomInvitationReceived('chatRoomInvitationReceived'),
  achievementEarned('achievementEarned'),
  exportCompleted('exportCompleted'),
  login('login'),
  createToken('createToken'),
  app('app'),
  test('test'),
  reactionGrouped('reaction:grouped'),
  renoteGrouped('renote:grouped'),
  unknown('');

  const NotificationType(this.wireValue);

  final String wireValue;

  static NotificationType fromWireValue(String value) {
    for (final type in values) {
      if (type.wireValue == value) {
        return type;
      }
    }
    return unknown;
  }
}

@freezed
abstract class NoteReaction with _$NoteReaction {
  const factory NoteReaction({
    required String reaction,
    required UserLiteModel user,
  }) = _NoteReaction;

  factory NoteReaction.fromJson(Map<String, dynamic> json) =>
      _$NoteReactionFromJson(json);
}
