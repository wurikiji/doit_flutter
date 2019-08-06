import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

enum DoitSocialType { likeUp, likeDown, dislikeUp, dislikeDown }

class DoitShootService {
  static _createShootUrl() => 'http://13.125.252.156:8080/api/shoot/create';
  static _getShootsUrl(int gid, int mid) =>
      'http://13.125.252.156:8080/api/shoot/get/mid/$mid/gid/$gid';
  static _createShootImageUrl(int sid) => 'http://13.125.252.156:8080/api/shoot/$sid/image/create';
  static _likeDownUrl(int mid, int sid) =>
      'http://13.125.252.156:8080/api/shoot/down/likecount/mid/$mid/sid/$sid';
  static _likeUpUrl(int mid, int sid) =>
      'http://13.125.252.156:8080/api/shoot/up/likecount/mid/$mid/sid/$sid/';
  static _dislikeUpUrl(int mid, int sid) =>
      'http://13.125.252.156:8080/api/shoot/up/unlikecount/mid/$mid/sid/$sid';
  static _dislikeDownUrl(int mid, int sid) =>
      'http://13.125.252.156:8080/api/shoot/down/unlikecount/mid/$mid/sid/$sid';

  static _deleteShootUrl(int sid) => 'http://13.125.252.156:8080/api/shoot/$sid';

  static List<DoitShootModel> shootList = <DoitShootModel>[];
  static StreamController<int> shootNotifier;

  static initialize() {
    shootNotifier = StreamController<int>();
  }

  static dispose() {
    shootNotifier.close();
  }

  static createShoot(DoitShootModel shoot, {File image}) async {
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
      print("[DOIT GOAL API] Failed to create shoot: Code ${response.statusCode}");
      print(response.body);
      return false;
    }
    print(response.body);
    DoitShootModel newShoot = DoitShootModel.fromMap({
      'shoot': jsonDecode(response.body),
      'likeBoolean': false,
      'unLikeBoolean': false,
    });
    if (image != null) {}
    // getShoots(DoitGoalModel(goalId: shoot.goalId));
    shoot.shootId = newShoot.shootId;
    shoot.overWorked = newShoot.overWorked;
    shoot.shootDate = newShoot.shootDate;
    shootList.add(shoot);
    shootNotifier.add(0);
    return true;
  }

  static deleteShoot(DoitShootModel shoot, int index) async {
    Map headers = <String, String>{
      'Accept': 'text/plan',
    };
    var response = await http.delete(
      _deleteShootUrl(shoot.shootId),
      headers: headers,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to delete shoot: Code ${response.statusCode}");
      print(response.body);
      return false;
    }
    shootList.removeAt(index);
    shootNotifier.add(0);
    return true;
  }

  static _putSocialCountToServer(int shootId, String url) async {
    Map headers = <String, String>{
      'Accept': 'application/json',
    };
    var response = await http.put(
      url,
      headers: headers,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print(url);
      print("[DOIT GOAL API] Failed to social count: Code ${response.statusCode}");
      print(response.body);
      return null;
    }
    return response.body;
  }

  static setSocialCounter(DoitSocialType type, DoitShootModel shoot, int index) async {
    String url;
    DoitShootModel newShoot;
    String result;
    switch (type) {
      case DoitSocialType.dislikeDown:
        url = _dislikeDownUrl(DoitUserAPI.memberInfo.memberId, shoot.shootId);
        break;
      case DoitSocialType.likeDown:
        url = _likeDownUrl(DoitUserAPI.memberInfo.memberId, shoot.shootId);
        break;
      case DoitSocialType.likeUp:
        url = _likeUpUrl(DoitUserAPI.memberInfo.memberId, shoot.shootId);
        break;
      case DoitSocialType.dislikeUp:
        url = _dislikeUpUrl(DoitUserAPI.memberInfo.memberId, shoot.shootId);
        break;
    }
    result = await _putSocialCountToServer(shoot.shootId, url);
    switch (type) {
      case DoitSocialType.dislikeDown:
      case DoitSocialType.likeDown:
        // 추가 작업이 필요 없음
        break;
      case DoitSocialType.likeUp:
        if (shoot.didIdislike) {
          url = _dislikeDownUrl(DoitUserAPI.memberInfo.memberId, shoot.shootId);
          result = await _putSocialCountToServer(shoot.shootId, url);
        }
        break;
      case DoitSocialType.dislikeUp:
        if (shoot.didILike) {
          url = _likeDownUrl(DoitUserAPI.memberInfo.memberId, shoot.shootId);
          result = await _putSocialCountToServer(shoot.shootId, url);
        }
        break;
    }
    if (result != null) {
      newShoot = DoitShootModel.fromMap(jsonDecode(result));
      newShoot.imageUrl = shootList[index].imageUrl;
      shootList[index] = newShoot;
      shootNotifier.add(0);
    }
    return true;
  }

  static getShoots(DoitGoalModel goalModel) async {
    Map headers = <String, String>{'Accept': 'application/json'};
    var response = await http.get(
      _getShootsUrl(goalModel.goalId, DoitUserAPI.memberInfo.memberId),
      headers: headers,
    );
    if (response.statusCode == 400) {
      shootList = <DoitShootModel>[];
      shootNotifier.add(0);
      return true;
    }
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT GOAL API] Failed to create goal: Code ${response.statusCode}");
      print(response.body);
      return false;
    }
    List shoots = jsonDecode(response.body);
    shootList = shoots.map((map) => DoitShootModel.fromMap(map)).toList();
    if (shootList == null) {
      shootList = <DoitShootModel>[];
    }
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
    this.timerElapsed,
    this.timerTarget,
    this.imageUrl,
    @required this.shootName,
  });
  bool didILike;
  bool didIdislike;
  DateTime shootDate;
  bool overWorked;
  int numLike;
  int numDislike;
  final DoitMember shooter;
  final String shootName;
  int shootId;
  final String text;
  final int goalId;
  final int timerTarget;
  final int timerElapsed;
  String imageUrl;

  Map<String, dynamic> toJsonToShoot() => {
        'baseTime': timerTarget,
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
    List body = shoot['shootConfirmList'];
    Map textMap = body?.singleWhere((check) => check['shootConfirmType'] == 'TEXT');
    String text = textMap != null ? textMap['content'] : '';
    Map timerMap =
        body?.singleWhere((check) => check['shootConfirmType'] == 'BASE_TIMER', orElse: () {
      return null;
    });
    String timer = timerMap != null ? timerMap['content'] : null;
    List<String> times = timer?.split('/');

    return DoitShootModel(
      shootName: shoot['shootName'],
      shootId: shoot['sid'],
      numLike: shoot['likeCount'],
      numDislike: shoot['unLikeCount'],
      shooter: DoitMember.fromMap(shoot['maker']),
      shootDate: DateTime.fromMillisecondsSinceEpoch(shoot['epochDateTime'] * 1000),
      overWorked: shoot['exceeded'],
      didIdislike: map['unLikeBoolean'],
      didILike: map['likeBoolean'],
      timerTarget: times != null ? int.parse(times[1]) : null,
      timerElapsed: times != null ? int.parse(times[0]) : null,
      text: text,
    );
  }
}
