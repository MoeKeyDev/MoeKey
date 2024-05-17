import 'package:moekey/apis/services/services.dart';

class FollowingService extends MisskeyApiServices {
  FollowingService({required super.client});

  create({required String userId}) async {
    await client.post(
      "/following/create",
      data: {
        "userId": userId,
      },
    );
  }

  delete({required String userId}) async {
    await client.post(
      "/following/delete",
      data: {
        "userId": userId,
      },
    );
  }

  requestsCancel({required String userId}) async {
    await client.post(
      "/following/requests/cancel",
      data: {
        "userId": userId,
      },
    );
  }
}
