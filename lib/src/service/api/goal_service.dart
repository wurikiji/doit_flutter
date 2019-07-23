import 'dart:convert';

import 'package:do_it/src/screen/main/doit_main.dart' as prefix0;
import 'package:do_it/src/service/api/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class DoitGoalService {
  static String _createGetGoalsUrl(int mid) => 'http://13.125.252.156:8080/api/goals/$mid';
  static String _createCreateGoalUrl() => 'http://13.125.252.156:8080/api/goals/create';

  static StreamController<int> notifyStream;
  static List<DoitGoalModel> goalList = <DoitGoalModel>[];
  static Timer refreshTimer;

  static initialize() {
    notifyStream = StreamController<int>();
    refreshTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      getGoalsFromServer(
        null,
        DoitUserAPI.memberInfo.memberId,
      );
    });
  }

  static dispose() {
    notifyStream.close();
    refreshTimer.cancel();
  }

  static Future<bool> getGoalsFromServer(BuildContext context, int memberId) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
    };
    var response = await http.get(
      _createGetGoalsUrl(memberId),
      headers: headers,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to get goals: Code ${response.statusCode}");
      if (context != null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to load goals: CODE ${response.statusCode}"),
          ),
        );
      }
      return false;
    }
    List goals = jsonDecode(response.body);
    goalList = goals.map((data) {
      return DoitGoalModel.fromMap(data);
    }).toList();
    if (goalList == null) goalList = <DoitGoalModel>[];
    notifyStream.add(0);
    return true;
  }

  static Future<bool> createGoal(int memberId, DoitGoalModel goal) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var response = await http.put(
      _createCreateGoalUrl(),
      headers: headers,
      body: jsonEncode(goal.toJsonForServerWithMid(memberId)),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to create goal: Code ${response.statusCode}");
      return false;
    }
    goalList.add(DoitGoalModel.fromMap(jsonDecode(response.body)));
    notifyStream.add(0);
    return true;
  }
}

enum DoitGoalRepeatType { invalid, perWeek, perDay, everyDay }

DoitGoalRepeatType getReapeatTypeFromIndex(int idx) {
  return DoitGoalRepeatType.values.singleWhere((type) => type.index == idx);
}

class DoitGoalModel {
  DoitGoalModel({
    this.categoryName,
    this.endDate,
    this.goalId,
    this.goalName,
    this.penalty,
    this.repeatDays,
    this.repeatType,
    this.startDate,
    this.goalColor,
    this.useTimer,
    this.progressRate,
    this.memberCount,
  });
  final int goalId;
  final String goalName;
  final String categoryName;
  final String goalColor;
  final int penalty;
  final DoitGoalRepeatType repeatType;
  final int repeatDays;
  final bool useTimer;
  final DateTime startDate;
  final DateTime endDate;
  final int progressRate;
  final int memberCount;

  factory DoitGoalModel.fromMap(Map map) => DoitGoalModel(
        categoryName: map['category'],
        endDate: DateTime.fromMillisecondsSinceEpoch(map['epochEndDate'] * (60 * 60 * 24 * 1000)),
        startDate: DateTime.fromMillisecondsSinceEpoch(map['epochStartDate'] * (60 * 60 * 24 * 1000)),
        goalId: map['gid'],
        goalName: map['goalName'],
        penalty: map['penalty'],
        repeatDays: map['progressCheckCount'],
        repeatType: getReapeatTypeFromIndex(map['progressCheckType']['pctId']),
        progressRate: map['progressRate'],
        goalColor: map['themeColor'],
        useTimer: map['timerCheck'],
      );

  Map<String, dynamic> toJsonForServerWithMid(int memberId) => {
        'category': categoryName,
        'color': goalColor,
        'endDate': endDate.millisecondsSinceEpoch / (60 * 60 * 24 * 1000),
        'startDate': startDate.millisecondsSinceEpoch / (60 * 60 * 24 * 1000),
        'memberCount': memberCount,
        'mid': memberId,
        'name': goalName,
        'penalty': penalty,
        'progressCount': repeatDays,
        'progressType': repeatType.index,
        'timerCheck': useTimer,
      };

  String toString() => jsonEncode(toJsonForServerWithMid(null));
}
