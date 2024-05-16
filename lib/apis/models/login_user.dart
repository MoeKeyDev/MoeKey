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

  Map<String, dynamic> toJson() {
    return {
      "serverUrl": serverUrl,
      "token": token,
      "userInfo": userInfo,
      "name": name,
      "id": id,
    };
  }
}
