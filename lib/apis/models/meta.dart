import 'dart:convert';

///MetaDetailed
///
///MetaLite
///
///MetaDetailedOnly
class MetaDetailedModel {
  final List<Ad> ads;
  final String? backgroundImageUrl;
  final String? bannerUrl;
  final String? defaultDarkTheme;
  final String? defaultLightTheme;
  final String? description;
  final bool? disableRegistration;
  final bool? emailRequiredForSignup;
  final bool? enableEmail;
  final bool? enableHcaptcha;
  final bool? enableMcaptcha;
  final bool? enableRecaptcha;
  final bool? enableServiceWorker;
  final bool? enableSkebStatus;
  final bool? enableTurnstile;
  final bool? enableUrlPreview;
  final String? feedbackUrl;
  final String? hcaptchaSiteKey;
  final String? iconUrl;
  final String? impressumUrl;
  final String? infoImageUrl;
  final List<String> langs;
  final String? logoImageUrl;
  final String? maintainerEmail;
  final String? maintainerName;
  final String mascotImageUrl;
  final int maxNoteTextLength;
  final String? mcaptchaInstanceUrl;
  final String? mcaptchaSiteKey;
  final String mediaProxy;
  final String? name;
  final double notesPerOneAd;
  final String? notFoundImageUrl;
  final RolePolicies policies;
  final String? privacyPolicyUrl;
  final String? recaptchaSiteKey;
  final String? repositoryUrl;
  final String? serverErrorImageUrl;
  final List<String> serverRules;
  final String? shortName;
  final String? swPublickey;
  final String? themeColor;
  final String? tosUrl;
  final bool translatorAvailable;
  final String? turnstileSiteKey;
  final String uri;
  final String version;
  final List<String> wellKnownWebsites;
  final bool cacheRemoteFiles;
  final bool cacheRemoteSensitiveFiles;
  final Features? features;
  final String? proxyAccountName;
  final bool requireSetup;

  MetaDetailedModel({
    required this.ads,
    required this.backgroundImageUrl,
    required this.bannerUrl,
    required this.defaultDarkTheme,
    required this.defaultLightTheme,
    required this.description,
    required this.disableRegistration,
    required this.emailRequiredForSignup,
    required this.enableEmail,
    required this.enableHcaptcha,
    required this.enableMcaptcha,
    required this.enableRecaptcha,
    required this.enableServiceWorker,
    required this.enableSkebStatus,
    required this.enableTurnstile,
    required this.enableUrlPreview,
    required this.feedbackUrl,
    required this.hcaptchaSiteKey,
    required this.iconUrl,
    required this.impressumUrl,
    required this.infoImageUrl,
    required this.langs,
    required this.logoImageUrl,
    required this.maintainerEmail,
    required this.maintainerName,
    required this.mascotImageUrl,
    required this.maxNoteTextLength,
    required this.mcaptchaInstanceUrl,
    required this.mcaptchaSiteKey,
    required this.mediaProxy,
    required this.name,
    required this.notesPerOneAd,
    required this.notFoundImageUrl,
    required this.policies,
    required this.privacyPolicyUrl,
    required this.recaptchaSiteKey,
    required this.repositoryUrl,
    required this.serverErrorImageUrl,
    required this.serverRules,
    required this.shortName,
    required this.swPublickey,
    required this.themeColor,
    required this.tosUrl,
    required this.translatorAvailable,
    required this.turnstileSiteKey,
    required this.uri,
    required this.version,
    required this.wellKnownWebsites,
    required this.cacheRemoteFiles,
    required this.cacheRemoteSensitiveFiles,
    this.features,
    required this.proxyAccountName,
    required this.requireSetup,
  });

