import 'package:moekey/apis/models/user_full.dart';

class LoginUser {
  final String serverUrl;
  final String token;
  final UserFullModel userInfo;
  final String name;
  final String id;

  LoginUser({
    required this.serverUrl,
    required this.token,
    required this.userInfo,
    required this.name,
    required this.id,
  });

  @override
  String toString() {
    return 'LoginUser{serverUrl: $serverUrl, token: $token, userInfo: $userInfo, name: $name, id: $id}';
  }

  Map<String, dynamic> toMap() {
    return {
      "serverUrl": serverUrl,
      "token": token,
      "userInfo": userInfo.toMap(),
      "name": name,
      "id": id,
    };
  }

  LoginUser copyWith({
    String? serverUrl,
    String? token,
    UserFullModel? userInfo,
    String? name,
    String? id,
  }) {
    return LoginUser(
      name: name ?? this.name,
      serverUrl: serverUrl ?? this.serverUrl,
      token: token ?? this.token,
      userInfo: userInfo ?? this.userInfo,
      id: id ?? this.id,
    );
  }

  factory LoginUser.fromMap(Map json) => LoginUser(
      serverUrl: json["serverUrl"],
      token: json["token"],
      userInfo: UserFullModel.fromMap(json["userInfo"]),
      name: json["name"],
      id: json["id"]);
}
