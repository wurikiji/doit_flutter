import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rest_api_test/model/user_token.dart';

class DoitUserAPI {
  static String loginAPIUrl = 'http://13.125.252.156:8080/api/member/login';
  static DoitMember memberInfo;
  static String getRefreshFirebaseTokenAPIUrl(String firebaseToken) => 'http://13.125.252.156:8080/api/member/'
      'refresh/firebasetoken/mid/${memberInfo.memberId}'
      '/token/$firebaseToken';

  static Future<DoitMember> registerTokenAndGetMid(KakaoUserToken token, FirebaseMessaging firebaseMessaging) async {
    Map headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      "firebaseToken": await firebaseMessaging.getToken(),
      "kakaoToken": token.accessToken,
    });
    var response = await http.post(
      loginAPIUrl,
      body: body,
      headers: headers,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT MEMBER API] Failed to register/refresh member: Code ${response.statusCode}");
      return DoitMember();
    }
    memberInfo = DoitMember.fromJson(jsonDecode(response.body));
    return memberInfo;
  }

  static Future<DoitMember> refreshFirebaseToken(String firebaseToken) async {
    Map headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.put(
      getRefreshFirebaseTokenAPIUrl(firebaseToken),
      headers: headers,
    );
    print(response.body);
    if (response.statusCode != 201 && response.statusCode != 200) {
      print("[DOIT MEMBER API] Failed to refresh firebase token: Code ${response.statusCode}");
      return DoitMember();
    }
    memberInfo = DoitMember.fromJson(jsonDecode(response.body));
    return memberInfo;
  }
}

class DoitMember {
  DoitMember({
    this.memberId,
  });
  final int memberId;

  factory DoitMember.fromJson(Map json) => DoitMember(
        memberId: json['mid'],
      );

  String toString() => 'Member ID: $memberId';
}
