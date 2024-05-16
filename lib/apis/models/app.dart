import 'dart:convert';

class AppModel {
  final String? callbackUrl;
  final String id;
  final bool? isAuthorized;
  final String name;
  final List<String> permission;
  final String? secret;

  AppModel({
    required this.callbackUrl,
    required this.id,
    this.isAuthorized,
    required this.name,
    required this.permission,
    this.secret,
  });

  AppModel copyWith({
    String? callbackUrl,
    String? id,
    bool? isAuthorized,
    String? name,
    List<String>? permission,
    String? secret,
  }) =>
      AppModel(
        callbackUrl: callbackUrl ?? this.callbackUrl,
        id: id ?? this.id,
        isAuthorized: isAuthorized ?? this.isAuthorized,
        name: name ?? this.name,
        permission: permission ?? this.permission,
        secret: secret ?? this.secret,
      );

  factory AppModel.fromJson(String str) => AppModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppModel.fromMap(Map<String, dynamic> json) => AppModel(
        callbackUrl: json["callbackUrl"],
        id: json["id"],
        isAuthorized: json["isAuthorized"],
        name: json["name"],
        permission: List<String>.from(json["permission"].map((x) => x)),
        secret: json["secret"],
      );

  Map<String, dynamic> toMap() => {
        "callbackUrl": callbackUrl,
        "id": id,
        "isAuthorized": isAuthorized,
        "name": name,
        "permission": List<dynamic>.from(permission.map((x) => x)),
        "secret": secret,
      };
}
