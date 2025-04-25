import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:flutter/foundation.dart';

part 'login_user.freezed.dart';

part 'login_user.g.dart';

@freezed
abstract class LoginUser with _$LoginUser {
  const factory LoginUser({
    required String serverUrl,
    required String token,
    required UserFullModel userInfo,
    required String name,
    required String id,
  }) = _LoginUser;

  factory LoginUser.fromJson(Map<String, dynamic> json) =>
      _$LoginUserFromJson(json);
}