  MetaDetailedModel copyWith({
    List<Ad>? ads,
    String? backgroundImageUrl,
    String? bannerUrl,
    String? defaultDarkTheme,
    String? defaultLightTheme,
    String? description,
    bool? disableRegistration,
    bool? emailRequiredForSignup,
    bool? enableEmail,
    bool? enableHcaptcha,
    bool? enableMcaptcha,
    bool? enableRecaptcha,
    bool? enableServiceWorker,
    bool? enableSkebStatus,
    bool? enableTurnstile,
    bool? enableUrlPreview,
    String? feedbackUrl,
    String? hcaptchaSiteKey,
    String? iconUrl,
    String? impressumUrl,
    String? infoImageUrl,
    List<String>? langs,
    String? logoImageUrl,
    String? maintainerEmail,
    String? maintainerName,
    String? mascotImageUrl,
    int? maxNoteTextLength,
    String? mcaptchaInstanceUrl,
    String? mcaptchaSiteKey,
    String? mediaProxy,
    String? name,
    double? notesPerOneAd,
    String? notFoundImageUrl,
    RolePolicies? policies,
    String? privacyPolicyUrl,
    String? recaptchaSiteKey,
    String? repositoryUrl,
    String? serverErrorImageUrl,
    List<String>? serverRules,
    String? shortName,
    String? swPublickey,
    String? themeColor,
    String? tosUrl,
    bool? translatorAvailable,
    String? turnstileSiteKey,
    String? uri,
    String? version,
    List<String>? wellKnownWebsites,
    bool? cacheRemoteFiles,
    bool? cacheRemoteSensitiveFiles,
    Features? features,
    String? proxyAccountName,
    bool? requireSetup,
  }) =>
      MetaDetailedModel(
        ads: ads ?? this.ads,
        backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
        bannerUrl: bannerUrl ?? this.bannerUrl,
        defaultDarkTheme: defaultDarkTheme ?? this.defaultDarkTheme,
        defaultLightTheme: defaultLightTheme ?? this.defaultLightTheme,
        description: description ?? this.description,
        disableRegistration: disableRegistration ?? this.disableRegistration,
        emailRequiredForSignup:
            emailRequiredForSignup ?? this.emailRequiredForSignup,
        enableEmail: enableEmail ?? this.enableEmail,
        enableHcaptcha: enableHcaptcha ?? this.enableHcaptcha,
        enableMcaptcha: enableMcaptcha ?? this.enableMcaptcha,
        enableRecaptcha: enableRecaptcha ?? this.enableRecaptcha,
        enableServiceWorker: enableServiceWorker ?? this.enableServiceWorker,
        enableSkebStatus: enableSkebStatus ?? this.enableSkebStatus,
        enableTurnstile: enableTurnstile ?? this.enableTurnstile,
        enableUrlPreview: enableUrlPreview ?? this.enableUrlPreview,
        feedbackUrl: feedbackUrl ?? this.feedbackUrl,
        hcaptchaSiteKey: hcaptchaSiteKey ?? this.hcaptchaSiteKey,
        iconUrl: iconUrl ?? this.iconUrl,
        impressumUrl: impressumUrl ?? this.impressumUrl,
        infoImageUrl: infoImageUrl ?? this.infoImageUrl,
        langs: langs ?? this.langs,
        logoImageUrl: logoImageUrl ?? this.logoImageUrl,
        maintainerEmail: maintainerEmail ?? this.maintainerEmail,
        maintainerName: maintainerName ?? this.maintainerName,
        mascotImageUrl: mascotImageUrl ?? this.mascotImageUrl,
        maxNoteTextLength: maxNoteTextLength ?? this.maxNoteTextLength,
        mcaptchaInstanceUrl: mcaptchaInstanceUrl ?? this.mcaptchaInstanceUrl,
        mcaptchaSiteKey: mcaptchaSiteKey ?? this.mcaptchaSiteKey,
        mediaProxy: mediaProxy ?? this.mediaProxy,
        name: name ?? this.name,
        notesPerOneAd: notesPerOneAd ?? this.notesPerOneAd,
        notFoundImageUrl: notFoundImageUrl ?? this.notFoundImageUrl,
        policies: policies ?? this.policies,
        privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
        recaptchaSiteKey: recaptchaSiteKey ?? this.recaptchaSiteKey,
        repositoryUrl: repositoryUrl ?? this.repositoryUrl,
        serverErrorImageUrl: serverErrorImageUrl ?? this.serverErrorImageUrl,
        serverRules: serverRules ?? this.serverRules,
        shortName: shortName ?? this.shortName,
        swPublickey: swPublickey ?? this.swPublickey,
        themeColor: themeColor ?? this.themeColor,
        tosUrl: tosUrl ?? this.tosUrl,
        translatorAvailable: translatorAvailable ?? this.translatorAvailable,
        turnstileSiteKey: turnstileSiteKey ?? this.turnstileSiteKey,
        uri: uri ?? this.uri,
        version: version ?? this.version,
        wellKnownWebsites: wellKnownWebsites ?? this.wellKnownWebsites,
        cacheRemoteFiles: cacheRemoteFiles ?? this.cacheRemoteFiles,
        cacheRemoteSensitiveFiles:
            cacheRemoteSensitiveFiles ?? this.cacheRemoteSensitiveFiles,
        features: features ?? this.features,
        proxyAccountName: proxyAccountName ?? this.proxyAccountName,
        requireSetup: requireSetup ?? this.requireSetup,
      );

