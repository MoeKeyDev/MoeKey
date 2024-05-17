import 'dart:convert';

import 'package:moekey/apis/models/user_full.dart';

///Following
class Following {
  final DateTime createdAt;
  final UserFullModel? followee;
  final String followeeId;
  final UserFullModel? follower;
  final String followerId;
  final String id;

  Following({
    required this.createdAt,
    this.followee,
    required this.followeeId,
    this.follower,
    required this.followerId,
    required this.id,
  });

  Following copyWith({
    DateTime? createdAt,
    UserFullModel? followee,
    String? followeeId,
    UserFullModel? follower,
    String? followerId,
    String? id,
  }) =>
      Following(
        createdAt: createdAt ?? this.createdAt,
        followee: followee ?? this.followee,
        followeeId: followeeId ?? this.followeeId,
        follower: follower ?? this.follower,
        followerId: followerId ?? this.followerId,
        id: id ?? this.id,
      );

  factory Following.fromJson(String str) => Following.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Following.fromMap(Map<String, dynamic> json) => Following(
        createdAt: DateTime.parse(json["createdAt"]),
        followee: json["followee"] == null
            ? null
            : UserFullModel.fromMap(json["followee"]),
        followeeId: json["followeeId"],
        follower: json["follower"] == null
            ? null
            : UserFullModel.fromMap(json["follower"]),
        followerId: json["followerId"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "createdAt": createdAt.toIso8601String(),
        "followee": followee?.toMap(),
        "followeeId": followeeId,
        "follower": follower?.toMap(),
        "followerId": followerId,
        "id": id,
      };
}
