import 'package:dio/dio.dart';
import 'package:moekey/apis/models/auth.dart';
import 'package:moekey/apis/services/services.dart';

class AuthService extends MisskeyApiServices {
  AuthService({required super.client});

  Future<SessionGenerateModel?> sessionGenerate(
      {required String appSecret}) async {
    var data = await client.post(
      "/auth/session/generate",
      data: {"appSecret": appSecret},
      auth: false,
    );
    if (data != null) {
      return SessionGenerateModel.fromMap(data);
    }
    return null;
  }

  ///
  /// {"appSecret": appSecret, "token": token}
  Future<Map<String, dynamic>?> sessionUserKey(
      {required String appSecret, required String token}) async {
    return await client.post<Map<String, dynamic>>(
      "/auth/session/userkey",
      data: {"appSecret": appSecret, "token": token},
      auth: false,
      options: Options(
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
  }
}
