import 'package:moekey/apis/services/services.dart';

enum IncomingFollowRequestStatus { unknown, pending, accepted, handled }

class FollowingService extends MisskeyApiServices {
  FollowingService({required super.client});

  Future<void> create({required String userId}) async {
    await client.post("/following/create", data: {"userId": userId});
  }

  Future<void> delete({required String userId}) async {
    await client.post("/following/delete", data: {"userId": userId});
  }

  Future<void> requestsCancel({required String userId}) async {
    await client.post("/following/requests/cancel", data: {"userId": userId});
  }

  Future<void> requestsAccept({required String userId}) async {
    await client.post("/following/requests/accept", data: {"userId": userId});
  }

  Future<void> requestsReject({required String userId}) async {
    await client.post("/following/requests/reject", data: {"userId": userId});
  }

  /// Notifications do not include whether a follow request is still pending.
  /// Resolve that state from the authenticated user's relationship fields.
  Future<IncomingFollowRequestStatus> incomingRequestStatus({
    required String userId,
  }) async {
    final user = await client.post<Map<String, dynamic>?>(
      "/users/show",
      data: {"userId": userId},
    );
    if (user == null || !user.containsKey("hasPendingFollowRequestToYou")) {
      return IncomingFollowRequestStatus.unknown;
    }
    if (user["hasPendingFollowRequestToYou"] == true) {
      return IncomingFollowRequestStatus.pending;
    }
    if (user["isFollowed"] == true) {
      return IncomingFollowRequestStatus.accepted;
    }
    return IncomingFollowRequestStatus.handled;
  }
}
