import 'dart:convert';

import 'package:crypto/crypto.dart';

String getToken(String accessToken, String appSecret) {
  final bytes = utf8.encode(accessToken + appSecret);
  final hash = sha256.convert(bytes);
  return hash.toString();
}
