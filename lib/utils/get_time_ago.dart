import 'package:timeago/timeago.dart' as timeago;

String getTimeAgo(DateTime time) {
  return timeago.format(time);
}
