import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'meta.freezed.dart';

part 'meta.g.dart';

///MetaDetailed
///
///MetaLite
///
///MetaDetailedOnly
@freezed
class MetaDetailedModel with _$MetaDetailedModel {
  const factory MetaDetailedModel({
    @Default([]) List<Ad> ads,
    required String? backgroundImageUrl,
    required String? bannerUrl,
    required String? defaultDarkTheme,
    required String? defaultLightTheme,
    required String? description,
    @Default(false) bool disableRegistration,
    @Default(false) bool emailRequiredForSignup,
    @Default(false) bool enableEmail,
    @Default(false) bool enableHcaptcha,
    @Default(false) bool enableMcaptcha,
    @Default(false) bool enableRecaptcha,
    @Default(false) bool enableServiceWorker,
    @Default(false) bool enableTestcaptcha,
    @Default(false) bool enableTurnstile,
    @Default(false) bool enableUrlPreview,
    required String? feedbackUrl,
    required String? hcaptchaSiteKey,
    required String? iconUrl,
    required String? impressumUrl,
    required String? infoImageUrl,
    required String? inquiryUrl,
    required List<String> langs,
    required String? logoImageUrl,
    required String? maintainerEmail,
    required String? maintainerName,
    required String mascotImageUrl,
    @Default(0) double maxFileSize,
    @Default(0) double maxNoteTextLength,
    required String? mcaptchaInstanceUrl,
    required String? mcaptchaSiteKey,
    required String mediaProxy,
    required String? name,
    NoteSearchableScope? noteSearchableScope,
    @Default(0) double notesPerOneAd,
    required String? notFoundImageUrl,
    required RolePolicies policies,
    required String? privacyPolicyUrl,
    @Default(false) bool providesTarball,
    required String? recaptchaSiteKey,
    required String? repositoryUrl,
    required String? serverErrorImageUrl,
    required List<String> serverRules,
    required String? shortName,
    required String? swPublickey,
    required String? themeColor,
    required String? tosUrl,
    @Default(false) bool translatorAvailable,
    required String? turnstileSiteKey,
    required String uri,
    required String version,
    @Default(false) bool cacheRemoteFiles,
    @Default(false) bool cacheRemoteSensitiveFiles,
    required Features features,
    required String? proxyAccountName,
    @Default(false) bool requireSetup,
  }) = _MetaDetailed;

  factory MetaDetailedModel.fromJson(Map<String, dynamic> json) =>
      _$MetaDetailedModelFromJson(json);
}

@freezed
class Ad with _$Ad {
  const factory Ad({
    required int dayOfWeek,
    required String id,
    required String imageUrl,
    required String place,
    required double ratio,
    required String url,
  }) = _Ad;

  factory Ad.fromJson(Map<String, dynamic> json) => _$AdFromJson(json);
}

@freezed
class Features with _$Features {
  const factory Features({
    required bool emailRequiredForSignup,
    required bool globalTimeline,
    required bool hcaptcha,
    required bool localTimeline,
    required bool miauth,
    required bool objectStorage,
    required bool recaptcha,
    required bool registration,
    required bool serviceWorker,
    required bool turnstile,
  }) = _Features;

  factory Features.fromJson(Map<String, dynamic> json) =>
      _$FeaturesFromJson(json);
}

enum NoteSearchableScope {
  @JsonValue("global")
  GLOBAL,
  @JsonValue("local")
  LOCAL,
}

///RolePolicies
@freezed
class RolePolicies with _$RolePolicies {
  const factory RolePolicies({
    required bool alwaysMarkNsfw,
    required int antennaLimit,
    required int avatarDecorationLimit,
    @Default(false) bool canEditNote,
    @Default(false) bool canHideAds,
    @Default(false) bool canImportAntennas,
    @Default(false) bool canImportBlocking,
    @Default(false) bool canImportFollowing,
    @Default(false) bool canImportMuting,
    @Default(false) bool canImportUserLists,
    @Default(false) bool canInvite,
    @Default(false) bool canManageAvatarDecorations,
    @Default(false) bool canManageCustomEmojis,
    @Default(false) bool canPublicNote,
    @Default(false) bool canSearchNotes,
    @Default(false) bool canUpdateBioMedia,
    @Default(false) bool canUseTranslator,
    required int clipLimit,
    required int driveCapacityMb,
    @Default(false) bool gtlAvailable,
    required int inviteExpirationTime,
    required int inviteLimit,
    required int inviteLimitCycle,
    @Default(false) bool ltlAvailable,
    required int mentionLimit,
    required int noteEachClipsLimit,
    required int pinLimit,
    required int rateLimitFactor,
    required int userEachUserListsLimit,
    required int userListLimit,
    required int webhookLimit,
    required int wordMuteLimit,
  }) = _RolePolicies;

  factory RolePolicies.fromJson(Map<String, dynamic> json) =>
      _$RolePoliciesFromJson(json);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
