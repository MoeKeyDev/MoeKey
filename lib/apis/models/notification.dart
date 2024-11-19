import 'dart:convert';

import 'package:moekey/apis/models/user_lite.dart';

import 'note.dart';

///Notification
class NotificationModel {
  final DateTime createdAt;
  final String id;
  final NoteModel? note;
  final NotificationType type;
  final UserLiteModel? user;
  final String? userId;
  final String? reaction;
  final String? achievement;
  final String? body;
  final String? header;
  final String? icon;
  final List<NoteReaction>? reactions;
  final List<UserLiteModel>? users;

  NotificationModel({
    required this.createdAt,
    required this.id,
    this.note,
    required this.type,
    this.user,
    this.userId,
    this.reaction,
    this.achievement,
    this.body,
    this.header,
    this.icon,
    this.reactions,
    this.users,
  });

  NotificationModel copyWith({
    DateTime? createdAt,
    String? id,
    NoteModel? note,
    NotificationType? type,
    UserLiteModel? user,
    String? userId,
    String? reaction,
    String? achievement,
    String? body,
    String? header,
    String? icon,
    List<NoteReaction>? reactions,
    List<UserLiteModel>? users,
  }) =>
      NotificationModel(
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        note: note ?? this.note,
        type: type ?? this.type,
        user: user ?? this.user,
        userId: userId ?? this.userId,
        reaction: reaction ?? this.reaction,
        achievement: achievement ?? this.achievement,
        body: body ?? this.body,
        header: header ?? this.header,
        icon: icon ?? this.icon,
        reactions: reactions ?? this.reactions,
        users: users ?? this.users,
      );

  factory NotificationModel.fromJson(String str) =>
      NotificationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        createdAt: DateTime.parse(json["createdAt"]),
        id: json["id"],
        note: json["note"] == null ? null : NoteModel.fromMap(json["note"]),
        type: notificationTypeValues.map[json["type"]]!,
        user: json["user"] == null ? null : UserLiteModel.fromMap(json["user"]),
        userId: json["userId"],
        reaction: json["reaction"],
        achievement: json["achievement"],
        body: json["body"],
        header: json["header"],
        icon: json["icon"],
        reactions: json["reactions"] == null
            ? []
            : List<NoteReaction>.from(
                json["reactions"]!.map((x) => NoteReaction.fromMap(x))),
        users: json["users"] == null
            ? []
            : List<UserLiteModel>.from(
                json["users"]!.map((x) => UserLiteModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "createdAt": createdAt.toIso8601String(),
        "id": id,
        "note": note?.toMap(),
        "type": notificationTypeValues.reverse[type],
        "user": user?.toMap(),
        "userId": userId,
        "reaction": reaction,
        "achievement": achievement,
        "body": body,
        "header": header,
        "icon": icon,
        "reactions": reactions == null
            ? []
            : List<dynamic>.from(reactions!.map((x) => x.toMap())),
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toMap())),
      };
}

enum NotificationType {
  achievementEarned,
  app,
  follow,
  followRequestAccepted,
  mention,
  note,
  pollEnded,
  quote,
  reaction,
  reactionGrouped,
  receiveFollowRequest,
  renote,
  renoteGrouped,
  reply,
  roleAssigned,
  test,
  login,
}

final notificationTypeValues = EnumValues({
  "achievementEarned": NotificationType.achievementEarned,
  "app": NotificationType.app,
  "follow": NotificationType.follow,
  "followRequestAccepted": NotificationType.followRequestAccepted,
  "mention": NotificationType.mention,
  "note": NotificationType.note,
  "pollEnded": NotificationType.pollEnded,
  "quote": NotificationType.quote,
  "reaction": NotificationType.reaction,
  "reaction:grouped": NotificationType.reactionGrouped,
  "receiveFollowRequest": NotificationType.receiveFollowRequest,
  "renote": NotificationType.renote,
  "renote:grouped": NotificationType.renoteGrouped,
  "reply": NotificationType.reply,
  "roleAssigned": NotificationType.roleAssigned,
  "test": NotificationType.test,
  "login": NotificationType.login
});

///NoteReaction
class NoteReaction {
  final String reaction;
  final UserLiteModel user;

  NoteReaction({
    required this.reaction,
    required this.user,
  });

  NoteReaction copyWith({
    String? type,
    UserLiteModel? user,
  }) =>
      NoteReaction(
        reaction: type ?? this.reaction,
        user: user ?? this.user,
      );

  factory NoteReaction.fromJson(String str) =>
      NoteReaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NoteReaction.fromMap(Map<String, dynamic> json) {
    return NoteReaction(
      reaction: json["reaction"],
      user: UserLiteModel.fromMap(json["user"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "type": reaction,
        "user": user.toMap(),
      };
}
