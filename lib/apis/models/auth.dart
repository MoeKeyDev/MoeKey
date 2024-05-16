import 'dart:convert';

class SessionGenerateModel {
  final String token;
  final String url;

  SessionGenerateModel({
    required this.token,
    required this.url,
  });

  SessionGenerateModel copyWith({
    String? token,
    String? url,
  }) =>
      SessionGenerateModel(
        token: token ?? this.token,
        url: url ?? this.url,
      );

  factory SessionGenerateModel.fromJson(String str) =>
      SessionGenerateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SessionGenerateModel.fromMap(Map<String, dynamic> json) =>
      SessionGenerateModel(
        token: json["token"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "url": url,
      };
}
