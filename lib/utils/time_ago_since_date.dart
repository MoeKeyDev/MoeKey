String timeAgoSinceDate(DateTime notificationDate) {
  final date2 = DateTime.now();
  final difference = date2.difference(notificationDate);

  if (difference.inSeconds < 5) {
    return '刚刚';
  } else if (difference.inSeconds < 60) {
    return '${difference.inSeconds}秒前';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}分钟前';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}小时前';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}天前';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()}月前';
  } else {
    return '${(difference.inDays / 365).floor()}年前';
  }
}