  factory MetaDetailedModel.fromJson(String str) =>
      MetaDetailedModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MetaDetailedModel.fromMap(Map<String, dynamic> json) =>
      MetaDetailedModel(
        ads: List<Ad>.from((json["ads"] ?? []).map((x) => Ad.fromMap(x))),
        backgroundImageUrl: json["backgroundImageUrl"],
        bannerUrl: json["bannerUrl"],
        defaultDarkTheme: json["defaultDarkTheme"],
        defaultLightTheme: json["defaultLightTheme"],
        description: json["description"],
        disableRegistration: json["disableRegistration"],
        emailRequiredForSignup: json["emailRequiredForSignup"],
        enableEmail: json["enableEmail"],
        enableHcaptcha: json["enableHcaptcha"],
        enableMcaptcha: json["enableMcaptcha"],
        enableRecaptcha: json["enableRecaptcha"],
        enableServiceWorker: json["enableServiceWorker"],
        enableSkebStatus: json["enableSkebStatus"] ?? false,
        enableTurnstile: json["enableTurnstile"],
        enableUrlPreview: json["enableUrlPreview"],
        feedbackUrl: json["feedbackUrl"],
        hcaptchaSiteKey: json["hcaptchaSiteKey"],
        iconUrl: json["iconUrl"],
        impressumUrl: json["impressumUrl"],
        infoImageUrl: json["infoImageUrl"],
        langs: List<String>.from((json["langs"] ?? []).map((x) => x)),
        logoImageUrl: json["logoImageUrl"],
        maintainerEmail: json["maintainerEmail"],
        maintainerName: json["maintainerName"],
        mascotImageUrl: json["mascotImageUrl"],
        maxNoteTextLength: json["maxNoteTextLength"]?.toInt(),
        mcaptchaInstanceUrl: json["mcaptchaInstanceUrl"],
        mcaptchaSiteKey: json["mcaptchaSiteKey"],
        mediaProxy: json["mediaProxy"],
        name: json["name"],
        notesPerOneAd: json["notesPerOneAd"]?.toDouble(),
        notFoundImageUrl: json["notFoundImageUrl"],
        policies: RolePolicies.fromMap(json["policies"]),
        privacyPolicyUrl: json["privacyPolicyUrl"],
        recaptchaSiteKey: json["recaptchaSiteKey"],
        repositoryUrl: json["repositoryUrl"],
        serverErrorImageUrl: json["serverErrorImageUrl"],
        serverRules:
            List<String>.from((json["serverRules"] ?? []).map((x) => x)),
        shortName: json["shortName"],
        swPublickey: json["swPublickey"],
        themeColor: json["themeColor"],
        tosUrl: json["tosUrl"],
        translatorAvailable: json["translatorAvailable"],
        turnstileSiteKey: json["turnstileSiteKey"],
        uri: json["uri"],
        version: json["version"],
        wellKnownWebsites:
            List<String>.from((json["wellKnownWebsites"] ?? []).map((x) => x)),
        cacheRemoteFiles: json["cacheRemoteFiles"],
        cacheRemoteSensitiveFiles: json["cacheRemoteSensitiveFiles"],
        features: json["features"] == null
            ? null
            : Features.fromMap(json["features"]),
        proxyAccountName: json["proxyAccountName"],
        requireSetup: json["requireSetup"],
      );

