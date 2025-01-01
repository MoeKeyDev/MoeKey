import 'package:moekey/apis/models/user_lite.dart';

import 'note.dart';

class UserFullModel {
  String? avatarBlurhash;
  String? avatarUrl;
  String? bannerBlurhash;
  String? bannerUrl;
  String? birthday;
  DateTime createdAt;
  String? description;
  String? email;
  Map<String, dynamic> emojis;
  num followersCount;
  num followingCount;
  String? host;
  String id;
  bool isAdmin;
  bool publicReactions;
  OnlineStatus onlineStatus;
  DateTime? updatedAt;
  String username;
  String? name;
  List<dynamic> fields;
  List<AvatarDecoration>? avatarDecorations;

  //private public followers
  String? ffVisibility;
  String? followersVisibility;
  String? followingVisibility;
  List<NoteModel> pinnedNotes;
  List<String> pinnedNotesIds;
  String? uri;
  String? url;
  num notesCount;
  bool isFollowed;
  bool isFollowing;
  bool hasPendingFollowRequestFromYou;
  bool hasPendingFollowRequestToYou;
  bool isLocked;

  UserFullModel({
    this.avatarBlurhash,
    this.avatarUrl,
    this.bannerBlurhash,
    this.bannerUrl,
    this.birthday,
    required this.createdAt,
    this.description,
    this.email,
    required this.emojis,
    required this.followersCount,
    required this.followingCount,
    this.host,
    required this.id,
    required this.isAdmin,
    required this.onlineStatus,
    this.updatedAt,
    required this.username,
    this.name,
    required this.fields,
    this.ffVisibility,
    this.followersVisibility,
    this.followingVisibility,
    required this.pinnedNotes,
    required this.pinnedNotesIds,
    this.uri,
    this.url,
    this.avatarDecorations,
    required this.notesCount,
    required this.publicReactions,
    required this.isFollowed,
    required this.isFollowing,
    required this.hasPendingFollowRequestFromYou,
    required this.hasPendingFollowRequestToYou,
    required this.isLocked,
  });

  UserLiteModel toLiteUserModel() {
    return UserLiteModel(
        avatarBlurhash: avatarBlurhash,
        avatarDecorations: avatarDecorations ?? [],
        avatarUrl: avatarUrl,
        emojis: emojis,
        host: host,
        id: id,
        name: name,
        onlineStatus: onlineStatus,
        username: username);
  }

  factory UserFullModel.fromMap(dynamic map) {
    List<NoteModel> pinnedNotes = [];
    for (var item in map['pinnedNotes']) {
      pinnedNotes.add(NoteModel.fromMap(item));
    }
    return UserFullModel(
      avatarBlurhash: map['avatarBlurhash'],
      avatarUrl: map['avatarUrl'],
      bannerBlurhash: map['bannerBlurhash'],
      bannerUrl: map['bannerUrl'],
      birthday: map['birthday'],
      createdAt: DateTime.parse(map['createdAt']),
      description: map['description'],
      email: map['email'],
      emojis: Map<String, dynamic>.from(map['emojis']),
      followersCount: map['followersCount'],
      followingCount: map['followingCount'],
      host: map['host'],
      id: map['id'],
      isAdmin: map['isAdmin'] ?? false,
      onlineStatus: onlineStatusValues.map[map["onlineStatus"]]!,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      username: map['username'],
      name: map['name'],
      fields: map['fields'] ?? [],
      ffVisibility: map['ffVisibility'],
      followersVisibility: map['followersVisibility'],
      followingVisibility: map['followingVisibility'],
      pinnedNotes: pinnedNotes,
      uri: map['uri'],
      url: map['url'],
      pinnedNotesIds: map['pinnedNotesIds'] ?? [],
      notesCount: map['notesCount'],
      publicReactions: map["publicReactions"] ?? false,
      isFollowed: map["isFollowed"] ?? false,
      isFollowing: map["isFollowing"] ?? false,
      hasPendingFollowRequestFromYou:
          map["hasPendingFollowRequestFromYou"] ?? false,
      hasPendingFollowRequestToYou:
          map["hasPendingFollowRequestToYou"] ?? false,
      isLocked: map["isLocked"] ?? false,
    );
  }

