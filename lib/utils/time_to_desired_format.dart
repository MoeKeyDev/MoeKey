import 'package:intl/intl.dart';
import 'package:misskey/utils/time_ago_since_date.dart';

String timeToDesiredFormat(DateTime dateTime) {
  String formattedDateTime =
      DateFormat('yyyy/MM/dd HH:mm:ss').format(dateTime.toLocal());
  return "$formattedDateTime (${timeAgoSinceDate(dateTime)})";
}
