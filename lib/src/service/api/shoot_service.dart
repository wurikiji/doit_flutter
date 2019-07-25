import 'dart:convert';
import 'dart:async';

import 'package:do_it/src/service/api/user_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class DoitShootService {
  static _createShootUrl() => 'http://13.125.252.156:8080/api/shoot/create';
  static List<DoitShootModel> shootList = <DoitShootModel>[];
  static StreamController<int> shootNotifier;

  initialize() {
    shootNotifier = StreamController<int>();
  }

  dispose() {
    shootNotifier.close();
  }

  static createShoot(DoitShootModel shoot) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var response = await http.post(
      _createShootUrl(),
      headers: headers,
      body: jsonEncode(shoot.toJsonToShoot()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to create goal: Code ${response.statusCode}");
      print(response.body);
      return false;
    }
    shootList.add(DoitShootModel.fromMap(jsonDecode(response.body)));
    shootNotifier.add(0);
    return true;
  }
}

class DoitShootModel {
  DoitShootModel({
    this.didIdislike = false,
    this.didILike = false,
    this.numDislike = 0,
    this.numLike = 0,
    this.overWorked = false,
    this.shootDate,
    this.shooter,
    this.shootId = 0,
    this.text,
    this.goalId,
    this.timerElapsed = 0,
    this.timerTargetMinutes = 0,
    @required this.shootName,
  });
  final bool didILike;
  final bool didIdislike;
  final DateTime shootDate;
  final bool overWorked;
  final int numLike;
  final int numDislike;
  final DoitMember shooter;
  final String shootName;
  final int shootId;
  final String text;
  final int goalId;
  final int timerTargetMinutes;
  final int timerElapsed;

  Map<String, dynamic> toJsonToShoot() => {
        'baseTime': timerTargetMinutes,
        'gid': goalId,
        'likeCount': 0,
        'mid': shooter.memberId,
        'shootName': shootName,
        'sid': shootId,
        'text': text,
        'time': timerElapsed,
      };

  factory DoitShootModel.fromMap(Map map) {
    Map shoot = map['shoot'];
    List<Map> body = map['shootConfirmList'];
    String text = body.singleWhere((Map check) => check['shootConfirmType'] == 'TEXT')['content'];
    String timer = body.singleWhere((Map check) => check['shootConfirmType'] == 'BASE_TIMER')['content'];
    return DoitShootModel(
      shootName: shoot['shootName'],
      shootId: shoot['sid'],
      numLike: shoot['likeCount'],
      numDislike: shoot['unLikeCount'],
      shooter: DoitMember.fromMap(shoot['maker']),
      shootDate: DateTime.fromMillisecondsSinceEpoch(shoot['epochDate'] * 60 * 60 * 24 * 1000),
      overWorked: shoot['exceeded'],
      didIdislike: map['likeBoolean'],
      didILike: map['unLikeBoolean'],
      timerTargetMinutes: int.parse(timer?.split('/')[1]),
      timerElapsed: int.parse(timer?.split('/')[0]),
      text: text,
    );
  }
}
