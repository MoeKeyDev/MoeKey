import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/services.dart';

class AccountService extends MisskeyApiServices {
  AccountService({required super.client});

  Future<UserLiteModel?> i() async {
    var data = await client.post("/i");
    if (data != null) {
      return UserLiteModel.fromMap(data);
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
        res.map((e) => NotificationModel.fromMap(e)));
  }
}
