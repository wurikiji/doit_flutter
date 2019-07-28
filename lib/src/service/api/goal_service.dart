import 'dart:convert';

import 'package:do_it/src/service/api/user_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class DoitGoalService {
  static String _createGetGoalsUrl(int mid) => 'http://13.125.252.156:8080/api/goals/$mid';
  static String _createCreateGoalUrl() => 'http://13.125.252.156:8080/api/goals/create';
  static String _createGetGoalMembersUrl(int gid) => 'http://13.125.252.156:8080/api/goal/$gid';
  static String _createCreateInvitationLinkUrl(int mid, int gid) =>
      'http://13.125.252.156:8080/api/goal/invite/from/$mid/goal/$gid';
  static String _joinGaolUrl() => 'http://13.125.252.156:8080/api/goal/participate/';

  static StreamController<int> notifyStream;
  static List<DoitGoalModel> goalList = <DoitGoalModel>[];
  static Timer refreshTimer;

  static initialize() {
    notifyStream = StreamController<int>();
    refreshTimer = Timer.periodic(Duration(seconds: 15), (timer) async {
      getGoalsFromServer(
        null,
      );
    });
  }

  static dispose() {
    notifyStream.close();
    refreshTimer.cancel();
  }

  static Future<bool> getGoalsFromServer(BuildContext context) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
    };
    var response = await http.get(
      _createGetGoalsUrl(DoitUserAPI.memberInfo.memberId),
      headers: headers,
    );
    if (response.statusCode == 400) {
      goalList = <DoitGoalModel>[];
      notifyStream.add(0);
      return true;
    } else if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to get goals: Code ${response.statusCode}");
      print(response.body);
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

  static Future<bool> createGoal(DoitGoalModel goal) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var response = await http.post(
      _createCreateGoalUrl(),
      headers: headers,
      body: jsonEncode(goal.toJsonForServerWithMid(DoitUserAPI.memberInfo.memberId)),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to create goal: Code ${response.statusCode}");
      print(response.body);
      return false;
    }
    goalList.add(DoitGoalModel.fromMap(jsonDecode(response.body)));
    notifyStream.add(0);
    return true;
  }

  static Future<List<DoitMember>> getMembers(DoitGoalModel goal) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
    };
    var response = await http.get(
      _createGetGoalMembersUrl(goal.goalId),
      headers: headers,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to get goal members: Code ${response.statusCode}");
      print(response.body);
      return null;
    }
    Map responseMap = jsonDecode(response.body);
    List members = responseMap['memberDtoList'];
    return members
        ?.where((user) => user is Map)
        ?.map(
          (user) => DoitMember.fromMap(user),
        )
        ?.toList();
  }

  static Future<String> getInvitationLink(DoitGoalModel goal) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
    };
    var response = await http.get(
      _createCreateInvitationLinkUrl(DoitUserAPI.memberInfo.memberId, goal.goalId),
      headers: headers,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to create invitation link: Code ${response.statusCode}");
      print(response.body);
      return null;
    }
    final int invitationCode = int.parse(response.body);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://depromeetdoit.page.link/',
      link: Uri.parse('https://depromeet.com/doit/goal/${goal.goalId}/join/$invitationCode'),
      androidParameters: AndroidParameters(
        packageName: 'com.depromeet.do_it',
        minimumVersion: 1,
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    return Uri.decodeFull(dynamicUrl.toString());
  }

  static Future<DoitGoalModel> joinGoal(int goalId, int inviteId) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var response = await http.post(
      _joinGaolUrl(),
      headers: headers,
      body: jsonEncode(
        {
          'gid': goalId,
          'mid': DoitUserAPI.memberInfo.memberId,
          'inviteId': inviteId,
        },
      ),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to create invitation link: Code ${response.statusCode}");
      print(response.body);
      return null;
    }
    DoitGoalModel goal = DoitGoalModel.fromMap(jsonDecode(response.body)['goal']);
    goalList.add(goal);
    notifyStream.add(0);
    return goal;
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
    this.createMid,
    this.isMine,
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
  final int createMid;
  final bool isMine;

  factory DoitGoalModel.fromMap(Map goalMap) {
    Map map = goalMap['goal'];
    bool isMine = goalMap['host'];

    return DoitGoalModel(
      categoryName: map['category'],
      endDate:
          DateTime.fromMillisecondsSinceEpoch(map['epochEndDate'] * (60 * 60 * 24 * 1000 + 100)),
      startDate:
          DateTime.fromMillisecondsSinceEpoch(map['epochStartDate'] * (60 * 60 * 24 * 1000 + 100)),
      goalId: map['gid'],
      goalName: map['goalName'],
      penalty: map['penalty'],
      repeatDays: map['progressCheckCount'],
      repeatType: getReapeatTypeFromIndex(map['progressCheckType']['pctId']),
      progressRate: map['progressRate'],
      goalColor: map['themeColor'],
      useTimer: map['timerCheck'],
      isMine: isMine,
    );
  }

  Map<String, dynamic> toJsonForServerWithMid(int memberId) => {
        'category': categoryName,
        'color': goalColor,
        'endDate': endDate.millisecondsSinceEpoch ~/ (60 * 60 * 24 * 1000),
        'startDate': startDate.millisecondsSinceEpoch ~/ (60 * 60 * 24 * 1000),
        'memberCount': memberCount,
        'mid': memberId,
        'name': goalName,
        'penalty': penalty,
        'progressCount': repeatDays,
        'progressType': repeatType?.index ?? 1,
        'timerCheck': useTimer,
      };

  String toString() => jsonEncode(toJsonForServerWithMid(null));
}
