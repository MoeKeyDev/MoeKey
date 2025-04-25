import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moekey/apis/models/user_lite.dart';

import 'note.dart';

part 'notification.freezed.dart';

part 'notification.g.dart';

///Notification
@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required DateTime createdAt,
    required String id,
    NoteModel? note,
    required NotificationType type,
    UserLiteModel? user,
    String? userId,
    String? reaction,
    String? message,
    Role? role,
    Achievement? achievement,
    ExportedEntity? exportedEntity,
    String? fileId,
    String? body,
    String? header,
    String? icon,
    List<NoteReaction>? reactions,
    List<UserLiteModel>? users,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

enum Achievement {
  @JsonValue("brainDiver")
  BRAIN_DIVER,
  @JsonValue("bubbleGameDoubleExplodingHead")
  BUBBLE_GAME_DOUBLE_EXPLODING_HEAD,
  @JsonValue("bubbleGameExplodingHead")
  BUBBLE_GAME_EXPLODING_HEAD,
  @JsonValue("clickedClickHere")
  CLICKED_CLICK_HERE,
  @JsonValue("client30min")
  CLIENT30_MIN,
  @JsonValue("client60min")
  CLIENT60_MIN,
  @JsonValue("collectAchievements30")
  COLLECT_ACHIEVEMENTS30,
  @JsonValue("cookieClicked")
  COOKIE_CLICKED,
  @JsonValue("driveFolderCircularReference")
  DRIVE_FOLDER_CIRCULAR_REFERENCE,
  @JsonValue("followers1")
  FOLLOWERS1,
  @JsonValue("followers10")
  FOLLOWERS10,
  @JsonValue("followers100")
  FOLLOWERS100,
  @JsonValue("followers1000")
  FOLLOWERS1000,
  @JsonValue("followers300")
  FOLLOWERS300,
  @JsonValue("followers50")
  FOLLOWERS50,
  @JsonValue("followers500")
  FOLLOWERS500,
  @JsonValue("following1")
  FOLLOWING1,
  @JsonValue("following10")
  FOLLOWING10,
  @JsonValue("following100")
  FOLLOWING100,
  @JsonValue("following300")
  FOLLOWING300,
  @JsonValue("following50")
  FOLLOWING50,
  @JsonValue("foundTreasure")
  FOUND_TREASURE,
  @JsonValue("htl20npm")
  HTL20_NPM,
  @JsonValue("iLoveMisskey")
  I_LOVE_MISSKEY,
  @JsonValue("justPlainLucky")
  JUST_PLAIN_LUCKY,
  @JsonValue("loggedInOnBirthday")
  LOGGED_IN_ON_BIRTHDAY,
  @JsonValue("loggedInOnNewYearsDay")
  LOGGED_IN_ON_NEW_YEARS_DAY,
  @JsonValue("login100")
  LOGIN100,
  @JsonValue("login1000")
  LOGIN1000,
  @JsonValue("login15")
  LOGIN15,
  @JsonValue("login200")
  LOGIN200,
  @JsonValue("login3")
  LOGIN3,
  @JsonValue("login30")
  LOGIN30,
  @JsonValue("login300")
  LOGIN300,
  @JsonValue("login400")
  LOGIN400,
  @JsonValue("login500")
  LOGIN500,
  @JsonValue("login60")
  LOGIN60,
  @JsonValue("login600")
  LOGIN600,
  @JsonValue("login7")
  LOGIN7,
  @JsonValue("login700")
  LOGIN700,
  @JsonValue("login800")
  LOGIN800,
  @JsonValue("login900")
  LOGIN900,
  @JsonValue("markedAsCat")
  MARKED_AS_CAT,
  @JsonValue("myNoteFavorited1")
  MY_NOTE_FAVORITED1,
  @JsonValue("notes1")
  NOTES1,
  @JsonValue("notes10")
  NOTES10,
  @JsonValue("notes100")
  NOTES100,
  @JsonValue("notes1000")
  NOTES1000,
  @JsonValue("notes10000")
  NOTES10000,
  @JsonValue("notes100000")
  NOTES100000,
  @JsonValue("notes20000")
  NOTES20000,
  @JsonValue("notes30000")
  NOTES30000,
  @JsonValue("notes40000")
  NOTES40000,
  @JsonValue("notes500")
  NOTES500,
  @JsonValue("notes5000")
  NOTES5000,
  @JsonValue("notes50000")
  NOTES50000,
  @JsonValue("notes60000")
  NOTES60000,
  @JsonValue("notes70000")
  NOTES70000,
  @JsonValue("notes80000")
  NOTES80000,
  @JsonValue("notes90000")
  NOTES90000,
  @JsonValue("noteClipped1")
  NOTE_CLIPPED1,
  @JsonValue("noteDeletedWithin1min")
  NOTE_DELETED_WITHIN1_MIN,
  @JsonValue("noteFavorited1")
  NOTE_FAVORITED1,
  @JsonValue("open3windows")
  OPEN3_WINDOWS,
  @JsonValue("outputHelloWorldOnScratchpad")
  OUTPUT_HELLO_WORLD_ON_SCRATCHPAD,
  @JsonValue("passedSinceAccountCreated1")
  PASSED_SINCE_ACCOUNT_CREATED1,
  @JsonValue("passedSinceAccountCreated2")
  PASSED_SINCE_ACCOUNT_CREATED2,
  @JsonValue("passedSinceAccountCreated3")
  PASSED_SINCE_ACCOUNT_CREATED3,
  @JsonValue("postedAt0min0sec")
  POSTED_AT0_MIN0_SEC,
  @JsonValue("postedAtLateNight")
  POSTED_AT_LATE_NIGHT,
  @JsonValue("profileFilled")
  PROFILE_FILLED,
  @JsonValue("reactWithoutRead")
  REACT_WITHOUT_READ,
  @JsonValue("selfQuote")
  SELF_QUOTE,
  @JsonValue("setNameToSyuilo")
  SET_NAME_TO_SYUILO,
  @JsonValue("smashTestNotificationButton")
  SMASH_TEST_NOTIFICATION_BUTTON,
  @JsonValue("tutorialCompleted")
  TUTORIAL_COMPLETED,
  @JsonValue("viewAchievements3min")
  VIEW_ACHIEVEMENTS3_MIN,
  @JsonValue("viewInstanceChart")
  VIEW_INSTANCE_CHART
}

