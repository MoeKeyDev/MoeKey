import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/apis/models/notification.dart';
import 'package:moekey/apis/services/account_service.dart';

void main() {
  const wireTypes = <String>[
    'note',
    'follow',
    'mention',
    'reply',
    'renote',
    'quote',
    'reaction',
    'pollEnded',
    'scheduledNotePosted',
    'scheduledNotePostFailed',
    'receiveFollowRequest',
    'followRequestAccepted',
    'roleAssigned',
    'chatRoomInvitationReceived',
    'achievementEarned',
    'exportCompleted',
    'login',
    'createToken',
    'app',
    'test',
    'reaction:grouped',
    'renote:grouped',
  ];

  test('decodes every current Misskey notification type', () {
    for (final (index, type) in wireTypes.indexed) {
      final notification = NotificationModel.fromJson({
        'id': '$index',
        'createdAt': '2026-07-27T00:00:00.000Z',
        'type': type,
        if (type == 'scheduledNotePostFailed')
          'noteDraft': {'cw': 'content warning', 'text': 'draft text'},
        if (type == 'roleAssigned')
          'role': {
            'name': 'Moderator',
            'iconUrl': 'https://example.com/role.png',
          },
        if (type == 'achievementEarned') 'achievement': 'futureAchievement',
        if (type == 'exportCompleted') 'exportedEntity': 'futureEntity',
      });

      expect(notification.notificationType, isNot(NotificationType.unknown));
      expect(notification.type, type);
    }
  });

  test('preserves unknown notification and payload identifiers', () {
    final notification = NotificationModel.fromJson({
      'id': 'unknown',
      'createdAt': '2026-07-27T00:00:00.000Z',
      'type': 'futureNotification',
      'achievement': 'futureAchievement',
      'exportedEntity': 'futureEntity',
    });

    expect(notification.notificationType, NotificationType.unknown);
    expect(notification.type, 'futureNotification');
    expect(notification.achievement, 'futureAchievement');
    expect(notification.exportedEntity, 'futureEntity');
  });

  test('a malformed item does not discard valid notifications', () {
    final notifications = decodeNotificationList([
      {
        'id': 'first',
        'createdAt': '2026-07-27T00:00:00.000Z',
        'type': 'follow',
      },
      {'createdAt': 'not a date', 'type': 'reply'},
      {
        'id': 'last',
        'createdAt': '2026-07-27T00:00:02.000Z',
        'type': 'futureNotification',
      },
    ]);

    expect(notifications.map((item) => item.id), ['first', 'last']);
    expect(notifications.last.notificationType, NotificationType.unknown);
  });
}
