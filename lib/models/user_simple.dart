class UserSimpleModel {
  bool isCat;
  Map emojis;
  bool isBot;
  String? avatarUrl;
  String? avatarBlurhash;
  String onlineStatus;
  String? name;
  String? host;
  // late List<dynamic> badgeRoles;
  // late List<dynamic> avatarDecorations;
  String id;
  String username;
  InstanceModel? instance;
  UserSimpleModel(
      {required this.isCat,
      required this.emojis,
      required this.isBot,
      this.avatarUrl,
      this.avatarBlurhash,
      required this.onlineStatus,
      this.name,
      this.host,
      this.instance,
      required this.id,
      required this.username});

  UserSimpleModel copyWith(
      {bool? isCat,
      Map? emojis,
      bool? isBot,
      String? avatarUrl,
      String? avatarBlurhash,
      String? onlineStatus,
      String? name,
      String? host,
      String? id,
      String? username,
      InstanceModel? instance}) {
    return UserSimpleModel(
        isCat: isCat ?? this.isCat,
        emojis: emojis ?? this.emojis,
        isBot: isBot ?? this.isBot,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        avatarBlurhash: avatarBlurhash ?? this.avatarBlurhash,
        onlineStatus: onlineStatus ?? this.onlineStatus,
        name: name ?? this.name,
        host: host ?? this.host,
        id: id ?? this.id,
        username: username ?? this.username,
        instance: instance ?? this.instance);
  }

  factory UserSimpleModel.fromMap(dynamic map) {
    return UserSimpleModel(
        isCat: map['isCat'],
        emojis: map['emojis'],
        isBot: map['isBot'],
        avatarUrl: map['avatarUrl'],
        avatarBlurhash: map['avatarBlurhash'],
        onlineStatus: map['onlineStatus'],
        name: map['name'],
        host: map['host'],
        id: map['id'],
        username: map['username'],
        instance: map['instance'] != null
            ? InstanceModel.fromMap(map['instance'])
            : null);
  }

  @override
  String toString() {
    return 'UserModel{isCat: $isCat, emojis: $emojis, isBot: $isBot, avatarUrl: $avatarUrl, avatarBlurhash: $avatarBlurhash, onlineStatus: $onlineStatus, name: $name, host: $host, id: $id, username: $username, instance: $instance}';
  }
}

class InstanceModel {
  String? faviconUrl;
  String softwareName;
  String themeColor;
  String name;
  String iconUrl;
  String softwareVersion;

  InstanceModel(
      {this.faviconUrl,
      required this.softwareName,
      required this.themeColor,
      required this.name,
      required this.iconUrl,
      required this.softwareVersion});

  factory InstanceModel.fromMap(dynamic map) {
    return InstanceModel(
      faviconUrl: map['faviconUrl'],
      softwareName: map['softwareName'],
      themeColor: map['themeColor'] ?? "#ccff66",
      name: map['name'] ?? "",
      iconUrl: map['iconUrl'] ?? "",
      softwareVersion: map['softwareVersion'] ?? "",
    );
  }

  InstanceModel copyWith({
    String? faviconUrl,
    String? softwareName,
    String? themeColor,
    String? name,
    String? iconUrl,
    String? softwareVersion,
  }) {
    return InstanceModel(
      faviconUrl: faviconUrl ?? this.faviconUrl,
      softwareName: softwareName ?? this.softwareName,
      themeColor: themeColor ?? this.themeColor,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      softwareVersion: softwareVersion ?? this.softwareVersion,
    );
  }

  @override
  String toString() {
    return 'InstanceModel{faviconUrl: $faviconUrl, softwareName: $softwareName, themeColor: $themeColor, name: $name, iconUrl: $iconUrl, softwareVersion: $softwareVersion}';
  }
}
