import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:moekey/apis/models/translate.dart';
import 'package:moekey/apis/models/user_lite.dart';

import 'drive.dart';

class MkLoadMoreListModel<T> {
  List<T> list = [];
  bool hasMore = true;
}

class NoteListModel extends MkLoadMoreListModel<NoteModel> {}

class NoteModel {
  String id;
  int clippedCount;
  DateTime createdAt;
  String? cw;
  Map emojis;
  List<DriveFileModel> files;
  bool localOnly;
  NoteReactionAcceptance? reactionAcceptance;
  Map reactionEmojis;
  Map<String, int> reactions;
  String? myReaction;
  NoteModel? renote;
  int renoteCount;
  String? renoteId;
  int repliesCount;
  NoteModel? reply;
  String? replyId;
  String? text;
  String? uri;
  UserLiteModel user;
  String userId;
  NoteVisibility visibility;
  NotePollModel? poll;

  NoteTranslate? noteTranslate;

  NoteModel({
    required this.id,
    required this.clippedCount,
    required this.createdAt,
    this.cw,
    required this.emojis,
    required this.files,
    required this.localOnly,
    this.reactionAcceptance,
    required this.reactionEmojis,
    required this.reactions,
    this.myReaction,
    this.renote,
    required this.renoteCount,
    this.renoteId,
    required this.repliesCount,
    this.replyId,
    this.reply,
    this.text,
    this.poll,
    this.uri,
    required this.user,
    required this.userId,
    required this.visibility,
    this.noteTranslate,
  });

  @override
  String toString() {
    return 'NoteModel{id: $id, clippedCount: $clippedCount, createdAt: $createdAt, cw: $cw, emojis: $emojis, files: $files, localOnly: $localOnly, reactionAcceptance: $reactionAcceptance, reactionEmojis: $reactionEmojis, reactions: $reactions, myReaction: $myReaction, renote: $renote, renoteCount: $renoteCount, renoteId: $renoteId, repliesCount: $repliesCount, reply: $reply, replyId: $replyId, text: $text, uri: $uri, user: $user, userId: $userId, visibility: $visibility, poll: $poll, noteTranslate: $noteTranslate}';
  }

  String createReplyAtText(String? currentUserId) {
    var initText = "";
    if (user.id != currentUserId) {
      initText += user.getAtUserName();
    }
    if (reply?.user != null &&
        reply!.user.id != user.id &&
        reply!.user.id != currentUserId) {
      initText += " ";
      initText += reply!.user.getAtUserName();
    }
    return initText;
  }