  Map<String, dynamic> toMap() => {
        "ads": List<dynamic>.from(ads.map((x) => x.toMap())),
        "backgroundImageUrl": backgroundImageUrl,
        "bannerUrl": bannerUrl,
        "defaultDarkTheme": defaultDarkTheme,
        "defaultLightTheme": defaultLightTheme,
        "description": description,
        "disableRegistration": disableRegistration,
        "emailRequiredForSignup": emailRequiredForSignup,
        "enableEmail": enableEmail,
        "enableHcaptcha": enableHcaptcha,
        "enableMcaptcha": enableMcaptcha,
        "enableRecaptcha": enableRecaptcha,
        "enableServiceWorker": enableServiceWorker,
        "enableSkebStatus": enableSkebStatus,
        "enableTurnstile": enableTurnstile,
        "enableUrlPreview": enableUrlPreview,
        "feedbackUrl": feedbackUrl,
        "hcaptchaSiteKey": hcaptchaSiteKey,
        "iconUrl": iconUrl,
        "impressumUrl": impressumUrl,
        "infoImageUrl": infoImageUrl,
        "langs": List<dynamic>.from(langs.map((x) => x)),
        "logoImageUrl": logoImageUrl,
        "maintainerEmail": maintainerEmail,
        "maintainerName": maintainerName,
        "mascotImageUrl": mascotImageUrl,
        "maxNoteTextLength": maxNoteTextLength,
        "mcaptchaInstanceUrl": mcaptchaInstanceUrl,
        "mcaptchaSiteKey": mcaptchaSiteKey,
        "mediaProxy": mediaProxy,
        "name": name,
        "notesPerOneAd": notesPerOneAd,
        "notFoundImageUrl": notFoundImageUrl,
        "policies": policies.toMap(),
        "privacyPolicyUrl": privacyPolicyUrl,
        "recaptchaSiteKey": recaptchaSiteKey,
        "repositoryUrl": repositoryUrl,
        "serverErrorImageUrl": serverErrorImageUrl,
        "serverRules": List<dynamic>.from(serverRules.map((x) => x)),
        "shortName": shortName,
        "swPublickey": swPublickey,
        "themeColor": themeColor,
        "tosUrl": tosUrl,
        "translatorAvailable": translatorAvailable,
        "turnstileSiteKey": turnstileSiteKey,
        "uri": uri,
        "version": version,
        "wellKnownWebsites":
            List<dynamic>.from(wellKnownWebsites.map((x) => x)),
        "cacheRemoteFiles": cacheRemoteFiles,
        "cacheRemoteSensitiveFiles": cacheRemoteSensitiveFiles,
        "features": features?.toMap(),
        "proxyAccountName": proxyAccountName,
        "requireSetup": requireSetup,
      };
}

class Ad {
  final int dayOfWeek;
  final String id;
  final String imageUrl;
  final Place place;
  final double ratio;
  final String url;

  Ad({
    required this.dayOfWeek,
    required this.id,
    required this.imageUrl,
    required this.place,
    required this.ratio,
    required this.url,
  });

