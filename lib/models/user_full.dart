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
  String onlineStatus;
  DateTime updatedAt;
  String username;
  String? name;
  List<dynamic> fields;
  //private public followers
  String? ffVisibility;
  String? followersVisibility;
  String? followingVisibility;
  List<NoteModel> pinnedNotes;
  List<String> pinnedNotesIds;
  String? uri;
  String? url;
  num notesCount;
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
    required this.updatedAt,
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
    required this.notesCount,
    required this.publicReactions,
  });

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
      emojis: map['emojis'],
      followersCount: map['followersCount'],
      followingCount: map['followingCount'],
      host: map['host'],
      id: map['id'],
      isAdmin: map['isAdmin'] ?? false,
      onlineStatus: map['onlineStatus'],
      updatedAt: DateTime.parse(map['updatedAt']),
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
    String? onlineStatus,
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
    );
  }
}