  factory NoteModel.fromMap(dynamic map) {
    List<DriveFileModel> files = [];
    for (var item in map?['files']) {
      files.add(DriveFileModel.fromMap(item));
    }
    return NoteModel(
      id: map['id'],
      clippedCount: map['clippedCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      cw: map['cw']?.toString(),
      emojis: map['emojis'] ?? {},
      files: files,
      localOnly: map['localOnly'],
      reactionAcceptance:
          NoteReactionAcceptance.fromString(map['reactionAcceptance']),
      reactionEmojis: map['reactionEmojis'],
      reactions: Map<String, int>.from(
          map['reactions'].map((k, v) => MapEntry<String, int>(k, v.toInt()))),
      myReaction: map['myReaction'],
      renote: map['renote'] != null ? NoteModel.fromMap(map['renote']) : null,
      renoteCount: map['renoteCount'],
      renoteId: map['renoteId'],
      repliesCount: map['repliesCount'],
      replyId: map['replyId'],
      reply: map['reply'] != null ? NoteModel.fromMap(map['reply']) : null,
      text: map['text'],
      uri: map['uri'],
      user: UserLiteModel.fromMap(Map<String, dynamic>.from(map['user'])),
      userId: map['userId'],
      visibility: NoteVisibility.fromString(
        map['visibility'],
      ),
      poll: map["poll"] != null ? NotePollModel.fromMap(map["poll"]) : null,
    );
  }

  NoteModel copyWith(
      {String? id,
      int? clippedCount,
      DateTime? createdAt,
      String? cw,
      Map? emojis,
      List<DriveFileModel>? files,
      bool? localOnly,
      NoteReactionAcceptance? reactionAcceptance,
      Map? reactionEmojis,
      Map<String, int>? reactions,
      NoteModel? renote,
      int? renoteCount,
      String? renoteId,
      int? repliesCount,
      NoteModel? reply,
      String? replyId,
      String? text,
      String? uri,
      UserLiteModel? user,
      String? userId,
      NoteVisibility? visibility,
      NotePollModel? poll,
      NoteTranslate? noteTranslate}) {
    return NoteModel(
      id: id ?? this.id,
      clippedCount: clippedCount ?? this.clippedCount,
      createdAt: createdAt ?? this.createdAt,
      cw: cw ?? this.cw,
      emojis: emojis ?? this.emojis,
      files: files ??
          this
              .files
              .map((element) => element.copyWith(hero: UniqueKey()))
              .toList(),
      localOnly: localOnly ?? this.localOnly,
      reactionAcceptance: reactionAcceptance ?? this.reactionAcceptance,
      reactionEmojis: reactionEmojis ?? this.reactionEmojis,
      reactions: reactions ?? this.reactions,
      renote: renote ?? this.renote,
      renoteCount: renoteCount ?? this.renoteCount,
      renoteId: renoteId ?? this.renoteId,
      repliesCount: repliesCount ?? this.repliesCount,
      reply: reply ?? this.reply,
      replyId: replyId ?? this.replyId,
      text: text ?? this.text,
      uri: uri ?? this.uri,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      visibility: visibility ?? this.visibility,
      poll: poll ?? this.poll,
      noteTranslate: noteTranslate ?? this.noteTranslate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clippedCount': clippedCount,
      'createdAt': createdAt.toIso8601String(),
      'cw': cw,
      'emojis': emojis,
      'files': files.map((file) => file.toMap()).toList(),
      'localOnly': localOnly,
      'reactionAcceptance': reactionAcceptance?.value,
      'reactionEmojis': reactionEmojis,
      'reactions': reactions,
      'myReaction': myReaction,
      'renote': renote?.toMap(),
      'renoteCount': renoteCount,
      'renoteId': renoteId,
      'repliesCount': repliesCount,
      'reply': reply?.toMap(),
      'replyId': replyId,
      'text': text,
      'uri': uri,
      'user': user.toMap(),
      'userId': userId,
      'visibility': visibility.toString(), // Convert enum to string
      'poll': poll?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String str) => NoteModel.fromMap(json.decode(str));

  static create() {
    return NoteModel(
      id: "1",
      clippedCount: 0,
      createdAt: DateTime.now(),
      emojis: {},
      files: [],
      localOnly: false,
      reactionEmojis: {},
      reactions: {},
      renoteCount: 0,
      repliesCount: 0,
      user: UserLiteModel(
          avatarDecorations: [],
          emojis: {},
          id: "id",
          name: "数据加载失败",
          onlineStatus: OnlineStatus.ACTIVE,
          username: "username",
          avatarBlurhash: null,
          avatarUrl: null,
          host: ''),
      userId: "userId",
      visibility: NoteVisibility.home,
    );
  }
}

class NotePollModelChoices {
//JsonName:votes
  int votes;

//JsonName:text
  String text;

//JsonName:isVoted
  bool isVoted;

  NotePollModelChoices({
    required this.votes,
    required this.text,
    required this.isVoted,
  });

  NotePollModelChoices copyWith({
    bool? isVoted,
    String? text,
    int? votes,
  }) =>
      NotePollModelChoices(
        isVoted: isVoted ?? this.isVoted,
        text: text ?? this.text,
        votes: votes ?? this.votes,
      );

  factory NotePollModelChoices.fromJson(String str) =>
      NotePollModelChoices.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotePollModelChoices.fromMap(Map<String, dynamic> json) =>
      NotePollModelChoices(
        isVoted: json["isVoted"],
        text: json["text"],
        votes: json["votes"]?.toInt(),
      );

  Map<String, dynamic> toMap() => {
        "isVoted": isVoted,
        "text": text,
        "votes": votes,
      };
}

class NotePollModel {
  bool multiple;

  List<NotePollModelChoices> choices;

  DateTime? expiresAt;

  NotePollModel({
    required this.multiple,
    required this.choices,
    this.expiresAt,
  });

  NotePollModel copyWith({
    List<NotePollModelChoices>? choices,
    DateTime? expiresAt,
    bool? multiple,
  }) =>
      NotePollModel(
        choices: choices ?? this.choices,
        expiresAt: expiresAt ?? this.expiresAt,
        multiple: multiple ?? this.multiple,
      );

  factory NotePollModel.fromJson(String str) =>
      NotePollModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotePollModel.fromMap(Map<String, dynamic> json) => NotePollModel(
        choices: List<NotePollModelChoices>.from(
            json["choices"]?.map((x) => NotePollModelChoices.fromMap(x))),
        expiresAt: json["expiresAt"] == null
            ? null
            : DateTime.parse(json["expiresAt"]),
        multiple: json["multiple"],
      );

  Map<String, dynamic> toMap() => {
        "choices": List<dynamic>.from(choices.map((x) => x.toMap())),
        "expiresAt": expiresAt?.toIso8601String(),
        "multiple": multiple,
      };
}

/// Note表情回复限制
enum NoteReactionAcceptance {
  /// 远程仅点赞
  likeOnlyForRemote("likeOnlyForRemote"),

  /// 仅限非敏感内容
  nonSensitiveOnly("nonSensitiveOnly"),

  /// 仅限非敏感内容远程仅点赞
  nonSensitiveOnlyForLocalLikeOnlyForRemote(
      "nonSensitiveOnlyForLocalLikeOnlyForRemote"),

  /// 仅点赞
  likeOnly("likeOnly");

  const NoteReactionAcceptance(this.value);

  final String value;

  static NoteReactionAcceptance? fromString(String? name) {
    switch (name) {
      case "likeOnlyForRemote":
        return likeOnlyForRemote;
      case "nonSensitiveOnly":
        return nonSensitiveOnly;
      case "nonSensitiveOnlyForLocalLikeOnlyForRemote":
        return nonSensitiveOnlyForLocalLikeOnlyForRemote;
      case "likeOnly":
        return likeOnly;
    }
    return null;
  }
}

/// Note可见性
enum NoteVisibility {
  /// 公开
  public("public"),

  /// 本地
  home("home"),

  /// 关注
  followers("followers"),

  /// 用户指定
  specified("specified");

  const NoteVisibility(this.value);

  final String value;

  static NoteVisibility fromString(String name) {
    switch (name) {
      case "public":
        return public;
      case "home":
        return home;
      case "followers":
        return followers;
      case "specified":
        return specified;
    }
    return public;
  }

  static IconData? getIcon(NoteVisibility noteVisibility) {
    switch (noteVisibility) {
      case NoteVisibility.public:
        return null;
      case NoteVisibility.home:
        return TablerIcons.home;
      case NoteVisibility.followers:
        return TablerIcons.lock;
      case NoteVisibility.specified:
        return TablerIcons.mail;
    }
  }
}

/// 链接预览
class LinkPreview {
  final String? description;
  final String? icon;
  final bool? sensitive;
  final String? sitename;
  final String? thumbnail;
  final String? title;
  final String? url;

  LinkPreview({
    this.description,
    this.icon,
    this.sensitive,
    this.sitename,
    this.thumbnail,
    this.title,
    this.url,
  });

  LinkPreview copyWith({
    String? description,
    String? icon,
    bool? sensitive,
    String? sitename,
    String? thumbnail,
    String? title,
    String? url,
  }) =>
      LinkPreview(
        description: description ?? this.description,
        icon: icon ?? this.icon,
        sensitive: sensitive ?? this.sensitive,
        sitename: sitename ?? this.sitename,
        thumbnail: thumbnail ?? this.thumbnail,
        title: title ?? this.title,
        url: url ?? this.url,
      );

  factory LinkPreview.fromJson(String str) =>
      LinkPreview.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LinkPreview.fromMap(Map<String, dynamic> json) => LinkPreview(
        description: json["description"],
        icon: json["icon"],
        sensitive: json["sensitive"],
        sitename: json["sitename"],
        thumbnail: json["thumbnail"],
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "icon": icon,
        "sensitive": sensitive,
        "sitename": sitename,
        "thumbnail": thumbnail,
        "title": title,
        "url": url,
      };
}
