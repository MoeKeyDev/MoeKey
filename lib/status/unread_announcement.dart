import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/announcement.dart';
import 'package:moekey/status/me_detailed.dart';

/// Announcements acknowledged in this session, before the next server refresh
/// returns their updated read state.
final dismissedAnnouncementBannerIdsProvider =
    NotifierProvider<_DismissedAnnouncementBannerIds, Set<String>>(
      _DismissedAnnouncementBannerIds.new,
    );

class _DismissedAnnouncementBannerIds extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void dismiss(String announcementId) {
    state = {...state, announcementId};
  }

  void restore(String announcementId) {
    state = {...state}..remove(announcementId);
  }
}

/// The first unread announcement intended for the global banner area.
final firstUnreadBannerAnnouncementProvider = FutureProvider<Announcement?>((
  ref,
) async {
  final dismissed = ref.watch(dismissedAnnouncementBannerIdsProvider);
  final announcements =
      (await ref.watch(
        currentMeDetailedProvider.future,
      ))?.unreadAnnouncements ??
      const <Announcement>[];
  for (final announcement in announcements) {
    if (!announcement.isRead &&
        announcement.display == AnnouncementDisplay.banner &&
        !dismissed.contains(announcement.id)) {
      return announcement;
    }
  }
  return null;
});
