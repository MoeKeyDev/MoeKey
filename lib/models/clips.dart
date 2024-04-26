import 'dart:convert';

import 'package:moekey/models/user_simple.dart';


///Clip
class ClipsModel {
  DateTime createdAt;
  String? description;
  double favoritedCount;
  String id;
  bool isFavorited;
  bool isPublic;
  DateTime? lastClippedAt;
  String name;
  UserSimpleModel user;
  String userId;

  ClipsModel({
    required this.createdAt,
    required this.description,
    required this.favoritedCount,
    required this.id,
    required this.isFavorited,
    required this.isPublic,
    required this.lastClippedAt,
    required this.name,
    required this.user,
    required this.userId,
  });

  factory ClipsModel.fromMap(Map<String, dynamic> json) => ClipsModel(
    createdAt: DateTime.parse(json["createdAt"]),
    description: json["description"],
    favoritedCount: json["favoritedCount"]?.toDouble(),
    id: json["id"],
    isFavorited: json["isFavorited"],
    isPublic: json["isPublic"],
    lastClippedAt: json["lastClippedAt"] == null ? null : DateTime.parse(json["lastClippedAt"]),
    name: json["name"],
    user: UserSimpleModel.fromMap(json["user"]),
    userId: json["userId"],
  );
}