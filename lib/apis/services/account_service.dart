import 'package:moekey/apis/models/me_detailed.dart';
import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/services.dart';

class AccountService extends MisskeyApiServices {
  AccountService({required super.client});

  Future<MeDetailed?> i() async {
    var data = await client.post("/i");
    if (data != null) {
      return MeDetailed.fromJson(data);
    }
    return null;
  }

  Future<List<NotificationModel>> notificationsGrouped(
      {String? untilId}) async {
    var res = await client.post<List?>("/i/notifications-grouped", data: {
      "limit": 20,
      if (untilId != null) "untilId": untilId,
    });
    if (res == null) {
      return [];
    }
    return List<NotificationModel>.from(
        res.map((e) => NotificationModel.fromJson(e)));
  }

  // i/update
  Future<MeDetailed> update({
    Map<String, dynamic>? data,
  }) async {
    var res = await client.post("/i/update", data: data);
    return MeDetailed.fromJson(res);
  }
}
