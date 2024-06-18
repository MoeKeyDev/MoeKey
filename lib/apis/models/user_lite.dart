import 'dart:convert';

///UserLiteModel
class UserLiteModel {
  final String? avatarBlurhash;
  final List<AvatarDecoration> avatarDecorations;
  final String? avatarUrl;
  final List<BadgeRoleModel>? badgeRoles;
  final Map<String, dynamic> emojis;

  ///The local host is represented with `null`.
  final String? host;
  final String id;
  final InstanceModel? instance;
  final bool? isBot;
  final bool? isCat;
  final String? name;
  final OnlineStatus onlineStatus;
  final String username;

  UserLiteModel({
    required this.avatarBlurhash,
    required this.avatarDecorations,
    required this.avatarUrl,
    this.badgeRoles,
    required this.emojis,
    required this.host,
    required this.id,
    this.instance,
    this.isBot,
    this.isCat,
    required this.name,
    required this.onlineStatus,
    required this.username,
  });

  String getAtUserName() {
    return "@$username${host != null ? "@$host" : ""}";
  }

  UserLiteModel copyWith({
    String? avatarBlurhash,
    List<AvatarDecoration>? avatarDecorations,
    String? avatarUrl,
    List<BadgeRoleModel>? badgeRoles,
    Map<String, String>? emojis,
    String? host,
    String? id,
    InstanceModel? instance,
    bool? isBot,
    bool? isCat,
    String? name,
    OnlineStatus? onlineStatus,
    String? username,
  }) =>
      UserLiteModel(
        avatarBlurhash: avatarBlurhash ?? this.avatarBlurhash,
        avatarDecorations: avatarDecorations ?? this.avatarDecorations,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        badgeRoles: badgeRoles ?? this.badgeRoles,
        emojis: emojis ?? this.emojis,
        host: host ?? this.host,
        id: id ?? this.id,
        instance: instance ?? this.instance,
        isBot: isBot ?? this.isBot,
        isCat: isCat ?? this.isCat,
        name: name ?? this.name,
        onlineStatus: onlineStatus ?? this.onlineStatus,
        username: username ?? this.username,
      );