  Ad copyWith({
    int? dayOfWeek,
    String? id,
    String? imageUrl,
    Place? place,
    double? ratio,
    String? url,
  }) =>
      Ad(
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        place: place ?? this.place,
        ratio: ratio ?? this.ratio,
        url: url ?? this.url,
      );

  factory Ad.fromJson(String str) => Ad.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ad.fromMap(Map<String, dynamic> json) => Ad(
        dayOfWeek: json["dayOfWeek"],
        id: json["id"],
        imageUrl: json["imageUrl"],
        place: placeValues.map[json["place"]]!,
        ratio: json["ratio"]?.toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "dayOfWeek": dayOfWeek,
        "id": id,
        "imageUrl": imageUrl,
        "place": placeValues.reverse[place],
        "ratio": ratio,
        "url": url,
      };
}

enum Place { HORIZONTAL, HORIZONTAL_BIG, SQUARE, VERTICAL }

final placeValues = EnumValues({
  "horizontal": Place.HORIZONTAL,
  "horizontal-big": Place.HORIZONTAL_BIG,
  "square": Place.SQUARE,
  "vertical": Place.VERTICAL
});

class Features {
  final bool? emailRequiredForSignup;
  final bool? globalTimeline;
  final bool? hCaptcha;

  ///Alias of hCaptcha
  final bool? hcaptcha;
  final bool? localTimeline;
  final bool? mCaptcha;

  ///Alias of mCaptcha
  final bool? mcaptcha;
  final bool? miauth;
  final bool? objectStorage;
  final bool? reCaptcha;

  ///Alias of reCaptcha
  final bool? recaptcha;
  final bool? registration;
  final bool? serviceWorker;
  final bool? turnstile;

  Features({
    required this.emailRequiredForSignup,
    required this.globalTimeline,
    required this.hCaptcha,
    required this.hcaptcha,
    required this.localTimeline,
    required this.mCaptcha,
    required this.mcaptcha,
    this.miauth,
    required this.objectStorage,
    required this.reCaptcha,
    required this.recaptcha,
    required this.registration,
    required this.serviceWorker,
    required this.turnstile,
  });

  Features copyWith({
    bool? emailRequiredForSignup,
    bool? globalTimeline,
    bool? hCaptcha,
    bool? hcaptcha,
    bool? localTimeline,
    bool? mCaptcha,
    bool? mcaptcha,
    bool? miauth,
    bool? objectStorage,
    bool? reCaptcha,
    bool? recaptcha,
    bool? registration,
    bool? serviceWorker,
    bool? turnstile,
  }) =>
      Features(
        emailRequiredForSignup:
            emailRequiredForSignup ?? this.emailRequiredForSignup,
        globalTimeline: globalTimeline ?? this.globalTimeline,
        hCaptcha: hCaptcha ?? this.hCaptcha,
        hcaptcha: hcaptcha ?? this.hcaptcha,
        localTimeline: localTimeline ?? this.localTimeline,
        mCaptcha: mCaptcha ?? this.mCaptcha,
        mcaptcha: mcaptcha ?? this.mcaptcha,
        miauth: miauth ?? this.miauth,
        objectStorage: objectStorage ?? this.objectStorage,
        reCaptcha: reCaptcha ?? this.reCaptcha,
        recaptcha: recaptcha ?? this.recaptcha,
        registration: registration ?? this.registration,
        serviceWorker: serviceWorker ?? this.serviceWorker,
        turnstile: turnstile ?? this.turnstile,
      );

  factory Features.fromJson(String str) => Features.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Features.fromMap(Map<String, dynamic> json) => Features(
        emailRequiredForSignup: json["emailRequiredForSignup"],
        globalTimeline: json["globalTimeline"],
        hCaptcha: json["hCaptcha"],
        hcaptcha: json["hcaptcha"],
        localTimeline: json["localTimeline"],
        mCaptcha: json["mCaptcha"],
        mcaptcha: json["mcaptcha"],
        miauth: json["miauth"],
        objectStorage: json["objectStorage"],
        reCaptcha: json["reCaptcha"],
        recaptcha: json["recaptcha"],
        registration: json["registration"],
        serviceWorker: json["serviceWorker"],
        turnstile: json["turnstile"],
      );