enum ExportedEntity {
  @JsonValue("antenna")
  ANTENNA,
  @JsonValue("blocking")
  BLOCKING,
  @JsonValue("clip")
  CLIP,
  @JsonValue("customEmoji")
  CUSTOM_EMOJI,
  @JsonValue("favorite")
  FAVORITE,
  @JsonValue("following")
  FOLLOWING,
  @JsonValue("muting")
  MUTING,
  @JsonValue("note")
  NOTE,
  @JsonValue("userList")
  USER_LIST
}

///Role
///
///RoleLite
@freezed
abstract class Role with _$Role {
  const factory Role({
    required String? color,
    required String description,
    required int displayOrder,
    required String? iconUrl,
    required String id,
    required bool isAdministrator,
    required bool isModerator,
    required String name,
    required bool asBadge,
    required bool canEditMembersByModerator,
    required RoleCondFormulaValue condFormula,
    required DateTime createdAt,
    required bool isExplorable,
    required bool isPublic,
    required Map<String, Policy> policies,
    required Target target,
    required DateTime updatedAt,
    required int usersCount,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

///RoleCondFormulaValue
///
///RoleCondFormulaLogics
///
///RoleCondFormulaValueNot
///
///RoleCondFormulaValueIsLocalOrRemote
///
///RoleCondFormulaValueUserSettingBooleanSchema
///
///RoleCondFormulaValueAssignedRole
///
///RoleCondFormulaValueCreated
///
///RoleCondFormulaFollowersOrFollowingOrNotes
@freezed
abstract class RoleCondFormulaValue with _$RoleCondFormulaValue {
  const factory RoleCondFormulaValue({
    required String id,
    required RoleCondFormulaValueType type,
    List<RoleCondFormulaValue>? values,
    dynamic value,
    String? roleId,
    double? sec,
  }) = _RoleCondFormulaValue;

  factory RoleCondFormulaValue.fromJson(Map<String, dynamic> json) =>
      _$RoleCondFormulaValueFromJson(json);
}

enum RoleCondFormulaValueType {
  @JsonValue("and")
  AND,
  @JsonValue("createdLessThan")
  CREATED_LESS_THAN,
  @JsonValue("createdMoreThan")
  CREATED_MORE_THAN,
  @JsonValue("followersLessThanOrEq")
  FOLLOWERS_LESS_THAN_OR_EQ,
  @JsonValue("followersMoreThanOrEq")
  FOLLOWERS_MORE_THAN_OR_EQ,
  @JsonValue("followingLessThanOrEq")
  FOLLOWING_LESS_THAN_OR_EQ,
  @JsonValue("followingMoreThanOrEq")
  FOLLOWING_MORE_THAN_OR_EQ,
  @JsonValue("isBot")
  IS_BOT,
  @JsonValue("isCat")
  IS_CAT,
  @JsonValue("isExplorable")
  IS_EXPLORABLE,
  @JsonValue("isLocal")
  IS_LOCAL,
  @JsonValue("isLocked")
  IS_LOCKED,
  @JsonValue("isRemote")
  IS_REMOTE,
  @JsonValue("isSuspended")
  IS_SUSPENDED,
  @JsonValue("not")
  NOT,
  @JsonValue("notesLessThanOrEq")
  NOTES_LESS_THAN_OR_EQ,
  @JsonValue("notesMoreThanOrEq")
  NOTES_MORE_THAN_OR_EQ,
  @JsonValue("or")
  OR,
  @JsonValue("roleAssignedTo")
  ROLE_ASSIGNED_TO
}

@freezed
abstract class Policy with _$Policy {
  const factory Policy({
    int? priority,
    bool? useDefault,
    dynamic value,
  }) = _Policy;

  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);
}

enum Target {
  @JsonValue("conditional")
  CONDITIONAL,
  @JsonValue("manual")
  MANUAL
}

enum NotificationType {
  @JsonValue("achievementEarned")
  ACHIEVEMENT_EARNED,
  @JsonValue("app")
  APP,
  @JsonValue("exportCompleted")
  EXPORT_COMPLETED,
  @JsonValue("follow")
  FOLLOW,
  @JsonValue("followRequestAccepted")
  FOLLOW_REQUEST_ACCEPTED,
  @JsonValue("login")
  LOGIN,
  @JsonValue("mention")
  MENTION,
  @JsonValue("note")
  NOTE,
  @JsonValue("pollEnded")
  POLL_ENDED,
  @JsonValue("quote")
  QUOTE,
  @JsonValue("reaction")
  REACTION,
  @JsonValue("reaction:grouped")
  REACTION_GROUPED,
  @JsonValue("receiveFollowRequest")
  RECEIVE_FOLLOW_REQUEST,
  @JsonValue("renote")
  RENOTE,
  @JsonValue("renote:grouped")
  RENOTE_GROUPED,
  @JsonValue("reply")
  REPLY,
  @JsonValue("roleAssigned")
  ROLE_ASSIGNED,
  @JsonValue("test")
  TEST
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
