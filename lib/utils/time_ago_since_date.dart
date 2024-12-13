import '../generated/l10n.dart';

String timeAgoSinceDate(DateTime notificationDate) {
  final date2 = DateTime.now();
  final difference = date2.difference(notificationDate);

  if (difference.inSeconds < 10) {
    return S.current.justNow;
  } else if (difference.inSeconds < 60) {
    return S.current.secondsAgo(difference.inSeconds);
  } else if (difference.inMinutes < 60) {
    return S.current.minutesAgo(difference.inMinutes);
  } else if (difference.inHours < 24) {
    return S.current.hoursAgo(difference.inHours);
  } else if (difference.inDays < 30) {
    return S.current.daysAgo(difference.inDays);
  } else if (difference.inDays < 365) {
    return S.current.monthsAgo((difference.inDays / 30).floor());
  } else {
    return S.current.yearsAgo((difference.inDays / 365).floor());
  }
}