  Map<String, dynamic> toMap() => {
        "emailRequiredForSignup": emailRequiredForSignup,
        "globalTimeline": globalTimeline,
        "hCaptcha": hCaptcha,
        "hcaptcha": hcaptcha,
        "localTimeline": localTimeline,
        "mCaptcha": mCaptcha,
        "mcaptcha": mcaptcha,
        "miauth": miauth,
        "objectStorage": objectStorage,
        "reCaptcha": reCaptcha,
        "recaptcha": recaptcha,
        "registration": registration,
        "serviceWorker": serviceWorker,
        "turnstile": turnstile,
      };
}

///RolePolicies
class RolePolicies {
  final bool? alwaysMarkNsfw;
  final int? antennaLimit;
  final int? antennaNotesLimit;
  final int? avatarDecorationLimit;
  final bool? canCreateContent;
  final bool? canDeleteContent;
  final bool? canHideAds;
  final bool? canInitiateConversation;
  final bool? canInvite;
  final bool? canManageAvatarDecorations;
  final bool? canManageCustomEmojis;
  final bool? canPublicNote;
  final bool? canPurgeAccount;
  final bool? canSearchNotes;
  final bool? canUpdateAvatar;
  final bool? canUpdateBanner;
  final bool? canUpdateContent;
  final bool? canUseDriveFileInSoundSettings;
  final bool? canUseTranslator;
  final int? clipLimit;
  final int? driveCapacityMb;
  final bool? gtlAvailable;
  final int? inviteExpirationTime;
  final int? inviteLimit;
  final int? inviteLimitCycle;
  final bool? ltlAvailable;
  final int? mentionLimit;
  final int? noteEachClipsLimit;
  final int? pinLimit;
  final int? rateLimitFactor;
  final bool? skipNsfwDetection;
  final int? userEachUserListsLimit;
  final int? userListLimit;
  final int? webhookLimit;
  final int? wordMuteLimit;

  RolePolicies({
    required this.alwaysMarkNsfw,
    required this.antennaLimit,
    required this.antennaNotesLimit,
    required this.avatarDecorationLimit,
    required this.canCreateContent,
    required this.canDeleteContent,
    required this.canHideAds,
    required this.canInitiateConversation,
    required this.canInvite,
    required this.canManageAvatarDecorations,
    required this.canManageCustomEmojis,
    required this.canPublicNote,
    required this.canPurgeAccount,
    required this.canSearchNotes,
    required this.canUpdateAvatar,
    required this.canUpdateBanner,
    required this.canUpdateContent,
    required this.canUseDriveFileInSoundSettings,
    required this.canUseTranslator,
    required this.clipLimit,
    required this.driveCapacityMb,
    required this.gtlAvailable,
    required this.inviteExpirationTime,
    required this.inviteLimit,
    required this.inviteLimitCycle,
    required this.ltlAvailable,
    required this.mentionLimit,
    required this.noteEachClipsLimit,
    required this.pinLimit,
    required this.rateLimitFactor,
    required this.skipNsfwDetection,
    required this.userEachUserListsLimit,
    required this.userListLimit,
    required this.webhookLimit,
    required this.wordMuteLimit,
  });

