import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'auth.freezed.dart';

part 'auth.g.dart';

@freezed
abstract class SessionGenerateModel with _$SessionGenerateModel {
  const factory SessionGenerateModel({
    required String token,
    required String url,
  }) = _SessionGenerateModel;

  factory SessionGenerateModel.fromJson(Map<String, dynamic> json) =>
      _$SessionGenerateModelFromJson(json);
}
