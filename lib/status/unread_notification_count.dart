import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../logger.dart';
import 'me_detailed.dart';
import 'websocket.dart';

part 'unread_notification_count.g.dart';

const _unreadNotificationEvent = 'unreadNotification';
const _readAllNotificationsEvent = 'readAllNotifications';

int reduceUnreadNotificationCount(int currentCount, String eventType) {
  return switch (eventType) {
    _unreadNotificationEvent => currentCount + 1,
    _readAllNotificationsEvent => 0,
    _ => currentCount,
  };
}

String formatUnreadNotificationCount(int count) {
  return count > 99 ? '99+' : count.toString();
}

@riverpod
Future<int> initialUnreadNotificationCount(Ref ref) async {
  final me = await ref.watch(currentMeDetailedProvider.future);
  return me?.unreadNotificationsCount.toInt() ?? 0;
}

@Riverpod(keepAlive: true)
class UnreadNotificationCount extends _$UnreadNotificationCount {
  StreamSubscription<Map>? _subscription;
  final List<String> _pendingEvents = [];
  bool _initialized = false;

  @override
  Future<int> build() async {
    _initialized = false;
    _pendingEvents.clear();
    await _subscription?.cancel();

    _subscription = moekeyStreamMainChannelController.stream.listen(
      _handleMainChannelEvent,
    );
    ref.onDispose(() {
      final subscription = _subscription;
      if (subscription != null) {
        unawaited(subscription.cancel());
      }
      _subscription = null;
    });

    var count = 0;
    try {
      count = await ref.watch(initialUnreadNotificationCountProvider.future);
    } catch (error, stackTrace) {
      logger.e('Failed to load unread notification count: $error');
      logger.e(stackTrace);
    }

    for (final eventType in _pendingEvents) {
      count = reduceUnreadNotificationCount(count, eventType);
    }
    _pendingEvents.clear();
    _initialized = true;
    return count;
  }

  void _handleMainChannelEvent(Map event) {
    final eventType = event['type'];
    if (eventType != _unreadNotificationEvent &&
        eventType != _readAllNotificationsEvent) {
      return;
    }

    final currentCount = state.value;
    if (!_initialized || currentCount == null) {
      _pendingEvents.add(eventType as String);
      return;
    }

    state = AsyncData(
      reduceUnreadNotificationCount(currentCount, eventType as String),
    );
  }
}