  RolePolicies copyWith({
    bool? alwaysMarkNsfw,
    int? antennaLimit,
    int? antennaNotesLimit,
    int? avatarDecorationLimit,
    bool? canCreateContent,
    bool? canDeleteContent,
    bool? canHideAds,
    bool? canInitiateConversation,
    bool? canInvite,
    bool? canManageAvatarDecorations,
    bool? canManageCustomEmojis,
    bool? canPublicNote,
    bool? canPurgeAccount,
    bool? canSearchNotes,
    bool? canUpdateAvatar,
    bool? canUpdateBanner,
    bool? canUpdateContent,
    bool? canUseDriveFileInSoundSettings,
    bool? canUseTranslator,
    int? clipLimit,
    int? driveCapacityMb,
    bool? gtlAvailable,
    int? inviteExpirationTime,
    int? inviteLimit,
    int? inviteLimitCycle,
    bool? ltlAvailable,
    int? mentionLimit,
    int? noteEachClipsLimit,
    int? pinLimit,
    int? rateLimitFactor,
    bool? skipNsfwDetection,
    int? userEachUserListsLimit,
    int? userListLimit,
    int? webhookLimit,
    int? wordMuteLimit,
  }) =>
      RolePolicies(
        alwaysMarkNsfw: alwaysMarkNsfw ?? this.alwaysMarkNsfw,
        antennaLimit: antennaLimit ?? this.antennaLimit,
        antennaNotesLimit: antennaNotesLimit ?? this.antennaNotesLimit,
        avatarDecorationLimit:
            avatarDecorationLimit ?? this.avatarDecorationLimit,
        canCreateContent: canCreateContent ?? this.canCreateContent,
        canDeleteContent: canDeleteContent ?? this.canDeleteContent,
        canHideAds: canHideAds ?? this.canHideAds,
        canInitiateConversation:
            canInitiateConversation ?? this.canInitiateConversation,
        canInvite: canInvite ?? this.canInvite,
        canManageAvatarDecorations:
            canManageAvatarDecorations ?? this.canManageAvatarDecorations,
        canManageCustomEmojis:
            canManageCustomEmojis ?? this.canManageCustomEmojis,
        canPublicNote: canPublicNote ?? this.canPublicNote,
        canPurgeAccount: canPurgeAccount ?? this.canPurgeAccount,
        canSearchNotes: canSearchNotes ?? this.canSearchNotes,
        canUpdateAvatar: canUpdateAvatar ?? this.canUpdateAvatar,
        canUpdateBanner: canUpdateBanner ?? this.canUpdateBanner,
        canUpdateContent: canUpdateContent ?? this.canUpdateContent,
        canUseDriveFileInSoundSettings: canUseDriveFileInSoundSettings ??
            this.canUseDriveFileInSoundSettings,
        canUseTranslator: canUseTranslator ?? this.canUseTranslator,
        clipLimit: clipLimit ?? this.clipLimit,
        driveCapacityMb: driveCapacityMb ?? this.driveCapacityMb,
        gtlAvailable: gtlAvailable ?? this.gtlAvailable,
        inviteExpirationTime: inviteExpirationTime ?? this.inviteExpirationTime,
        inviteLimit: inviteLimit ?? this.inviteLimit,
        inviteLimitCycle: inviteLimitCycle ?? this.inviteLimitCycle,
        ltlAvailable: ltlAvailable ?? this.ltlAvailable,
        mentionLimit: mentionLimit ?? this.mentionLimit,
        noteEachClipsLimit: noteEachClipsLimit ?? this.noteEachClipsLimit,
        pinLimit: pinLimit ?? this.pinLimit,
        rateLimitFactor: rateLimitFactor ?? this.rateLimitFactor,
        skipNsfwDetection: skipNsfwDetection ?? this.skipNsfwDetection,
        userEachUserListsLimit:
            userEachUserListsLimit ?? this.userEachUserListsLimit,
        userListLimit: userListLimit ?? this.userListLimit,
        webhookLimit: webhookLimit ?? this.webhookLimit,
        wordMuteLimit: wordMuteLimit ?? this.wordMuteLimit,
      );

