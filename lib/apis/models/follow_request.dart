import 'package:moekey/apis/models/user_lite.dart';

class FollowRequestModel {
  const FollowRequestModel({
    required this.id,
    required this.follower,
    required this.followee,
  });

  factory FollowRequestModel.fromJson(Map<String, dynamic> json) {
    return FollowRequestModel(
      id: json['id'] as String,
      follower: UserLiteModel.fromJson(
        json['follower'] as Map<String, dynamic>,
      ),
      followee: UserLiteModel.fromJson(
        json['followee'] as Map<String, dynamic>,
      ),
    );
  }

  final String id;
  final UserLiteModel follower;
  final UserLiteModel followee;
}
