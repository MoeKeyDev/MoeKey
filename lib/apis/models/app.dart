import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app.freezed.dart';

part 'app.g.dart';

@freezed
class AppModel with _$AppModel {
  const factory AppModel({
    String? callbackUrl,
    required String id,
    bool? isAuthorized,
    required String name,
    required List<String> permission,
    String? secret,
  }) = _AppModel;

  factory AppModel.fromJson(Map<String, dynamic> json) =>
      _$AppModelFromJson(json);
}
