import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:moekey/apis/models/user_lite.dart';

part 'clips.freezed.dart';

part 'clips.g.dart';

@freezed
abstract class ClipsModel with _$ClipsModel {
  const factory ClipsModel({
    required DateTime createdAt,
    String? description,
    required int favoritedCount,
    required String id,
    required bool isFavorited,
    required bool isPublic,
    DateTime? lastClippedAt,
    required String name,
    required UserLiteModel user,
    required String userId,
  }) = _ClipsModel;

  factory ClipsModel.fromJson(Map<String, dynamic> json) =>
      _$ClipsModelFromJson(json);
}
