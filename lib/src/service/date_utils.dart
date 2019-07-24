import 'package:do_it/src/service/api/goal_service.dart';

bool isStarted(DoitGoalModel goal) {
  DateTime now = DateTime.now();
  DateTime tomorrow = DateTime(now.year, now.month, now.day).add(Duration(days: 1));
  return goal.startDate.isBefore(tomorrow);
}
