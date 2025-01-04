import 'package:flutter/cupertino.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moekey/apis/models/translate.dart';
import 'package:moekey/apis/models/user_lite.dart';

import 'drive.dart';

part 'note.freezed.dart';

part 'note.g.dart';

class MkLoadMoreListModel<T> {
  List<T> list = [];
  bool hasMore = true;
}

class NoteListModel extends MkLoadMoreListModel<NoteModel> {}

@unfreezed
class NoteModel with _$NoteModel {
  factory NoteModel({
    required String id,
    @Default(0) int clippedCount,
    required DateTime createdAt,
    String? cw,
    Map? emojis,
    required List<DriveFileModel> files,
    required bool localOnly,
    NoteReactionAcceptance? reactionAcceptance,
    required Map reactionEmojis,
    required Map<String, int> reactions,
    String? myReaction,
    NoteModel? renote,
    @Default(0) int renoteCount,
    String? renoteId,
    @Default(0) int repliesCount,
    NoteModel? reply,
    String? replyId,
    String? text,
    String? uri,
    required UserLiteModel user,
    required String userId,
    required NoteVisibility visibility,
    NotePollModel? poll,
    NoteTranslate? noteTranslate,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}

extension NoteModelExtension on NoteModel {
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
}

@freezed
class NotePollModelChoices with _$NotePollModelChoices {
  const factory NotePollModelChoices({
    required int votes,
    required String text,
    required bool isVoted,
  }) = _NotePollModelChoices;

  factory NotePollModelChoices.fromJson(Map<String, dynamic> json) =>
      _$NotePollModelChoicesFromJson(json);
}

@freezed
class NotePollModel with _$NotePollModel {
  const factory NotePollModel({
    required bool multiple,
    required List<NotePollModelChoices> choices,
    DateTime? expiresAt,
  }) = _NotePollModel;

  factory NotePollModel.fromJson(Map<String, dynamic> json) =>
      _$NotePollModelFromJson(json);
}

enum NoteReactionAcceptance {
  likeOnlyForRemote("likeOnlyForRemote"),
  nonSensitiveOnly("nonSensitiveOnly"),
  nonSensitiveOnlyForLocalLikeOnlyForRemote(
      "nonSensitiveOnlyForLocalLikeOnlyForRemote"),
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

enum NoteVisibility {
  @JsonValue("public")
  public("public"),
  @JsonValue("home")
  home("home"),
  @JsonValue("followers")
  followers("followers"),
  @JsonValue("specified")
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

@freezed
class LinkPreview with _$LinkPreview {
  const factory LinkPreview({
    String? description,
    String? icon,
    bool? sensitive,
    String? sitename,
    String? thumbnail,
    String? title,
    String? url,
  }) = _LinkPreview;

  factory LinkPreview.fromJson(Map<String, dynamic> json) =>
      _$LinkPreviewFromJson(json);
}
