import 'package:moekey/apis/models/user_lite.dart';

///Clip
class ClipsModel {
  DateTime createdAt;
  String? description;
  int favoritedCount;
  String id;
  bool isFavorited;
  bool isPublic;
  DateTime? lastClippedAt;
  String name;
  UserLiteModel user;
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
        favoritedCount: json["favoritedCount"],
        id: json["id"],
        isFavorited: json["isFavorited"],
        isPublic: json["isPublic"],
        lastClippedAt: json["lastClippedAt"] == null
            ? null
            : DateTime.parse(json["lastClippedAt"]),
        name: json["name"],
        user: UserLiteModel.fromMap(json["user"]),
        userId: json["userId"],
      );
}
