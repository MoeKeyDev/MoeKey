import 'package:flutter/cupertino.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:moekey/models/translate.dart';
import 'package:moekey/models/user_simple.dart';

import 'drive.dart';

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
  Map reactions;
  String? myReaction;
  NoteModel? renote;
  int renoteCount;
  String? renoteId;
  int repliesCount;
  NoteModel? reply;
  String? replyId;
  String? text;
  String? uri;
  UserSimpleModel user;
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
    for (var item in map['files']) {
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
        reactions: map['reactions'],
        myReaction: map['myReaction'],
        renote: map['renote'] != null ? NoteModel.fromMap(map['renote']) : null,
        renoteCount: map['renoteCount'],
        renoteId: map['renoteId'],
        repliesCount: map['repliesCount'],
        replyId: map['replyId'],
        reply: map['reply'] != null ? NoteModel.fromMap(map['reply']) : null,
        text: map['text'],
        uri: map['uri'],
        user: UserSimpleModel.fromMap(map['user']),
        userId: map['userId'],
        visibility: NoteVisibility.fromString(
          map['visibility'],
        ),
        poll: map["poll"] != null ? NotePollModel.fromMap(map["poll"]) : null);
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
      Map? reactions,
      NoteModel? renote,
      int? renoteCount,
      String? renoteId,
      int? repliesCount,
      NoteModel? reply,
      String? replyId,
      String? text,
      String? uri,
      UserSimpleModel? user,
      String? userId,
      NoteVisibility? visibility,
      NotePollModel? poll}) {
    return NoteModel(
        id: id ?? this.id,
        clippedCount: clippedCount ?? this.clippedCount,
        createdAt: createdAt ?? this.createdAt,
        cw: cw ?? this.cw,
        emojis: emojis ?? this.emojis,
        files: files ?? this.files,
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
        poll: poll ?? this.poll);
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

  factory NotePollModelChoices.fromMap(dynamic map) {
    return NotePollModelChoices(
      votes: map['votes'],
      text: map['text'],
      isVoted: map['isVoted'],
    );
  }

  NotePollModelChoices copyWith({
    int? votes,
    String? text,
    bool? isVoted,
  }) {
    return NotePollModelChoices(
      votes: votes ?? this.votes,
      text: text ?? this.text,
      isVoted: isVoted ?? this.isVoted,
    );
  }
}

class NotePollModel {
//JsonName:multiple
  bool multiple;

//JsonName:choices
  List<NotePollModelChoices> choices;

//JsonName:expiresAt
  DateTime? expiresAt;

  NotePollModel({
    required this.multiple,
    required this.choices,
    this.expiresAt,
  });

  factory NotePollModel.fromMap(dynamic map) {
    List<NotePollModelChoices> choices = [];
    for (var item in map['choices']) {
      choices.add(NotePollModelChoices.fromMap(item));
    }
    return NotePollModel(
      multiple: map['multiple'],
      choices: choices,
      expiresAt:
          map["expiresAt"] != null ? DateTime.tryParse(map["expiresAt"]) : null,
    );
  }
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
