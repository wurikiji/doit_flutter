import 'package:do_it/src/service/api/goal_service.dart';
import 'package:intl/intl.dart';

bool isStarted(DoitGoalModel goal) {
  DateTime now = DateTime.now();
  DateTime tomorrow = DateTime(now.year, now.month, now.day).add(Duration(days: 1));
  return goal.startDate.isBefore(tomorrow);
}

bool isEnded(DoitGoalModel goal) {
  DateTime now = DateTime.now();
  DateTime midnight = DateTime(now.year, now.month, now.day);
  return goal.endDate.isBefore(midnight);
}

String getDateRange(DoitGoalModel goal) {
  final String start = (DateFormat('yyyy-MM-dd').format(goal.startDate));
  final String end = (DateFormat('yyyy-MM-dd').format(goal.endDate));
  final String range = '$start - $end';
  return range;
}

int getDdayToEnd(DoitGoalModel goal) {
  final DateTime now = DateTime.now();
  final Duration remain = goal.endDate.difference(now);
  return remain.inDays + 1;
}

String getTimeFromDuration(Duration duration) {
  return DateFormat('HH:mm:ss').format(DateTime(0, 0, 0, 0, 0, duration.inSeconds));
}