  factory UserLiteModel.fromJson(String str) =>
      UserLiteModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserLiteModel.fromMap(Map<String, dynamic> json) => UserLiteModel(
        avatarBlurhash: json["avatarBlurhash"],
        avatarDecorations: List<AvatarDecoration>.from(
            json["avatarDecorations"].map((x) => AvatarDecoration.fromMap(x))),
        avatarUrl: json["avatarUrl"],
        badgeRoles: json["badgeRoles"] == null
            ? []
            : List<BadgeRoleModel>.from(
                json["badgeRoles"]!.map((x) => BadgeRoleModel.fromMap(x))),
        emojis: Map.from(json["emojis"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        host: json["host"],
        id: json["id"],
        instance: json["instance"] == null
            ? null
            : InstanceModel.fromMap(json["instance"]),
        isBot: json["isBot"],
        isCat: json["isCat"],
        name: json["name"],
        onlineStatus: onlineStatusValues.map[json["onlineStatus"]]!,
        username: json["username"],
      );

  Map<String, dynamic> toMap() => {
        "avatarBlurhash": avatarBlurhash,
        "avatarDecorations":
            List<dynamic>.from(avatarDecorations.map((x) => x.toMap())),
        "avatarUrl": avatarUrl,
        "badgeRoles": badgeRoles == null
            ? []
            : List<dynamic>.from(badgeRoles!.map((x) => x.toMap())),
        "emojis":
            Map.from(emojis).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "host": host,
        "id": id,
        "instance": instance?.toMap(),
        "isBot": isBot,
        "isCat": isCat,
        "name": name,
        "onlineStatus": onlineStatusValues.reverse[onlineStatus],
        "username": username,
      };
}

class AvatarDecoration {
  final double? angle;
  final bool? flipH;
  final String id;
  final double? offsetX;
  final double? offsetY;
  final String url;

  AvatarDecoration({
    this.angle,
    this.flipH,
    required this.id,
    this.offsetX,
    this.offsetY,
    required this.url,
  });

  AvatarDecoration copyWith({
    double? angle,
    bool? flipH,
    String? id,
    double? offsetX,
    double? offsetY,
    String? url,
  }) =>
      AvatarDecoration(
        angle: angle ?? this.angle,
        flipH: flipH ?? this.flipH,
        id: id ?? this.id,
        offsetX: offsetX ?? this.offsetX,
        offsetY: offsetY ?? this.offsetY,
        url: url ?? this.url,
      );

  factory AvatarDecoration.fromJson(String str) =>
      AvatarDecoration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AvatarDecoration.fromMap(Map<String, dynamic> json) =>
      AvatarDecoration(
        angle: json["angle"]?.toDouble(),
        flipH: json["flipH"],
        id: json["id"],
        offsetX: json["offsetX"]?.toDouble(),
        offsetY: json["offsetY"]?.toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "angle": angle,
        "flipH": flipH,
        "id": id,
        "offsetX": offsetX,
        "offsetY": offsetY,
        "url": url,
      };
}

class BadgeRoleModel {
  final String? behavior;
  final double displayOrder;
  final String? iconUrl;
  final String name;

  BadgeRoleModel({
    this.behavior,
    required this.displayOrder,
    required this.iconUrl,
    required this.name,
  });

  BadgeRoleModel copyWith({
    String? behavior,
    double? displayOrder,
    String? iconUrl,
    String? name,
  }) =>
      BadgeRoleModel(
        behavior: behavior ?? this.behavior,
        displayOrder: displayOrder ?? this.displayOrder,
        iconUrl: iconUrl ?? this.iconUrl,
        name: name ?? this.name,
      );

  factory BadgeRoleModel.fromJson(String str) =>
      BadgeRoleModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BadgeRoleModel.fromMap(Map<String, dynamic> json) => BadgeRoleModel(
        behavior: json["behavior"],
        displayOrder: json["displayOrder"]?.toDouble(),
        iconUrl: json["iconUrl"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "behavior": behavior,
        "displayOrder": displayOrder,
        "iconUrl": iconUrl,
        "name": name,
      };
}

class InstanceModel {
  final String? faviconUrl;
  final String? iconUrl;
  final String? name;
  final String? softwareName;
  final String? softwareVersion;
  final String? themeColor;

  InstanceModel({
    required this.faviconUrl,
    required this.iconUrl,
    required this.name,
    required this.softwareName,
    required this.softwareVersion,
    required this.themeColor,
  });

  InstanceModel copyWith({
    String? faviconUrl,
    String? iconUrl,
    String? name,
    String? softwareName,
    String? softwareVersion,
    String? themeColor,
  }) =>
      InstanceModel(
        faviconUrl: faviconUrl ?? this.faviconUrl,
        iconUrl: iconUrl ?? this.iconUrl,
        name: name ?? this.name,
        softwareName: softwareName ?? this.softwareName,
        softwareVersion: softwareVersion ?? this.softwareVersion,
        themeColor: themeColor ?? this.themeColor,
      );

  factory InstanceModel.fromJson(String str) =>
      InstanceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InstanceModel.fromMap(Map<String, dynamic> json) => InstanceModel(
        faviconUrl: json["faviconUrl"],
        iconUrl: json["iconUrl"],
        name: json["name"],
        softwareName: json["softwareName"],
        softwareVersion: json["softwareVersion"],
        themeColor: json["themeColor"],
      );

  Map<String, dynamic> toMap() => {
        "faviconUrl": faviconUrl,
        "iconUrl": iconUrl,
        "name": name,
        "softwareName": softwareName,
        "softwareVersion": softwareVersion,
        "themeColor": themeColor,
      };
}

enum OnlineStatus { ACTIVE, OFFLINE, ONLINE, UNKNOWN }

final onlineStatusValues = EnumValues({
  "active": OnlineStatus.ACTIVE,
  "offline": OnlineStatus.OFFLINE,
  "online": OnlineStatus.ONLINE,
  "unknown": OnlineStatus.UNKNOWN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