  factory RolePolicies.fromJson(String str) =>
      RolePolicies.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RolePolicies.fromMap(Map<String, dynamic> json) => RolePolicies(
        alwaysMarkNsfw: json["alwaysMarkNsfw"],
        antennaLimit: json["antennaLimit"],
        antennaNotesLimit: json["antennaNotesLimit"],
        avatarDecorationLimit: json["avatarDecorationLimit"],
        canCreateContent: json["canCreateContent"],
        canDeleteContent: json["canDeleteContent"],
        canHideAds: json["canHideAds"],
        canInitiateConversation: json["canInitiateConversation"],
        canInvite: json["canInvite"],
        canManageAvatarDecorations: json["canManageAvatarDecorations"],
        canManageCustomEmojis: json["canManageCustomEmojis"],
        canPublicNote: json["canPublicNote"],
        canPurgeAccount: json["canPurgeAccount"],
        canSearchNotes: json["canSearchNotes"],
        canUpdateAvatar: json["canUpdateAvatar"],
        canUpdateBanner: json["canUpdateBanner"],
        canUpdateContent: json["canUpdateContent"],
        canUseDriveFileInSoundSettings: json["canUseDriveFileInSoundSettings"],
        canUseTranslator: json["canUseTranslator"],
        clipLimit: json["clipLimit"],
        driveCapacityMb: json["driveCapacityMb"],
        gtlAvailable: json["gtlAvailable"],
        inviteExpirationTime: json["inviteExpirationTime"],
        inviteLimit: json["inviteLimit"],
        inviteLimitCycle: json["inviteLimitCycle"],
        ltlAvailable: json["ltlAvailable"],
        mentionLimit: json["mentionLimit"],
        noteEachClipsLimit: json["noteEachClipsLimit"],
        pinLimit: json["pinLimit"],
        rateLimitFactor: json["rateLimitFactor"],
        skipNsfwDetection: json["skipNsfwDetection"],
        userEachUserListsLimit: json["userEachUserListsLimit"],
        userListLimit: json["userListLimit"],
        webhookLimit: json["webhookLimit"],
        wordMuteLimit: json["wordMuteLimit"],
      );

  Map<String, dynamic> toMap() => {
        "alwaysMarkNsfw": alwaysMarkNsfw,
        "antennaLimit": antennaLimit,
        "antennaNotesLimit": antennaNotesLimit,
        "avatarDecorationLimit": avatarDecorationLimit,
        "canCreateContent": canCreateContent,
        "canDeleteContent": canDeleteContent,
        "canHideAds": canHideAds,
        "canInitiateConversation": canInitiateConversation,
        "canInvite": canInvite,
        "canManageAvatarDecorations": canManageAvatarDecorations,
        "canManageCustomEmojis": canManageCustomEmojis,
        "canPublicNote": canPublicNote,
        "canPurgeAccount": canPurgeAccount,
        "canSearchNotes": canSearchNotes,
        "canUpdateAvatar": canUpdateAvatar,
        "canUpdateBanner": canUpdateBanner,
        "canUpdateContent": canUpdateContent,
        "canUseDriveFileInSoundSettings": canUseDriveFileInSoundSettings,
        "canUseTranslator": canUseTranslator,
        "clipLimit": clipLimit,
        "driveCapacityMb": driveCapacityMb,
        "gtlAvailable": gtlAvailable,
        "inviteExpirationTime": inviteExpirationTime,
        "inviteLimit": inviteLimit,
        "inviteLimitCycle": inviteLimitCycle,
        "ltlAvailable": ltlAvailable,
        "mentionLimit": mentionLimit,
        "noteEachClipsLimit": noteEachClipsLimit,
        "pinLimit": pinLimit,
        "rateLimitFactor": rateLimitFactor,
        "skipNsfwDetection": skipNsfwDetection,
        "userEachUserListsLimit": userEachUserListsLimit,
        "userListLimit": userListLimit,
        "webhookLimit": webhookLimit,
        "wordMuteLimit": wordMuteLimit,
      };
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
