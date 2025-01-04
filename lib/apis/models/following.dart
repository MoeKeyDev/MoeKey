import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:flutter/foundation.dart';

part 'following.freezed.dart';

part 'following.g.dart';

@freezed
class Following with _$Following {
  const factory Following({
    required DateTime createdAt,
    UserFullModel? followee,
    required String followeeId,
    UserFullModel? follower,
    required String followerId,
    required String id,
  }) = _Following;

  factory Following.fromJson(Map<String, dynamic> json) =>
      _$FollowingFromJson(json);
}
