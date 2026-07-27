import 'package:moekey/apis/services/services.dart';

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
}
