class LoginUser {
  final String serverUrl;
  final String token;
  final Map userInfo;
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
      "userInfo": userInfo,
      "name": name,
      "id": id,
    };
  }

  factory LoginUser.fromMap(Map<dynamic, dynamic> json) => LoginUser(
      serverUrl: json["serverUrl"],
      token: json["token"],
      userInfo: json["userInfo"],
      name: json["name"],
      id: json["id"]);
}
