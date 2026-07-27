import 'package:moekey/apis/models/me_detailed.dart';
import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/apis/services/services.dart';
import 'package:moekey/logger.dart';

List<NotificationModel> decodeNotificationList(Iterable<dynamic> source) {
  final notifications = <NotificationModel>[];
  for (final item in source) {
    try {
      notifications.add(
        NotificationModel.fromJson(Map<String, dynamic>.from(item as Map)),
      );
    } catch (error, stackTrace) {
      logger.e('Failed to decode notification: $error');
      logger.e(stackTrace);
    }
  }
  return notifications;
}

class AccountService extends MisskeyApiServices {
  AccountService({required super.client});

  Future<MeDetailed?> i() async {
    var data = await client.post("/i");
    if (data != null) {
      return MeDetailed.fromJson(data);
    }
    return null;
  }

  Future<List<NotificationModel>> notificationsGrouped({
    String? untilId,
  }) async {
    var res = await client.post<List?>(
      "/i/notifications-grouped",
      data: {"limit": 20, "untilId": ?untilId},
    );
    if (res == null) {
      return [];
    }
    return decodeNotificationList(res);
  }

  // i/update
  Future<MeDetailed> update({Map<String, dynamic>? data}) async {
    var res = await client.post("/i/update", data: data);
    return MeDetailed.fromJson(res);
  }
}