  UserFullModel copyWith({
    String? avatarBlurhash,
    String? avatarUrl,
    String? bannerBlurhash,
    String? bannerUrl,
    String? birthday,
    DateTime? createdAt,
    String? description,
    String? email,
    Map<String, String>? emojis,
    num? followersCount,
    num? followingCount,
    String? host,
    String? id,
    bool? isAdmin,
    OnlineStatus? onlineStatus,
    DateTime? updatedAt,
    String? username,
    String? name,
    List<Map<String, String>>? fields,
    String? ffVisibility,
    String? followersVisibility,
    String? followingVisibility,
    List<NoteModel>? pinnedNotes,
    List<String>? pinnedNotesIds,
    String? uri,
    String? url,
    num? notesCount,
    bool? publicReactions,
    bool? isFollowed,
    bool? isFollowing,
    bool? hasPendingFollowRequestFromYou,
    bool? hasPendingFollowRequestToYou,
    bool? isLocked,
  }) {
    return UserFullModel(
      avatarBlurhash: avatarBlurhash ?? this.avatarBlurhash,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerBlurhash: bannerBlurhash ?? this.bannerBlurhash,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      birthday: birthday ?? this.birthday,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      email: email ?? this.email,
      emojis: emojis ?? this.emojis,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      host: host ?? this.host,
      id: id ?? this.id,
      isAdmin: isAdmin ?? this.isAdmin,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      name: name ?? this.name,
      fields: fields ?? this.fields,
      ffVisibility: ffVisibility ?? this.ffVisibility,
      followersVisibility: followersVisibility ?? this.followersVisibility,
      followingVisibility: followingVisibility ?? this.followingVisibility,
      pinnedNotes: pinnedNotes ?? this.pinnedNotes,
      pinnedNotesIds: pinnedNotesIds ?? this.pinnedNotesIds,
      uri: uri ?? this.uri,
      url: url ?? this.url,
      notesCount: notesCount ?? this.notesCount,
      publicReactions: publicReactions ?? this.publicReactions,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollowed: isFollowed ?? this.isFollowed,
      hasPendingFollowRequestToYou:
          hasPendingFollowRequestFromYou ?? this.hasPendingFollowRequestFromYou,
      hasPendingFollowRequestFromYou:
          hasPendingFollowRequestFromYou ?? this.hasPendingFollowRequestFromYou,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatarBlurhash': avatarBlurhash,
      'avatarUrl': avatarUrl,
      'bannerBlurhash': bannerBlurhash,
      'bannerUrl': bannerUrl,
      'birthday': birthday,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'email': email,
      'emojis': emojis,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'host': host,
      'id': id,
      'isAdmin': isAdmin,
      'publicReactions': publicReactions,
      'onlineStatus': onlineStatusValues.reverse[onlineStatus],
      'updatedAt': updatedAt?.toIso8601String(),
      'username': username,
      'name': name,
      'fields': fields,
      'avatarDecorations':
          avatarDecorations?.map((decoration) => decoration.toMap()).toList(),
      'ffVisibility': ffVisibility,
      'followersVisibility': followersVisibility,
      'followingVisibility': followingVisibility,
      'pinnedNotes': pinnedNotes.map((note) => note.toMap()).toList(),
      'pinnedNotesIds': pinnedNotesIds,
      'uri': uri,
      'url': url,
      'notesCount': notesCount,
      'isFollowed': isFollowed,
      'isFollowing': isFollowing,
      'hasPendingFollowRequestFromYou': hasPendingFollowRequestFromYou,
      'hasPendingFollowRequestToYou': hasPendingFollowRequestToYou,
      'isLocked': isLocked,
    };
  }

  @override
  String toString() {
    return 'UserFullModel{avatarBlurhash: $avatarBlurhash, avatarUrl: $avatarUrl, bannerBlurhash: $bannerBlurhash, bannerUrl: $bannerUrl, birthday: $birthday, createdAt: $createdAt, description: $description, email: $email, emojis: $emojis, followersCount: $followersCount, followingCount: $followingCount, host: $host, id: $id, isAdmin: $isAdmin, publicReactions: $publicReactions, onlineStatus: $onlineStatus, updatedAt: $updatedAt, username: $username, name: $name, fields: $fields, avatarDecorations: $avatarDecorations, ffVisibility: $ffVisibility, followersVisibility: $followersVisibility, followingVisibility: $followingVisibility, pinnedNotes: $pinnedNotes, pinnedNotesIds: $pinnedNotesIds, uri: $uri, url: $url, notesCount: $notesCount, isFollowed: $isFollowed, isFollowing: $isFollowing, hasPendingFollowRequestFromYou: $hasPendingFollowRequestFromYou, hasPendingFollowRequestToYou: $hasPendingFollowRequestToYou, isLocked: $isLocked}';
  }
}
