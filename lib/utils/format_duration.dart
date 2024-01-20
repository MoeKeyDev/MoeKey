String formatDuration(int milliseconds) {
  int seconds = (milliseconds / 1000).truncate();
  int minutes = (seconds / 60).truncate();
  int hours = (minutes / 60).truncate();
  int days = (hours / 24).truncate();

  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(minutes.remainder(60));
  String twoDigitSeconds = twoDigits(seconds.remainder(60));
  String twoDigitHours = twoDigits(hours.remainder(24));

  if (days > 0) {
    return "$days天$twoDigitHours小时$twoDigitMinutes分钟$twoDigitSeconds秒";
  } else if (hours > 0) {
    return "$twoDigitHours小时$twoDigitMinutes分钟$twoDigitSeconds秒";
  } else if (minutes > 0) {
    return "$twoDigitMinutes分钟$twoDigitSeconds秒";
  } else {
    return "$twoDigitSeconds秒";
  }
}
